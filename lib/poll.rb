require 'date'

class Poll
    attr_reader :title, :candidates, :expiresAt
    def initialize(title, candidates, expiresAt = Date.new)
        @title = title
        @candidates = candidates
        @expiresAt = expiresAt
    end
end