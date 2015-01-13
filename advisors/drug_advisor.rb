class DrugAdvisor
  def get(symptoms, age, allergies = [])
    query = Neo4j::Session.current.query
    query = query.match('(patho:Pathology)-[:may_manifest_symptoms]->(symptoms:Symptom)').where("symptoms.name" => symptoms).with('patho')
    query = query.match('(drug_class:DrugClass)-[cures:cures]->(patho)').where('cures.age_min <= {age} AND {age} < cures.age_max').params(age: age).with('drug_class')
    query = query.match('(drug:Drug)-[:belongs_to_class]->(drug_class), (allergy:Allergy)')
    query = query.where('NOT (drug)-[:may_cause_allergy]->(allergy) OR NOT(allergy.name IN {allergies})').params(allergies: allergies)
    query = query.return('DISTINCT(drug) AS drug')
    query.to_a.map(&:drug)
  end
end