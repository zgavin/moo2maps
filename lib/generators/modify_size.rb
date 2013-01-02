module Generators
  class ModifySize < Generator
    include Generators::Modules::PlanetModifier
    
    def transform
      modify_planets 'size',conf.size
    end
  end
end