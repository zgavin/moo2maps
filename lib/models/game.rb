class Game
  include Model  
  
  ['star','colony','ship','planet','player'].each do |n|
    define_method "active_#{n.pluralize}" do
      self.send(n.pluralize)[0..(self.send("#{n}_count")-1)]
    end
    
    define_method "inactive_#{n.pluralize}" do
      self.send(n.pluralize)[self.send("#{n}_count")..-1]
    end
  end  
end