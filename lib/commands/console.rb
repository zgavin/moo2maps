Pry.config.pager = false

Game.new.instance_exec do
  def load s
    #self.clear
    File.open "/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/#{s}", &method(:read)
    
    "#{s} Loaded"
  end
  
  def write s=nil
    File.open "/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/#{s || 'SAVE10.GAM'}", 'w', &method(:write)
    
    "#{s} Written"
  end
  
  puts load('SAVE10.GAM')
  
  binding.pry :quiet => true
end