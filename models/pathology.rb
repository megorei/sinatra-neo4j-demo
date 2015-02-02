class Pathology
  include Neo4j::ActiveNode
  include IntegerId

  property :name, index: :exact
  has_many :in, :drug_classes, type: :cures
end