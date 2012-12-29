module Generators
  module Modules
    module PlanetRandomizer
      def randomize_planet planet
        return unless planet.star
        planet.type = 3
    
        sizes = configuration.randomized_planet.size
        planet.size = sizes.count.times.find do |i| sizes[i] > rand(10) end
    
        planet.mineral_class = configuration.randomized_planet.mineral_class[rand(10)][planet.star.spectral_class]
    
        planet.gravity = configuration.randomized_planet.gravity[planet.mineral_class][planet.size]
    
        planet.group = configuration.randomized_planet.group[planet.star.spectral_class][planet.orbit]
    
        climates = configuration.randomized_planet.climates.send([:mineral_rich,:average,:organic_rich][galaxy_age]).map do |c| c[planet.group] end
    
        sum = 0
        random = rand(climates.sum)
    
        planet.climate = climates.count.times.find do |i| sum += climates[i]; sum < random end
      end
    end
  end
end
