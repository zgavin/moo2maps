class Point < Struct.new(:x,:y)
  def + other 
    Point.new(self.x+other.x,self.y+other.y)
  end
  
  def * scalar
    Point.new(self.x*scalar,self.y*scalar)
  end
  
  def == other
    other.x == x and other.y == y
  end
  
  def distance_to other
    Math.sqrt((x-other.x)**2+(y-other.y)**2)
  end
end
