module Generators
  class Wheel < Pinwheel
    def transform
      throw "there must be at least 2 extra stars in the home cluster for a wheel map" if conf.home_star_cluster.extra_stars < 2
    
      super
    
      home_clusters.each_with_index do |cluster,i|
        index = (cluster.count > 2 and 1 or 0)
        
        home_star = home_stars[i]
        
        next_star = home_clusters[(i + 1) % player_count][index]
        prev_star = home_clusters[(i - 1) % player_count][-1]
      
        center_star = cluster.first.wormhole_star
      
        center_star.wormhole_star = home_star and home_star.wormhole_star = center_star if cluster.count == 2
        
        cluster[-1].wormhole_star = next_star
        cluster[index].wormhole_star = prev_star
        
        ([home_star]+cluster).each do |star| star.blocked_stars -= [next_star,prev_star] end
        
        [next_star,prev_star].each do |star| star.blocked_stars -= ([home_star]+cluster) end
      end
    end
  end
end