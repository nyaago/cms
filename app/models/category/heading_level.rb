module Category
  
  module HeadingLevel
    
    def self.map_for_selection
       result = {}
       (1..3).each do |i|
         result[I18n.t 'h' + i.to_s, :scope => [:categories, :heading_level]] = i
       end
       result
    end
    
  end
  
end