require 'date'

class Poll
    class InvalidCandidateError < StandardError
    end

    class DuplicatedVoterError < StandardError
    end

    attr_reader :title, :candidates, :expiresAt, :votes
    def initialize(title, candidates, expiresAt = Date.new)
        @title = title
        @candidates = candidates
        @expiresAt = expiresAt
        @votes = []
    end

    def add_vote(vote)
        unless candidates.include?(vote.candidate)
            raise InvalidCandidateError
        end
        if votes.each.any? {|v| votes.count {|v2| v2.voter == v.voter}}
            raise DuplicatedVoterError
        end
        @votes.push(vote)
    end
end