Pry.config.pager = false

Game.new.instance_exec do
  def load s
    #self.clear
    File.open "/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/#{s}" do |f| read f end
    
    "#{s} Loaded"
  end
  
  def dump s=nil
    s ||=  'SAVE10.GAM'
    File.open "/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/#{s}", 'w' do |f| write f end
    
    "#{s} Written"
  end
  
  puts load('SAVE5.GAM')
  
  binding.pry :quiet => true
end