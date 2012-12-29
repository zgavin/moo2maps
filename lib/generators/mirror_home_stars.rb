module Generators
  class MirrorHomeStars < Generator
    
    def transform
      players.map(&:)
    end
    
  end
end
  