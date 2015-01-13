class DoctorAdvisor
  def get(symptoms, age, allergies = [], latitude = nil, longitude = nil)
    query = Neo4j::Session.current.query
    query = query.match('(patho:Pathology)-[:may_manifest_symptoms]->(symptoms:Symptom)').where("symptoms.name" => symptoms).with('patho')
    query = query.match('(drug_class:DrugClass)-[cures:cures]->(patho)').where('cures.age_min <= {age} AND {age} < cures.age_max').params(age: age).with('drug_class')
    query = query.match('(drug:Drug)-[:belongs_to_class]->(drug_class), (allergy:Allergy)')
    query = query.where('NOT (drug)-[:may_cause_allergy]->(allergy) OR NOT(allergy.name IN {allergies})').params(allergies: allergies)
    query = query.with('drug_class, drug')
    query = query.match('(doctor:Doctor)-->(spe:DoctorSpecialization)-[:can_prescribe]->(drug_class)').
      return('DISTINCT(doctor) AS doctor, 2 * 6371 * asin(sqrt(haversin(radians({lat} - COALESCE(doctor.latitude,{lat}))) + cos(radians({lat})) * cos(radians(COALESCE(doctor.latitude,90)))* haversin(radians({long} - COALESCE(doctor.longitude,{long}))))) AS distance').
      params(lat: latitude, long: longitude).order('distance ASC')
    query.inject({}) do |hash, result|
      hash.merge!(result.doctor => result.distance)
    end
  end
end