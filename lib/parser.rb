require 'util'
require 'role'


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
      record = ""
      input.each do |line|
        if line.strip.empty?
          yield Actor.new(record)
          record = ""
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
  end

  class Actor
    include TakesStringInput
    def roles
      input.strip.gsub(/^.+?\t/, '').split(/\n/).map{ |m| Role.parse(m) }
    end
  end

end
