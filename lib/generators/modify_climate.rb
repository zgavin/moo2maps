module Generators
  class ModifyClimate < Generator
    include Generators::Modules::PlanetModifier
    
    def transform
      modify_planets 'climate',conf.climate
    end
  end
end