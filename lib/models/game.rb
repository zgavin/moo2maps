class Game
  include Model
  
  def cleanup count
    self.star_count = count
    
    active_stars.each do |star|
      star.wormhole_star_id = -1 if star.wormhole_star.andand.dead?
    end
    
    active_stars.map(&:planets).flatten.tap do |known_planets| 
      self.planet_count = known_planets.count

      known_planets.select(&:dead?).each do |planet|
        planet.swap_to(active_planets.index &:dead?)
      end
      
      known_planets.map(&:colony).compact do |known_colonies|
        self.colony_count = known_colonies.count
        
        known_colonies.select(&:dead?).each do |colony|
          colony.swap_to active_colonies.index(&:dead?)
        end
      end
    end
    
    lost_ships = active_ships.select do |ship| ship.star == nil or ship.star.dead? end
      
    (active_ships-lost_ships).each do |ship| ship.point = ship.star.point end
    
    (lost_ships+inactive_stars+inactive_colonies+inactive_ships+inactive_planets).each &:clear
  end
  
  
  
  ['star','colony','ship','planet','player'].each do |n|
    define_method "active_#{n.pluralize}" do
      self.send(n.pluralize)[0..(self.send("#{n}_count")-1)]
    end
    
    define_method "inactive_#{n.pluralize}" do
      self.send(n.pluralize)[self.send("#{n}_count")..-1]
    end
  end
  

  
  
end