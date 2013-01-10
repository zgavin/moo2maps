module Generators
  class Pinwheel < Generator
    include Generators::Modules::StarMirror
  
    def total_star_count
      @total_star_count ||= (conf.orion? and 1 or 0) + (conf.home_star_cluster.extra_stars+1)*player_count + conf.center_stars.stars_per_ring.sum
    end
  
    def orion
      @orion ||= conf.orion and stars.first or nil
    end
  
    def home_stars
      @home_stars ||= active_players.map do |p| p.home_planet.star end
    end
  
    def home_clusters
      @home_clusters ||= begin 
        pool = (active_stars - [orion] - home_stars).select do |star| star.habitable? and active_ships.none? do |ship| ship.star == star end end
          
        home_stars.count.times.map do |i| pool.shift(conf.home_star_cluster.extra_stars).shuffle end
      end
    end
  
    def center_stars
      @center_stars ||= begin
        pool = (active_stars - [orion] - home_stars - home_clusters.flatten).reject(&:black_hole?).sort_by do |star| star.ships.count end.reverse
        
        conf.center_stars.stars_per_ring.map do |i| pool.shift i end 
      end
    end
  
    def transform
      throw "total stars is more than 71" if total_star_count > 71
      throw "outer ring in center must have at least as many stars as there are players" if conf.center_stars.stars_per_ring.last < player_count
 
      stars.each do |star| star.wormhole_star = nil end
      
      (active_stars - [orion] - home_stars - home_clusters.flatten - center_stars.flatten).each &:clear
      
      orion.point = center_point if orion
 
      home_stars.each_with_index do |home_star,i|
        angle = i.to_f/home_stars.count*2*Math::PI
          
        home_star.size = 0
        
        home_star.point = (Point.new(angle)*[aspect_ratio,1]*conf.home_stars.offset_from_center)+center_point
          
        home_star.blocked_stars = (stars-home_clusters[i]-[home_star]) if conf.block_travel?
          
        home_clusters[i].each_with_index do |star,j|
           star.black_hole_blocks = home_star.black_hole_blocks if conf.block_travel?
           star.size = 2
           cluster_angle = angle+j.to_f/conf.home_star_cluster.extra_stars*2*Math::PI+eval(conf.home_star_cluster.angular_offset)
           star.point = home_star.point + Point.new(cluster_angle)*conf.home_star_cluster.offset_from_home_star*-1
        end
      end
  
      c = conf.center_stars
        
      center_stars.each_with_index do |group,ring|
        offset = (ring == 0 and 0 or c.stars_per_ring[0..(ring-1)].sum)
      
        angle_offset = c.angular_offset_per_ring[ring]
        angle_offset = eval(angle_offset) if angle_offset.is_a? String
             
        offset = c.offset_per_ring[ring]
              
        star_size = c.star_size_per_ring[ring]
          
        group.each_with_index do |star,i|
          star.blocked_stars = (stars - center_stars.flatten - [orion]) 
          
          angle = angle_offset + i.to_f/group.count*2*Math::PI
                
          star.point = center_point+(Point.new(angle)*[aspect_ratio,1]*offset)
          
          star.size = star_size
        end
      end
      
      active_ships.each do |ship| ship.point = ship.star.point end

      monster = active_ships.select do |s| s.player_id > 7 end.sample if c.outer_ring_guarded_by_monsters?
   
      home_clusters.each_with_index do |cluster,i|
        star = (cluster.count > 0 and cluster.first or home_stars[i])
        other = center_stars.last.inject nil do |closest,current|
          closest and closest.point.distance_to(star.point) < current.point.distance_to(star.point) and closest or current 
        end
        home_star = home_stars[i]
               
        other.wormhole_star = star
        star.wormhole_star = other
        if c.outer_ring_guarded_by_monsters? then 
          ship = monster.dup
          ship.point = other.point
          ship.star = other
               
          ship.id = ship_count
          self.ship_count += 1
        end
        
        other.blocked_stars -= ([home_star]+cluster)
        
        home_star.blocked_stars -= [other]
           
        cluster.each_with_index do |star,j|
          star.blocked_stars -= [other]
          
          mirror_star home_clusters.first[j],star if i > 0 and conf.home_star_cluster.mirror_stars?
        end 
      end
                 
      if orion then    
        orion.blocked_stars = (stars - center_stars.flatten - [orion]) 
        
        orion_prime = orion.planets.compact.find do |p| p.habitable? and p.gaia? end
        
        others = orion.planets.compact - [orion_prime]
        
        others += planets[planet_count..(planet_count+3-others.count)] unless others.count > 3
        
        others.each do |planet|
          planet.colony = nil
          planet.type = 2
        end
        
        self.planet_count += others.count - orion.planets.compact.count + 1
        
        orion.planets.replace([orion_prime]+others)
      end

      self.nebula_count = 0
    end
  end
end