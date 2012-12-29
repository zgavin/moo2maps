class Leader
  include Model
  
  belongs_to :player
  
  def colony_leader?
    type == 1
  end
  
  def ship_leader?
    type == 0
  end
  
  def location_id
    (colony_leader? ? star : ship).andand.id or -1
  end
  
  def location_id= location_id
    instance_variable_set "@#{colony_leader? ? 'star' : 'ship'}", game.send(colony_leader? ? 'stars' : 'ships')[location_id] if location_id >= 0
  end
  
  def star
    @star if colony_leader?
  end
  
  def star= star
    @star = star if colony_leader?
  end
  
  def ship
    @ship if ship_leader?
  end
  
  def ship= ship
    @ship = ship if ship_leader?
  end
  
end