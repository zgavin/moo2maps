module Generators
  class ModifyGravity < Generator
    include Generators::Modules::PlanetModifier
    
    def transform
      modify_planets 'gravity',conf.gravity
    end
  end
end