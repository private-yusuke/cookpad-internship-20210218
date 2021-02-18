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
end