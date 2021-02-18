require_relative '../lib/poll'

expired_date = Date.new(1970, 1, 1)
valid_date = Date.today + 2

RSpec.describe Poll do
  it 'has a title and candidates' do
    poll = Poll.new('Awesome Poll', ['Alice', 'Bob'])

    expect(poll.title).to eq 'Awesome Poll'
    expect(poll.candidates).to eq ['Alice', 'Bob']
  end

  it 'may have an expiration date' do
    poll = Poll.new('Awesome Poll', ['Alice', 'Bob'], valid_date)

    expect(poll.title).to eq 'Awesome Poll'
    expect(poll.candidates).to eq ['Alice', 'Bob']
    expect(poll.expiresAt).to eq valid_date
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

    context 'to an expired poll' do
      it 'raises VoteToExpiredPollError' do
        poll = Poll.new('Awesome Poll', ['Alice', 'Bob'], expired_date)
        vote = Vote.new('Miyoshi', 'Alice')

        expect { poll.add_vote(vote) }.to raise_error Poll::VoteToExpiredPollError
      end
    end
  end

  describe '#count_votes' do
    it 'counts the votes and returns the result as a hash' do
      poll = Poll.new('Awesome Poll', ['Alice', 'Bob'])
      poll.add_vote(Vote.new('Carol', 'Alice'))
      poll.add_vote(Vote.new('Dave', 'Alice'))
      poll.add_vote(Vote.new('Ellen', 'Bob'))

      result = poll.count_votes

      expect(result['Alice']).to eq 2
      expect(result['Bob']).to eq 1

      poll2 = Poll.new('Great Poll', ['Alice', 'Bob'])
      poll2.add_vote(Vote.new('Carol', 'Bob'))
      poll2.add_vote(Vote.new('Dave', 'Bob'))

      result2 = poll2.count_votes

      expect(result2['Alice']).to eq 0
      expect(result2['Bob']).to eq 2
    end
  end
end