class Wheel < Pinwheel
  def transform
    super
    
    home_clusters.each_with_index do |cluster,i|
      next_cluster = home_clusters[i == home_clusters.count - 1 ? 0 : i+1]
      prev_cluster = home_clusters[i == 0 ? home_clusters.count-1 : i-1]
    
      cluster[-1].wormhole_star = next_cluster[1]
      cluster[1].wormhole_star = prev_cluster[-1]
    end
  end
end