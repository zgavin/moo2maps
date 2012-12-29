class Planet
  include Model

  belongs_to :star,:colony

  def clear
    colony.clear if colony.andand.planet == self
    
    planet_index = self.star.planet_index.index(self.id)
    
    star.planet_index[planet_index] = -1 if planet_index
    
    super
  end

  def size= size
    self.max_farms = [2,4,5,7,10][size]
    @size = size
  end
  
  def climate= climate
    self.food_per_farmer = [0, 0, 0, 1, 1, 2, 2, 1, 2, 3][climate]
    @climate = climate
  end
  
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
    star[orbit] = nil if star and star.planets.include? self
    super
  end
  
  def star= value
    star[orbit] = nil if star and star.planets.include? self
    super
  end
end