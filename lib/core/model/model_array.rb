module Model
  class ModelArray < Array
    
    def initialize property
      @property = property
      super()
    end
    
    def []= key,value
      self[key].instance_variable_set "@id",nil if get(key).andand.id == key
      super.tap do 
        value.instance_variable_set "@id",key 
      end
    end
    
    alias_method :get,:[]
    
    def [] key
      ret = super
      unless ret then
        ret = self.class.const_get(@property.type).new
        ret.instance_variable_set "@id",key if ret.respond_to? :id=
        self[key] = ret
      end

      ret.is_a? ModelArray and ret.to_a or ret      
    end
  end
end