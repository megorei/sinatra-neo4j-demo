class Symptom
  include Neo4j::ActiveNode
  include IntegerId

  property :name, index: :exact

  has_many :in, :pathologies, type: :may_manifest_symptoms
end