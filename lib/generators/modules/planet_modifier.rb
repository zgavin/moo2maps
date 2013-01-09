module Generators
  module Modules
   module PlanetModifier
     def modify_planets property, opts
       conditions = (opts.when.is_a? Array and opts.when or [opts.when])
       
       results = (opts.to.is_a? Array and opts.to or [opts.to])
       
       active_planets.select do |p| conditions.any? do |m| p.send("#{m.parameterize.underscore}?") end end.each do |planet|
         result = results.sample
         
         planet.send("#{property}=", result)
       end
     end
   end 
  end
end