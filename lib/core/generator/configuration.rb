class Generator
  module Configuration
  
    def self.included base
      base.instance_exec do
        extend ClassMethods
      end
    end
    
    def conf 
      self.class.conf
    end

    module ClassMethods
      def conf
        @configuration ||= Configuration::Instance.new self
      end
      
      def include *args
        super.tap do conf.send :__add_modules,*args end
      end
    end
    
    class Instance
      def initialize mod, data=nil
        @mod = mod
        @data = data
      end
      
      def respond_to? sym
        m = sym.to_s
        
        super or 
        __data.has_key? m or 
        __modules.has_key? m or
        (@mod.is_a? Class and @mod.superclass.respond_to? :conf and @mod.superclass.conf.respond_to? sym) or
        (m.ends_with? '?' and self.respond_to? m.chomp('?'))
      end
      
      def method_missing sym,*args,&block
        puts sym or super unless respond_to? sym

        m = sym.to_s
        
        blk = if m.ends_with? '?' then   
          proc do self.send(m.chomp('?')).present? end
        elsif __data.has_key? m then
          proc do
            v =  __data[m]
            v.is_a? Hash and (__data[m] = Instance.new(@mod,v)) or v
          end 
        elsif __modules.has_key? m then
          proc do __modules[m] end 
        else
          proc do @mod.superclass.conf.send(sym) end
        end
        
        singleton_class.instance_exec do define_method sym,&blk end
        
        self.send sym
      end
      
      private
      def __data
        @data ||= begin
          path = File.join ROOT_DIR,'config',"#{@mod.name.underscore}.yml"
          
          File.exists? path and YAML.load(File.read(path)) or {}
        end
      end
      
      def __add_modules *args
        args.each do |mod| __modules[mod.name.demodulize.underscore] = Instance.new(mod) end
      end
      
      def __modules
        @modules ||= {}
      end
    end
  end
end