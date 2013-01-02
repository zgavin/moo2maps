module Generators
  class MirrorHomeStars < Generator
    include Generators::Modules::StarMirror
    
    def transform
      original =  active_players.first.home_planet.star
      active_players[1..-1].map(&:home_planet).map(&:star) do |clone| mirror_star original,clone end
    end
  end
end
  