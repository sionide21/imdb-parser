module IMDB
  module Parser
    module TakesStringInput
      attr_accessor :input
      def initialize(input)
        @input = input
      end
      private :input
    end

    class ParseError < Exception
    end
  end
end
