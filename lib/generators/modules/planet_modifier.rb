module Generators
  module Modules
   module PlanetModifier
     def modify_planets property, conf
       condition = (conf.when.is_a? Array and conf.when or [options.when])
       
       active_planets.each do |planet|
         planet.send("#{property}=", rand(max-min+1)+min) if condition.include? planet.send(property)
       end
     end
   end 
  end
end