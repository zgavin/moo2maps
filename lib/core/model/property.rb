module Model
  class Property
    DEFAULTS = { signed: false, type: "integer", count:1}.stringify_keys!
    
    attr_reader :name, :owner, :attributes, *(DEFAULTS.keys)
    
    alias_method :signed?,:signed
    
    def initialize name, owner, attributes
      @name = name
      @owner = owner
      
      @attributes = DEFAULTS.merge((attributes or {}))
      
      @attributes.each do |k,v| self.instance_variable_set("@#{k}",v) end
    
      prop = self
      
      owner.inheritance_module do
        define_method name do 
          var_name = "@#{name}"
          self.instance_variable_get(var_name) || self.instance_variable_set(var_name,prop.default)
        end unless method_defined? name
        
        define_method "#{name}=" do |value|
          self.instance_variable_set "@#{name}",value
        end unless method_defined? "#{name}=" or prop.array?
      end
    end
    
    def simple?
      ['string','integer'].include? type.downcase 
    end
    
    def array?
      count > 1
    end
    
    def size 
      simple? and (@size or 1) or (Kernel.const_get(type).dump_size rescue 0)
    end
    
    def default
      if simple? 
        v =  (type == "string" and (@default or "\x00"*size).force_encoding Encoding::BINARY or (@default or 0))
        array? ? (1..count).map do v end :  v
      else
        array? ? Model::ModelArray.new(self) : self.class.const_get(type).new
      end
    end
  end
end