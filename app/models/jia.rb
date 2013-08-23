class Jia 
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :price, type: String
  
  embedded_in :part
end
