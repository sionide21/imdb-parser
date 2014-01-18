require 'util'


module IMDB
  class Actor
    include TakesStringInput
    def roles
      split_input[1].split(/\n/).map{ |m| Role.parse(m) }
    end
    def name
      @name ||= split_input[0]
    end

    private
    def split_input
      @split_input ||= input.strip.split("\t", 2)
    end
  end
end
