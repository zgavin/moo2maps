module Generators
  class Rings < Generator
    
    def home_stars
      @home_stars ||= active_players.map do |p| p.home_planet.star end
    end
    
    def rings
      @rings ||= begin
        pool = active_stars - home_stars
                 
        pool = pool.sort do |a,b|
          (a.habitable? ? 0 : a.black_hole? ? 2 : 1) <=> (b.habitable? ? 0 : b.black_hole? ? 2 : 1)
        end if conf.rings.favor_habitable_stars? 

        pool = pool.first(conf.rings.stars.map(&:to_i).sum)
        
        pool.unshift(stars.first) and pool.push unless stars.first.display_name != "Orion" or pool.include? stars.first
        
        pool.shuffle!

        conf.rings.stars.map do |i|  i == "home" and home_stars or pool.shift i end
      end
    end
    
    def remaining_stars
      @remaining_stars ||= active_stars - rings.flatten
    end
    
    def offset_point i, total, offset
      center_point + (Point.new(i.to_f/total*Math::PI*2)*offset*height*[aspect_ratio,1]) 
    end
    
    def transform    
      active_stars.each do |star| star.wormhole_star = nil end unless conf.wormholes.keep_existing?
      
      rings.each_with_index do |ring,i|
        ring.each_with_index do |star,j|
          star.point = offset_point(j, ring.count, conf.rings.offset[i])
        end
      end
      
      rings.first.each_with_index do |star,i|
        star.wormhole_star = rings.first[(i+rings.first.count/2) % rings.first.count] if i % (rings.first.count / player_count) == 0
      end if conf.wormholes.add_inner_wormholes?
      
      if conf.remaining_stars.action == 'remove' then
        remaining_stars.each &:clear
      else      
        remaining_stars.each_with_index do |star,i|
          star.black_hole! if conf.remaining_stars.replace_with_black_holes?
          star.point = offset_point(i,remaining_stars.count,conf.remaining_stars.offset) if conf.remaining_stars.action == 'move'
        end
      end
      
      active_ships.each do |ship| ship.point = ship.star.point end
      
      black_holes = active_stars.select &:black_hole?
      
      (active_stars - black_holes).each do |star|
        star.in_nebula = false 
        star.blocked_stars = active_stars.select do |other| black_holes.any? do |bh| bh.between star,other end end
      end
      
      self.nebula_count = 0
    end
  end
end