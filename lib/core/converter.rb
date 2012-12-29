# this is some legacy code used to convert c header files into yaml

MAX_POPS = 42
MAX_PLAYERS = 8
MAX_RACES = 14
N_POP_PLAYERS = (MAX_PLAYERS+2)
N_POP_RACES = (MAX_RACES+2)
MAX_BUILDINGS = 49
MAX_SYSTEMS = 72
MAX_PLANETS = 360
MAX_SHIPS = 500
MAX_TECH_FIELDS = 83
MAX_TECH_APPLICATIONS = 212
STAR_OFFSET = 0x17ad3
PLANET_OFFSET = 0x162e9
SHIP_OFFSET = 0x21F58
PLAYER_OFFSET = 0x1aa0e
MAX_STARS = 72
MAX_SPECIALS = 36
MAX_SHIP_WEAPONS = 8

maintenance_building = 0
maintenance_freighter = 1
maintenance_ship = 2
maintenance_spy = 3
maintenance_tribute = 4
maintenance_leader = 5
n_maintenance_classes = 6 


Dir['reference/headers/*.h'].each do |filename|
  tmp = File.open filename do |f|  
    code_line = /^[\t ]*(?:(\w+)\s+)?(?:(\w+)\s+)?(\w+)\s+(\w+)(?:\[([^\]]+)\])?(?:\[([^\]]+)\])?;(?:\s*\/\/(.*))?\s*$/
    blank_line = /^[\s\-]*$/
    comment_line = /^\s*\/\/(.*)$/
  
    i = 1
  
    output = ""
    f.readlines.map do |line|
    
      if matches = code_line.match(line) then
        specifiers = matches.to_a[1..2].compact.map(&:downcase)
        type,name,count,count_b,comment = matches.to_a[3..-1]
        
        if count_b then
          tmp = count.to_i*count_b.to_i
          count = (tmp != 0 and tmp or  "(#{count})*(#{count_b})")
        end
        
        count = eval(count.to_s) if count
      
        output << "#{name}:"
      
        output << "#{"".ljust(61-name.length)}##{comment}" if comment
      
        output << "\n"
      
        if type == "char" and count then
          output << "  size: #{count}\n"
          output << "  type: string\n"
        elsif specifiers.include? 'struct' then
          output << "  type: #{type.gsub(/^s_/,'').classify}\n"
          output << "  count: #{count}\n" if count
        else
          size = {"bool"=>1,"char"=>1,"uchar"=>1,"schar"=>1,"short"=>2,"int"=>4,"sint"=>4,"uint"=>4,"long"=>8}[type.downcase]
          size = 2 if specifiers.include? "short"
          size = 8 if specifiers.include? "long"
        
          output << "  size: #{size}\n" if size > 1
          output << "  signed: true\n" if ["schar","sint","int","long","short"].include? type.downcase or specifiers.include?('signed') and true or false 
          output << "  count: #{count}\n" if count 
        end
      elsif matches = blank_line.match(line) then
        output << "\n"
      elsif matches = comment_line.match(line) then
        output << "# #{matches[1]}\n"
      else
        puts "error reading line ##{i} of #{filename}: #{line}"
        exit
      end
      i+=1
    end
  
    output
  end
  
  File.write filename.gsub(/reference\/headers\/(.*)\.h$/,'config/\1.yml'),tmp
end
