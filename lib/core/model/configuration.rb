module Model
  module Configuration
    
    def self.included base
      base.extend ClassMethods
    end
    
    module ClassMethods
      def write_size
        self.properties.map do |property| property.size*property.count end.sum
      end
    
      def properties
        @properties ||= YAML.load(File.read(File.join(ROOT_DIR,'config','models',"#{self.name.underscore}.yml"))).map do |name,attributes| Model::Property.new(name,self,attributes) end
      end
    
      def property_offset name
        properties[0..(property_index(name)-1)].map do |p| p.size*p.count end.sum
      end
    
      def property name
        properties.find do |p| p.name == name end
      end
    
      def property_index name
        properties.index do |p| p.name == name end
      end
    end
  end
end
  