module Generators
  class ModifyMinerals < Generator
    include Generators::Modules::PlanetModifier
    
    def transform
      modify_planets 'minerals',conf.minerals
    end
  end
end