require 'imdb/parser/util'

module IMDB
  module Parser
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
        matches[:year].to_i if matches[:year]
      end

      def character
        matches[:alt_character] or matches[:character]
      end

      def credit
        matches[:credit].to_i if matches[:credit]
      end

      private

      def matches
        @matches ||= self.class.cached_regex.match(input)
      end
      def self.cached_regex
        @regex ||= Regexp.new regex
      end
      def self.regex
        /^(?<title>.+?)\s+
          #{year_regex} \s*?
          \)? \s*  # One of the records has a random trailing paren
          (?:\((?:uncredited|TV|V|.+?)\))? \s*?
          (?<suspended>{{SUSPENDED}})? \s*?
          (?:\(rumored\))? \s*?
          #{alt_character_regex} \s*?
          (?:\[(?<character>.+?)\])? \s*?
          (?:<(?<credit>\d+)>)?
        $/x
       end

       def self.year_regex
         /\((?:(?<year>\d{4})|[\?]{4})(:?\/[IVX]+?)?\)/
       end
       def self.alt_character_regex
         /(?:\((?:uncredited|as\s(?<alt_character>.+?)|.+?)\))?/
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
        (matches[:season] or matches[:episode_title]).to_i
      end

      def episode
        matches[:episode].to_i if matches[:episode]
      end

      private
      def self.regex
        /^"(?<title>.+?)"\s+
          #{year_regex}
          (:?\s{(:?
            (?<episode_title>.+?)? \s*? \(\#(?<season>\d+)\.(?<episode>\d+)\) |
            \((?<episode_title>[\d\-]+)\) |
            (?<episode_title>.+?)
          )})? \s*?
          #{alt_character_regex} \s*?
          (?:\[(?<character>.+?)\])?\s*?
          (?:<(?<credit>\d+)>)?
        $/x
      end
    end
  end
end
