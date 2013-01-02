module Generators
  module Modules
  end
end

class Generator
  include Configuration
  
  attr_reader :game
  
  def initialize game
    @game = game
  end

  def width
    @width ||= (self.stars.map(&:x).max / 253.0).ceil*253
  end
  
  def height
    @height ||= (self.stars.map(&:y).max / 200.0).ceil*200
  end
  
  def aspect_ratio
    @aspect_ratio ||= width.to_f/height
  end
  
  def transform
    
  end
  
  def center_point
    Point.new(width/2,height/2)
  end
  
  def cleanup count
    self.star_count = count
    
    active_stars.each do |star|
      star.wormhole_star = nil if star.wormhole_star.andand.dead?
    end
    
    active_stars.map(&:planets).flatten.compact.tap do |known_planets| 
      self.planet_count = known_planets.count

      known_planets.select(&:dead?).each do |planet|
        planet.id = active_planets.index &:dead?
      end
      
      known_planets.map(&:colony).compact.tap do |known_colonies|
        self.colony_count = known_colonies.count
        
        known_colonies.select(&:dead?).each do |colony|
          colony.id = active_colonies.index(&:dead?)
        end
      end
    end
    
    lost_ships = active_ships.select do |ship| ship.star == nil or ship.star.dead? end
      
    (active_ships-lost_ships).each do |ship| ship.point = ship.star.point end
    
    (lost_ships+inactive_stars+inactive_colonies+inactive_ships+inactive_planets).each &:clear
  end
  
  def method_missing sym,*args,&block
    return super unless game.respond_to? sym
  
    self.game.send sym,*args,&block
  end
  
  def respond_to? sym
    super or game.respond_to? sym
  end
end