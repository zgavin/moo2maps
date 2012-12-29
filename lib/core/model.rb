module Model
  module ClassMethods
    def inheritance_module &block
      (@inheritance_module ||= Module.new.tap do |m| include m end).tap do |m|
        m.instance_exec &block if block
      end
    end
  end

  def self.included base
    base.instance_exec do
      [Parsing,Reflection,Configuration].each do |m| include m end
      extend ClassMethods
    end
  end
  
  def to_s
    "".tap do |s|
      s.extend IOString
      dump s
    end
  end
  
  def dead?
    false
  end

  def inspect
    "#<#{self.class.name}:0x#{(self.object_id << 1).to_s(16).rjust(14,'0')} #{self.class.properties.select do |p| ['integer','string'].include? p.type end.map do |p| "#{p.name}=#{self.send(p.name).inspect}" end.join " "}>"
  end

end