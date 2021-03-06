module Generators
  module Modules
    module StarMirror
      def mirror_star original, clone   
        original_colonies = original.planets.compact.select &:colony
        clone_colonies = clone.planets.compact.select &:colony
        
        throw "cannot mirror systems with different numbers of colonies" unless  clone_colonies.count == original_colonies.count
        
        clone.spectral_class = original.spectral_class

        original_colonies.each_with_index do |original_planet,i|
          clone_planet = clone_colonies[i]
          
          if clone_planet.orbit != original_planet.orbit then
            clone.planets[clone_planet.orbit] = clone.planets[original_planet.orbit]
            
            clone.planets[original_planet.orbit] = clone_planet
          end
        end
        
        original.planets.each_with_index do |original_planet,i|
          next if original_planet.andand.colony
          
          clone_planet = clone.planets[i]
          
          if original_planet and not clone_planet then
            clone_planet = inactive_planets.first
            clone.planets[i] = clone_planet
            self.planet_count += 1
          elsif clone_planet and not original_planet then
            clone.planets[i] = nil
            clone_planet.id = (planet_count-1)
            clone_planet.clear
            self.planet_count -= 1
          end
          
          
          [:type,:climate,:gravity,:size,:minerals,:group,:planet_special].each do |m| clone_planet.send("#{m}=",original_planet.send(m)) end if original_planet
        end
      end 
    end
  end
end