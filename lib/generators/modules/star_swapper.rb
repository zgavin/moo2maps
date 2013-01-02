module Generators
  module Modules
    module StarSwapper
      def swap_stars search_range, swap_range=nil, &block
        replace_range = (search_range.last+1)..-1 unless replace_range
        stars[search_range].select(&block).each do |star|
          star.id = stars[replace_range].find do |s| not block.call(s) end.id
        end
      end
    end
  end
end