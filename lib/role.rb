require 'util'

module IMDB
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
      matches[:credit].to_i
    end
    private
    def matches
      @matches ||= /^(?<title>.*?) +\((?<year>\d{4})\) +\[(?<character>.+?)\] +<(?<credit>\d+)>$/.match(input)
    end
  end

  class TVRole < Role
    def type
      :tv
    end
  end
end