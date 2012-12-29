class Player
  include Model

  has_many :leaders,:ships,:stars,:colonies
  
  belongs_to :home_planet,:type=>"planet"
  
  
  
end