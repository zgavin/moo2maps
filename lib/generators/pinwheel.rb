module Generators
  class Pinwheel < Generator

    RATIO = WIDTH.to_f/HEIGHT

    OUTER_RADIUS = 480

    OUTER_STAR_OFFSET = 80

    INNER_STAR_OFFSET = 75

    CENTER = Point.new(WIDTH/2,HEIGHT/2)

    CLUSTER_STARS = 3

    CENTER_STARS = 20
  
    STARS_PER_RING

    def replace_stars_if! array, offset, &block
      count = array.count
      array.select(&block).each do |star|
        array.delete star
      
        other = stars[offset..-1].find do |s| not block.call(s) end
      
        other.id = star.id
        
        array << other
      end
    end
  
    def orion
      stars.first
    end
  
  
    def home_stars
      @home_stars ||= active_players.map(&:home_planet).map(&:star).tap do |home_stars|
        home_stars.each_with_index do |home_star,i| home_star.id = i+1 end
      end
    end
  
    def home_clusters
      @home_clusters ||= (0..(home_stars.count-1)).map do |i| 
        offset = home_stars.count+1+i*CLUSTER_STARS 
        stars[offset..(offset+CLUSTER_STARS-1)].tap do |cluster| 
          replace_stars_if! cluster,1+home_stars.count*(CLUSTER_STARS+1) do |star|
            star.spectral_class == 6 or star.ships.any? do |ship| ship.player_id > 7 end 
          end
        end
      end
    end
  
    def center_stars
      center_star_offset = (1+home_stars.count+home_clusters.map(&:count).sum)  
      center_stars = stars[center_star_offset..(center_star_offset+19)].tap do |stars|
        replace_stars_if!(stars,total_stars) do |star| star.spectral_class == 6 end
      end
    end
  
    def center_rings
      3
    end
  
    def total_stars 
      1 + home_stars.count*(CLUSTER_STARS+1) + CENTER_STARS
    end
  
    def transform
      orion.point = CENTER

      home_stars.each_with_index do |home_star,i|
        angle = i.to_f/home_stars.count*2*Math::PI
    
        home_star.size = 0
  
        home_star.point = (Point.new(Math.cos(angle)*RATIO,Math.sin(angle))*OUTER_RADIUS)+CENTER
    
        home_star.blocked_stars = (stars-home_clusters[i]-[home_star])
    
        home_clusters[i].each_with_index do |star,j|
          star.black_hole_blocks = home_star.black_hole_blocks
          star.size = 2
          cluster_angle = angle+j.to_f/CLUSTER_STARS*2*Math::PI
          star.point = home_star.point + Point.new(Math.cos(cluster_angle),Math.sin(cluster_angle))*OUTER_STAR_OFFSET*-1
      
            
          star.planets.each do |p| p.clear end if i > 0
          
          star.planets.replace [nil]*5

          home_clusters[0][j].planets.each do |original|
            planet = original.dup
        
            planets[planet_count] = planet
      
            planet.star_id = star.id
        
            star.planet_index[planet.orbit] = planet.id
            self.planet_count += 1
          end
        end
      end
  
      [center_stars[0..3],center_stars[4..11],center_stars[12..19]].each_with_index do |group,ring|
    
        angle_offset = [Math::PI/4,0,Math::PI/8][ring]
    
        group.each_with_index do |star,i|
          star.blocked_stars = (stars - center_stars)
    
          angle = angle_offset + i.to_f/group.count*2*Math::PI
  
          star.point = CENTER+(Point.new(Math.cos(angle)*RATIO,Math.sin(angle))*(INNER_STAR_OFFSET*(ring+1)))
    
          star.size = [ring+1,2].min
        end
      end

      cleanup(total_stars)
  
      active_stars.each do |star| star.wormhole_star_id = -1 end
  

  
  
      home_clusters.each_with_index do |cluster,i|
        star = cluster.first
        other = center_stars[4+i]
    
        other.wormhole_star = star
        star.wormhole_star = other
    
        ship = ships.find do |s| s.player_id > 7 end.dup
        ship.point = other.point
        ship.star_id = other.id
    
        ships[ship_count] = ship
        self.ship_count += 1

        cluster.each_with_index do |star,j|
        
        end if i > 0
      end
  
      orion_prime = orion.planets.first
      orion_prime.orbit = 0
  
      orion.planet_index[0] = orion_prime.id
  
      range = planet_count..(planet_count+3)
      planets[range].each_with_index do |planet,i|
        planet.star_id = orion.id
        planet.colony_id = -1
        planet.type = 2
        planet.orbit = i+1
        orion.planet_index[i+1] = planet_count 
        self.planet_count += 1
      end
    end


  end
end