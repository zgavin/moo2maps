module Generators
  class UninhabitableStars < Generator
    include Modules::PlanetRandomizer
  
    def transform
      active_stars.select do |star| not star.black_hole? and star.planets.compact.empty? end.each do |star|
        conf.number_of_planets[rand(10)].split(/\s+/)[star.spectral_class].to_i.times do |i|
          planet = inactive_planets.first  
          orbit = rand(5)
          orbit = rand(5) while star.planets[orbit]
          
          planet.colony = nil
          
          star.planets[orbit] = planet
          
          randomize_planet planet
          self.planet_count += 1
        end
      end
    
      active_stars.select do |star| 
        not star.black_hole? and star.planets.compact.none? do |p| p.habitable? end 
      end.each do |star| 
        randomize_planet(star.planets.compact.sample) 
      end
    end
  end
end