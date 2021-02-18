require_relative '../lib/poll'

RSpec.describe Poll do
  it 'has a title and candidates' do
    poll = Poll.new('Awesome Poll', ['Alice', 'Bob'])

    expect(poll.title).to eq 'Awesome Poll'
    expect(poll.candidates).to eq ['Alice', 'Bob']
  end

  it 'may have an expiration date' do
    poll = Poll.new('Awesome Poll', ['Alice', 'Bob'], Date.new(2021, 2, 18))

    expect(poll.title).to eq 'Awesome Poll'
    expect(poll.candidates).to eq ['Alice', 'Bob']
    expect(poll.expiresAt).to eq Date.new(2021, 2, 18)
  end

  describe '#add_vote' do
    it 'saves the given vote' do
      poll = Poll.new('Awesome Poll', ['Alice', 'Bob'])
      vote = Vote.new('Miyoshi', 'Alice')

      poll.add_vote(vote)

      expect(poll.votes).to eq [vote]
    end

    context 'with a vote that has an invalid candidate' do
      it 'raises InvalidCandidateError' do
        poll = Poll.new('Awesome Poll', ['Alice', 'Bob'])
        vote = Vote.new('Miyoshi', 'INVALID')

        expect { poll.add_vote(vote) }.to raise_error Poll::InvalidCandidateError
      end
    end

    context 'with a vote whose voter is duplicated' do
      it 'raises DuplicatedVoterError' do
        poll = Poll.new('Awesome Poll', ['Alice', 'Bob'])
        vote = Vote.new('Miyoshi', 'Alice')
        dup_vote = Vote.new('Miyoshi', 'Bob')

        poll.add_vote(vote)

        expect { poll.add_vote(dup_vote) }.to raise_error Poll::DuplicatedVoterError
      end
    end
  end
end