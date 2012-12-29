class Star
  include Model

  belongs_to :player
  
  belongs_to :wormhole_star,:type=>'star'

  has_many :ships,:leaders

  pointable
  
  def clear
    planets.each do |planet|
      planet.clear if planet.star == self
    end
    
    ships.each &:clear 
    
    game.leaders.select do |l| l.star == self end.each do |l| l.star_id = 0 end
      
    super
  end
  
  def dead?
    self.id >= game.star_count
  end
  
  def blocked_stars= arr
    tmp = arr.map(&:id)
    
    self.black_hole_blocks = (0..8).map do |offset|
      bits = 0
      8.times do |idx|
        bits += 1 if tmp.include?(offset*8+7-idx)
        bits = bits << 1 unless idx == 7
      end
      bits
    end.pack('C*')
  end
  
  def blocked_stars
    tmp = black_hole_blocks.unpack('C*').inject([]) do |arr,bits|
      8.times do |i|
        arr << ((bits >> i) % 2)
      end
      arr
    end
    
    game.stars.select do |star| tmp[star.id] == 1 end
  end
  
  def planet_index
    DelegatorArray.new((planets+[nil]*(5-planets.count)).map do |p| p and p.id or -1 end).tap do |arr| arr.delegate = self end
  end
  
  def planets
    @planets ||= DelegatorArray.new.tap do |arr| arr.delegate = self end
  end
  
  def array_update array,method,args,&block
    if planets == array then
      planets.each do |planet| planet.star = self if planet.star != self end
    else
      planets.replace(array.map do |idx| game.planets[id] if id >= 0 end)
    end
  end
  
  class DelegatorArray < Array
    attr_accessor :delegate
    ([:[], :[]=, :delete, :delete_at, :delete_if, :fill, :insert, :keep_if, :pop, :push, :replace, :shift, :unshift]+Array.instance_methods(false).select do |m| m.to_s.ends_with? '!' end).each do |m|
      old = instance_method(m)
      define_method m do |*args,&block|
        old.bind(self).call(*args,&block).tap do delegate.array_update self,m,args,&block end
      end
    end
  end
end