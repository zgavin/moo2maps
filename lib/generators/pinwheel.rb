module Generators
  class Pinwheel < Generator
    include Generators::Modules::StarMirror
    include Generators::Modules::StarSwapper
  
    def center_ring_count
      conf.center_stars.stars_per_ring.count
    end
    
    def center_star_count
      @center_star_count ||= conf.center_stars.stars_per_ring.sum
    end
    
    def home_star_cluster_count
      @home_star_count ||= (conf.home_star_cluster.extra_stars+1)*player_count
    end
    
    def orion_star_count
      @orion_star_count ||= (conf.orion? and 1 or 0)
    end
  
    def total_star_count
      @total_star_count ||= orion_star_count + home_star_cluster_count + center_star_count
    end
  
    def home_cluster_wormhole_count
      1
    end
  
    def orion
      conf.orion and stars.first or nil
    end
  
    def home_stars
      @home_stars ||= active_players.map(&:home_planet).map(&:star).tap do |home_stars|
        home_stars.each_with_index do |home_star,i| home_star.id = i+orion_star_count; end
      end
    end
  
    def home_clusters
      @home_clusters ||= begin 
        swap_stars(home_stars.count+orion_star_count..(orion_star_count+home_star_cluster_count)) do |star|
          star.black_hole? or active_ships.any? do |ship| ship.star == star end
        end
        
        home_stars.count.times.map do |i| 
          offset = home_stars.count+orion_star_count+i*conf.home_star_cluster.extra_stars
        
          stars[offset..(offset+conf.home_star_cluster.extra_stars-1)]
        end
      end
    end
  
    def center_stars
      @center_stars ||= begin 
        center_star_offset = orion_star_count+home_star_cluster_count
        
        center_star_range = center_star_offset..(center_star_offset+center_star_count-1)
        
        swap_stars(center_star_range) do |star| star.spectral_class == 6 end
      
        active_ships.select do |s| s.player_id > 9 end.each_with_index do |ship,i| 
          ship.star.id = center_star_offset+i 
        end
        
        stars[center_star_range]
      end
    end
  
    def transform
      throw "total stars is more than 71" if total_star_count > 71
      throw "outer ring in center must have at least as many stars as there are players" if conf.center_stars.stars_per_ring.last < player_count
 
      stars.each do |star| star.wormhole_star = nil end
 
      orion.point = center_point if orion
 
      home_stars.each_with_index do |home_star,i|
        angle = i.to_f/home_stars.count*2*Math::PI
          
        home_star.size = 0
        
        home_star.point = (Point.new(angle)*[aspect_ratio,1]*conf.home_stars.offset_from_center)+center_point
          
        home_star.blocked_stars = (stars-home_clusters[i]-[home_star]) if conf.block_travel?
          
        home_clusters[i].each_with_index do |star,j|
           star.black_hole_blocks = home_star.black_hole_blocks if conf.block_travel?
           star.size = 2
           cluster_angle = angle+j.to_f/conf.home_star_cluster.extra_stars*2*Math::PI
           star.point = home_star.point + Point.new(cluster_angle)*conf.home_star_cluster.offset_from_home_star*-1
        end
      end
  
      c = conf.center_stars
        
      center_ring_count.times do |ring|
        offset = (ring == 0 and 0 or c.stars_per_ring[0..(ring-1)].sum)
               
        group = center_stars[offset..(offset+c.stars_per_ring[ring]-1)]
      
        angle_offset = c.angular_offset_per_ring[ring]
        angle_offset = eval(angle_offset) if angle_offset.is_a? String
             
        offset = c.offset_per_ring[ring]
              
        star_size = c.star_size_per_ring[ring]
          
        group.each_with_index do |star,i|
          star.blocked_stars = (stars - center_stars - [orion].compact) 
          
          angle = angle_offset + i.to_f/group.count*2*Math::PI
                
          star.point = center_point+(Point.new(angle)*[aspect_ratio,1]*offset)
          
          star.size = star_size
        end
      end

      cleanup(total_star_count)
   
      monster = active_ships.select do |s| s.player_id > 7 end.sample if c.outer_ring_guarded_by_monsters?
   
      home_clusters.each_with_index do |cluster,i|
        star = (cluster.count >= home_cluster_wormhole_count and cluster.first or home_stars[i])
        other = center_stars[-1*(c.stars_per_ring.last)..-1].inject nil do |closest,current|
          closest and closest.point.distance_to(star.point) < current.point.distance_to(star.point) and closest or current 
        end
               
        other.wormhole_star = star
        star.wormhole_star = other
        if c.outer_ring_guarded_by_monsters? then 
          ship = monster.dup
          ship.point = other.point
          ship.star = other
               
          ship.id = ship_count
          self.ship_count += 1
        end
        
        other.blocked_stars -= cluster
        home_stars[i].blocked_stars -= [other]
           
        cluster.each_with_index do |star,j|
          star.blocked_stars -= [other]
          
          mirror_star home_clusters.first[j],star if i > 0 and conf.home_star_cluster.mirror_stars?
        end 
      end
                 
      if orion then    
        star.blocked_stars = (stars - center_stars - [orion].compact) 
        
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