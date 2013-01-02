require 'core/generator'

g = Game.new

File.open '/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/SAVE9.GAM' do |f| g.read f end

ARGV.each do |arg| Generators.const_get(arg.camelize).new(g).transform end

File.open '/Users/zgavin/DOS Games/VDC.boxer/C Master of Orion 2.harddisk/SAVE10.GAM','w' do |f| g.write f  end

