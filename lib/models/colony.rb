class Colony
  include Model

  belongs_to :planet,:player

  def clear 
    self.planet.colony = nil if self.planet.andand.colony == self
    
    super
  end
  
  def dead?
    not planet or self.id >= game.colony_count or planet.dead?
  end

end