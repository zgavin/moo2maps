class Point
  
  attr_accessor :x,:y
  
  def initialize x,y=nil
    if y then
      @x = x
      @y = y
    else
      @x = Math.cos(x)
      @y = Math.sin(x)
    end
    
  end

  def + other 
    Point.new(self.x+other.x,self.y+other.y)
  end
  
  def * scalar
    scalar = (scalar.is_a? Array and scalar or [scalar,scalar])
    Point.new(self.x*scalar.first,self.y*scalar.last)
  end
  
  def == other
    other.x == x and other.y == y
  end
  
  def distance_to other
    Math.hypot(x-other.x,y-other.y)
  end
end
