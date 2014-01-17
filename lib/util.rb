module IMDB
  module TakesStringInput
    attr_accessor :input
    def initialize(input)
      @input = input
    end
    private :input
  end
end
