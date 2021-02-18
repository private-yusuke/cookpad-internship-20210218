require 'date'

class Poll
    class InvalidCandidateError < StandardError
    end

    class DuplicatedVoterError < StandardError
    end

    class VoteToExpiredPollError < StandardError
    end

    attr_reader :title, :candidates, :expiresAt, :votes
    def initialize(title, candidates, expiresAt = Date.today + 1)
        @title = title
        @candidates = candidates
        @expiresAt = expiresAt
        @votes = []
    end

    def add_vote(vote)
        unless candidates.include?(vote.candidate)
            raise InvalidCandidateError
        end
        if votes.map {|v| v.voter}.include?(vote.voter)
            raise DuplicatedVoterError
        end
        if @expiresAt < Date.today
            raise VoteToExpiredPollError
        end
        @votes.push(vote)
    end

    def count_votes
        res = Hash.new(0)
        @candidates.each { |candidate| res[candidate] = 0 }
        @votes.each { |v| res[v.candidate]+=1 }
        res
    end
end