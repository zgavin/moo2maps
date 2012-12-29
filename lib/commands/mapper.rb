g = Game.new
File.open '/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/SAVE9.GAM' do |f| g.parse f end
Wheel.new(g).transform
File.open '/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/SAVE10.GAM','w' do |f| dump f  end

