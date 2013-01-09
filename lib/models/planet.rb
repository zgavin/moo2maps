class Planet
  include Model
  
  CLIMATES = [:toxic, :radiated, :barren, :desert, :tundra, :ocean, :swamp, :arid, :terran, :gaia]
  GRAVITIES = ["Low G", "Normal G", "Heavy G"]
  MINERALS = ["Ultra Poor","Poor","Abundant","Rich","Ultra Rich"]
  SIZES = ["Tiny","Small","Medium","Large","Huge"]
  
  belongs_to :star,:colony

  def clear
    colony.clear if colony.andand.planet == self
    
    planet_index = (star and star.planet_index.index(self.id) or nil)
    
    star.planet_index[planet_index] = -1 if planet_index
    
    super
  end
  
  def name
    star and "#{star.display_name} #{['I','II','III','IV','V'][orbit]}" or "Planet #{id}"
  end
  
  def habitable?
    type == 3 or type == 4
  end
  
  {'climate'=>CLIMATES,"gravity"=>GRAVITIES,'minerals'=>MINERALS,'size'=>SIZES}.each do |prop,list|
    list = list.map(&:to_s).map(&:downcase)
    
    list.each_with_index do |name,i|
      define_method "#{name.parameterize.underscore}?" do send(prop) == i end
    end
    
    old = instance_method("#{prop}=")
    
    define_method "#{prop}=" do |value|
      old.bind(self).call(value.is_a?(Numeric) ? value : list.map(&:downcase).index(value.to_s.downcase))
    end
    
    define_method "#{prop}_as_string" do
      list[self.send prop]
    end
  end

  def size_with_max_farms= size
    (self.size_without_max_farms = size).tap do
      self.max_farms = [2,4,5,7,10][self.size]
    end
  end
  
  alias_method_chain :size=,:max_farms
  
  def climate_with_food_per_farmer= climate
    (self.climate_without_food_per_farmer = climate).tap do
      self.food_per_farmer = [0, 0, 0, 1, 1, 2, 2, 1, 2, 3][self.climate]
    end
  end
  
  alias_method_chain :climate=,:food_per_farmer
  
  def id= value
    index = star.planet_index.index self.id
    super
    star.planet_index[index] = value if index
    value
  end

  def dead? 
    not star or (not star.planets.include? self) or self.id >= game.planet_count or star.dead?
  end

  def orbit
    star and star.planets.index(self) or super
  end
  
  def star_id= value
    star.planets[orbit] = nil if star and star.planets.include? self
    super
  end
  
  def star= value
    star.planets[orbit] = nil if star and star.planets.include? self
    super
  end
end