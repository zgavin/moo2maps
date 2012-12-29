module Model
  module Parsing
    def pack_format property
      format = ({1 => 'C', 2 =>'S', 4 => 'L', 8 => 'Q'}[property.size] or 'c'*property.size)
      format.downcase! if property.signed?
      format
    end
    
    def read io
      self.class.properties.each do |property| 
        property.count.times do |i|
          value = (property.simple? and self.send("read_#{property.type.downcase}" ,property,io) or read_object property,io,i)
          self.send("#{property.name}=",value) unless property.array?
          self.send(property.name)[i] = value if property.simple? and property.array?
        end
      end
      self
    end
    
    def read_integer property,io
      io.read(property.size).unpack(pack_format(property)).first
    end
  
    def read_string property,io
      property.size > 0 and io.read(property.size) or io.read
    end
  
    def read_object property,io,i=0
      (property.array? and self.send(property.name)[i].tap do |obj| m = "#{self.class.name.underscore}="; obj.send(m,self) if obj.respond_to? m end or self.class.const_get(property.type).new).read(io)
    end
    
    def write io
      self.class.properties.each do |property| 
        property.count.times do |i|
          value = (property.array? and self.send(property.name)[i] or self.send(property.name))
          m = "write_#{property.type.downcase}" 
          self.respond_to? m and self.send(m,property,value,io) or write_object(property,value,io)
        end
      end
    end
  
    def write_integer property,value,io
      io.write([value].pack(pack_format(property)))
    end
  
    def write_string property,value,io
      v = (property.size > 0 and value.ljust(property.size,"\x00") or value)
      io.write(v)
    end

    def write_object property,value,io
      value.respond_to? :write  and value.write(io) or write_string(property,value.to_s)
    end

  
    def clear
      self.class.properties.each do |property|
        if property.simple? then
          self.instance_variable_set("@#{property.name}",nil)
        else
          v = self.send(property.name)
          (property.array? and v or [v]).each &:clear
        end
      end
    end
  end
end