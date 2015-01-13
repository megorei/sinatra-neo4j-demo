class DoctorSpecialization
  include Neo4j::ActiveNode
  include IntegerId

  property :name, index: :exact
end