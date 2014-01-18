require 'util'

module IMDB
  class ParseError < Exception
  end
  class Role
    include TakesStringInput
    def self.parse(input)
      input = input.strip
      if input =~ /^"/
        TVRole.new(input)
      else
        new(input)
      end
    end

    def initialize(*args)
      super
      raise ParseError.new(input) if matches.nil?
    end
    def type
      :movie
    end

    def title
      matches[:title]
    end

    def year
      matches[:year].to_i
    end

    def character
      matches[:character]
    end

    def credit
      matches[:credit].to_i if matches[:credit]
    end

    private

    def matches
      @matches ||= regex.match(input)
    end
    def regex
       /^(?<title>.+?) +\((?<year>\d{4})\)(?: +?\((?:uncredited|TV)\))? +\[(?<character>.+?)\](?: +<(?<credit>\d+)>)?$/
     end
  end

  class TVRole < Role
    def type
      :tv
    end

    def episode_title
      matches[:episode_title]
    end

    def season
      matches[:season].to_i
    end

    def episode
      matches[:episode].to_i
    end
    private
    def regex
      /^"(?<title>.+?)" +\((?<year>\d{4})\) {(:?(?<episode_title>.+?) +)?\(#(?<season>\d+)\.(?<episode>\d+)\)}(?: +?\(uncredited\))? +\[(?<character>.+?)\](?: +<(?<credit>\d+)>)?$/
    end
  end
end
