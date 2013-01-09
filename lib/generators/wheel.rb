module Generators
  class Wheel < Pinwheel
    def home_cluster_wormhole_count
      3
    end
  
    def transform
      throw "there must be at least 2 extra stars in the home cluster for a wheel map" if conf.home_star_cluster.extra_stars < 2
    
      super
    
      home_clusters.each_with_index do |cluster,i|
        next_cluster = home_clusters[i == home_clusters.count - 1 ? 0 : i+1]
        prev_cluster = home_clusters[i == 0 ? home_clusters.count-1 : i-1]
      
        index = (cluster.count > 2 and 1 or 0)
        
        {cluster[-1].wormhole_star => next_cluster[index],cluster[index].wormhole_star => prev_cluster[-1] }.each do |origin,target|
          origin.wormhole_star = target
          origin.blocked_stars -= [target]
        end
      end
    end
  end
end