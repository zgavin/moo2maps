class Generator
  module Configuration
  
    def self.included base
      base.extend ClassMethods
    end
    
    def configuration
      self.class.configuration
    end
    
    module ClassMethods
      
      def configuration
        
      end
      
    end
    
    
    class Instance < BasicObject
      
      def initialize klass
        @data 
      end
      
      def merge other
      
      end
      
      def method_missing sym,*args,&block
        
        super
      end
    end
    
  end
  
end