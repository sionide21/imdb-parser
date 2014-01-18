require 'util'
require 'role'
require 'actor'


module IMDB
  class Parser
    include Enumerable
    attr_reader :input

    def initialize(input)
      if input.respond_to? :gets
        @input = input
      else
        @input = StringIO.new(input.strip)
      end
    end

    def each
      strip_header
      record = ""
      input.each do |line|
        if line.strip.empty?
          yield Actor.new(record)
          record = ""
        elsif line.strip =~ /^-+$/
          break
        else
          record << line
        end
      end
      unless record.strip.empty?
        yield Actor.new(record)
      end
    end

    def actors
      self.to_a
    end

    private :input

    def strip_header
      while input.gets.strip !~ /^Name\s+Titles$/
      end
      input.gets
    end
  end
end
