class Doctor
  include Neo4j::ActiveNode
  include IntegerId

  property :name, index: :exact
  property :latitude
  property :longitude
end