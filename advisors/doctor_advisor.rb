class DoctorAdvisor
  def get(symptoms, age, allergies = [], latitude = nil, longitude = nil)
    Neo4j::Session.current.query.
        match('(patho:Pathology)-[:may_manifest_symptoms]->(symptoms:Symptom)').
        where('symptoms.name' => symptoms).
        with('patho').
        match('(drug_class:DrugClass)-[cures:cures]->(patho)').
        where('cures.age_min <= {age} AND {age} < cures.age_max').
        params(age: age).
        with('drug_class').
        match('(drug:Drug)-[:belongs_to_class]->(drug_class), (allergy:Allergy)').
        where('NOT (drug)-[:may_cause_allergy]->(allergy) OR NOT(allergy.name IN {allergies})').
        params(allergies: allergies).
        with('drug_class, drug').
        match('(doctor:Doctor)-->(spe:DoctorSpecialization)-[:can_prescribe]->(drug_class)').
        return('DISTINCT(doctor) AS doctor, 2 * 6371 * asin(sqrt(haversin(radians({lat} - COALESCE(doctor.latitude,{lat}))) + cos(radians({lat})) * cos(radians(COALESCE(doctor.latitude,90)))* haversin(radians({long} - COALESCE(doctor.longitude,{long}))))) AS distance').
        params(lat: latitude, long: longitude).
        order('distance ASC').
        inject({}) do |hash, result|
          hash.merge!(result.doctor => result.distance)
        end
  end
end