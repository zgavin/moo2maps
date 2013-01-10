module Generators
  class Grid < Generator
     
    def home_stars
      @home_stars ||= active_players.map do |p| p.home_planet.star end
    end
    
    def padding
      Point.new(100,80)
    end
    
    def transform
      pool = active_stars.reject(&:black_hole?).shuffle
      groups = 8.times.map do pool.shift 8 end
        
      groups.each_with_index do |group,i|
        group.each_with_index do |star,j|
          star.point = padding + ((Point.new(width,height)-(padding*2))*[i/7.0,j/7.0])
        end
      end
      
      (active_stars - groups.flatten).each &:clear
      
    end
   
  end
end