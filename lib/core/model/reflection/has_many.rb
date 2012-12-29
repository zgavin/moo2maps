module Model
  module Reflection
    module HasMany
      module ClassMethods
        def has_many *args
          has_id
          
          options = args.last.andand.is_a?(Hash) ? args.pop : {}
          
          args.each do |name|
            reflection = Reflection.new name,"has_many",self,options
            self.reflections << reflection
          
            inheritance_module do
              define_method name do
                self.game.send(reflection.type.underscore.pluralize).select do |obj| obj.send(reflection.inverse) == self and not obj.dead? end
              end
            end
          end
        end
      end
    end
  end
end