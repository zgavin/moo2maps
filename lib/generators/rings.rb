module Generators
  class Rings < Generator
    def home_stars
      @home_stars ||= active_players.map(&:home_planet).map(&:star)
    end
    
    def rings
      @rings ||= begin
        rings = conf.ring_count.times.map do [] end
        
        potentials = (active_stars - home_stars)
        
        pool = potentials.select &:habitable?
        
        pool_size = (star_count-player_count) / player_count * player_count
        
        pool.push *((potentials-pool).first(pool_size-pool.count)) if pool_size > pool.count
        
        pool.shuffle!
        
        puts pool_size
        
        (pool_size/player_count).times do |i|
          rings[rings.count-1-(i % (rings.count))].push *(pool.shift player_count)
        end 
          
        rings.last.push *(rings.first.shift player_count)
          
        puts rings.map(&:count).inspect
          
        rings
      end
    end
    
    def rest
      @rest ||= active_stars - home_stars - rings.flatten
    end
    
    def transform
      active_stars.select(&:black_hole?).each do |star|
        idx = active_stars.rindex do |other| not other.black_hole? end
        star.id = idx if idx > star.id
      end
      
      active_stars.each do |star| star.wormhole_star = nil end
      
      home_stars.each_with_index do |star,i|
        star.point = center_point + (Point.new(i.to_f/player_count*Math::PI*2)*(height*conf.home_star_offset)*[aspect_ratio,1])
      end
      
      rings.each_with_index do |ring,i|
        offset = (conf.minimum_offset+(conf.home_star_offset - conf.minimum_offset)*(i.to_f/rings.count))*height
        
        ring.each_with_index do |star,j|
          star.point = center_point + (Point.new(j.to_f/ring.count*Math::PI*2)*offset*[aspect_ratio,1])
        end
      end
      
      rings.first.each_with_index do |star,i|
        star.wormhole_star = rings.first[(i+rings.first.count/2) % rings.first.count]
      end
      
      active_ships.each do |ship| ship.point = ship.star.point end
      
      active_stars.each do |star| 
        star.in_nebula = false 
        star.blocked_stars = []
      end
      
      rest.each_with_index do |star,i|
        star.spectral_class = 6
        star.point = center_point + (Point.new(i.to_f/rest.count*Math::PI*2)*height*(conf.minimum_offset/2)*[aspect_ratio,1])
      end
      
      black_holes = active_stars.select &:black_hole?
      
      (active_stars - black_holes).each do |star|
        star.blocked_stars = active_stars.select do |other| black_holes.any? do |bh| bh.between star,other end end
      end
      
      self.nebula_count = 0
    end
  end
end