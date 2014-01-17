require 'util'
require 'role'


module IMDB
  class Parser
    include TakesStringInput

    def actors
      input.split(/\n\n/).map{ |a| Actor.new(a) }
    end
  end

  class Actor
    include TakesStringInput
    def roles
      input.strip.gsub(/^.+?\t/, '').split(/\n/).map{ |m| Role.parse(m) }
    end
  end

end
