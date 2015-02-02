class DrugClass
  include Neo4j::ActiveNode
  include IntegerId

  property :name, index: :exact
  has_many :in, :drugs, type: :belongs_to_class
end