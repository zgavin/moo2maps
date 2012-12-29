module Model
  module Reflection
    module Pointable
      
      module ClassMethods
        def pointable
          inheritance_module do
            define_method :point do
              Point.new(self.x,self.y)
            end
  
            define_method :point= do |point|
              self.x = point.x.to_i
              self.y = point.y.to_i
            end
          end
        end
      end
      
    end
  end
end