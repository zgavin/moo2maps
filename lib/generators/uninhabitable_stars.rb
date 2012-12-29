module Generators
class UninhabitableStars < Generator
  
  include Modules::PlanetRandomizer
  
  def transform
    active_stars.select do |star| star.planets.count == 0 end end.each do |star|
      configuration.uninhabitable_stars.number_of_planets[rand(10)][star.spectral_class].times do |i|
        planet = inactive_planets.first  
        orbit = rand(5)
        orbit = rand(5) while star.planets[orbit]
          
        star.planets[orbit] = planet
          
        randomize_planet planet
        self.planet_count += 1
      end
    end
    
    active_stars.select do |star| star.planets.none? do |p| p.type == 3 end end.each do |star| randomize_planet star.planets.compact.sample end
  end
end