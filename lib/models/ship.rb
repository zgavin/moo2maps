class Ship
  include Model
  
  belongs_to :player, :star
  
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

end