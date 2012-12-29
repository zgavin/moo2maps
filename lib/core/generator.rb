class Generator
  
  attr_reader :game
  
  def initialize game
    @game = game
  end

  def width
    @width ||= (self.stars.map(&:x).max / 203.0).ceil*203
  end
  
  def height
    @height ||= (self.stars.map(&:y).max / 200.0).ceil*200
  end
  
  def transform_planets
    active_planets.select do |p| p.type == 3 end.each do |planet|
      configuration.planets_transforms.each do |prop,values|
        condition = values[:when]
        
        current_value = planet.send(prop)
        planet.send("#{prop}=",(rand(values[:max]-values[:min]+1)+values[:min])) if values[:when].is_a? Array and values[:when].include? current_value or values[:when] == current_value
      end
    end
  end 
    

  
  def transform
    transform_planets
  end
  
  def clear_wormholes 
    stars.each do |s| s.wormhole_star = nil end
  end
  
  def method_missing sym,*args,&block
    return super unless game.respond_to? sym
  
    self.game.send sym,*args&block
  end
  
  def respond_to? sym
    super or game.respond_to? sym
  end
end