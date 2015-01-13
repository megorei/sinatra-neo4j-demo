class User
  include Neo4j::ActiveNode

  property :id,   type: Integer, index: :exact
end