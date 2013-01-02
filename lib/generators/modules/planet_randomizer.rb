module Generators
  module Modules
    module PlanetRandomizer
      def randomize_planet planet
        throw "cannot randomize planet without a star" unless planet.star
        planet.type = 3
    
        sizes = conf.planet_randomizer.size
        
        planet.size = sizes.count.times.find do |i| sizes[i] > rand(10) end
    
        planet.minerals = conf.planet_randomizer.minerals[rand(10)].split(/\s+/)[planet.star.spectral_class].to_i
    
        planet.gravity = conf.planet_randomizer.gravity[planet.minerals].split(/\s+/)[planet.size].to_i
    
        planet.group = conf.planet_randomizer.group[planet.star.spectral_class].split(/\s+/)[planet.orbit].to_i
    
        climates = conf.planet_randomizer.climate.send([:mineral_rich,:average,:organic_rich][galaxy_age]).map do |c| 
          c.split(/\s+/)[planet.group].to_i
        end
    
        sum = 0
        random = rand(climates.sum)

        planet.climate = climates.count.times.find do |i| sum += climates[i]; sum >= random end-1
      end
    end
  end
end
