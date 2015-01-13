class Symptom
  include Neo4j::ActiveNode

  property :id,   type: Integer, index: :exact
  property :name, index: :exact
end