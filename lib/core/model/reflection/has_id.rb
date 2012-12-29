module Model
  module Reflection
    module HasId
    
      module ClassMethods
        def has_id
          include HasIdMethods  unless included_modules.include? :HasIdMethods
        end
      end
      
      module HasIdMethods
        def game 
          @game
        end
      
        def game= game
          @game = game
        end
      
        def id  
          @id ||= game.send(self.class.name.underscore.pluralize).index self
        end
      
        def id= new_id
          all_objects = game.send(self.class.name.underscore.pluralize)
          
          all_objects[@id] = all_objects[new_id] if @id
          all_objects[new_id] = self
        end
      end
    end
  end
end