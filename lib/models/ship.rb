class Ship
  include Model
  
  belongs_to :star
  
  attr_accessor :player
  
  pointable
  
  def dead? 
    status == 5
  end
  
  def travelling?
    status == 1
  end
  
  #for some reason travelling ships have their destination star_id incremented by 500
  def star_id
    super() + (travelling? ? 500 : 0)
  end
  
  def star_id= val
    super(travelling? ? val-500 : val)
  end
  
  def player_id 
    player.andand.id or super
  end
  
  def player_id= value
    value.between? 0,7 ? super : self.player = game.players[value]
  end
end