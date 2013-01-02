module Model
  module Reflection
    
    class Reflection < Struct.new(:name,:kind,:klass,:options)
      def name
        super.andand.to_s
      end
      
      def key
        (options[:key] or "#{name}_id").to_s
      end

      def type
        (options[:type] or name.singularize).to_s
      end
      
      def default
        (options[:default] or klass.property(key).default)
      end
      
      def inverse
        (options[:inverse] or klass.name.underscore).to_s
      end
    end
    
    def self.included base
      base.extend ClassMethods
      [HasId,HasMany,BelongsTo,Pointable].each do |m|
        base.send(:include,m)
        base.extend m.const_get(:ClassMethods)
      end
    end
    
    module ClassMethods
      def method_missing sym,*args,&block
        return super unless sym.to_s.ends_with? "_reflections"
        
        kind = sym.to_s.chomp "_reflections"
        reflections.select do |reflection| reflection.kind == kind end
      end
      
      def reflections
        @reflections ||= []
      end
    end
  end
end
