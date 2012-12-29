module Model
  module Reflection
    module BelongsTo
      module ClassMethods
        def belongs_to *args
          has_id
          
          options = args.last.andand.is_a?(Hash) ? args.pop : {}
          
          args.each do |name|
            reflection = Reflection.new name,"belongs_to",self,options
            self.reflections << reflection
          
            inheritance_module do
              define_method reflection.key do
                self.send(name).andand.id || reflection.default
              end
              
              define_method "#{reflection.key}=" do |value|
                self.instance_variable_set("@#{name}", (value and value >=0 and self.game.send(reflection.type.underscore.pluralize)[value] or nil))
              end
              
              define_method name do
                self.instance_variable_get "@#{name}"
              end
              
              define_method "#{name}=" do |value|
                self.instance_variable_set "@#{name}", value
              end
            end
          end
        end
      end
    end
  end
end