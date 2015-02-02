class DoctorAdvisor
    def find(symptom_names, age, allergy_names = [], latitude = nil, longitude = nil)
        DrugAdvisor.new.find_query(symptom_names, age, allergy_names).
          match('(doctor:Doctor)-->(:DoctorSpecialization)-[:can_prescribe]->(drug_class)').
          return('DISTINCT(doctor) AS doctor',
                 '2 * 6371 * asin(sqrt(haversin(radians({lat} - COALESCE(doctor.latitude,{lat}))) + cos(radians({lat})) * cos(radians(COALESCE(doctor.latitude,90)))* haversin(radians({long} - COALESCE(doctor.longitude,{long}))))) AS distance').
          params(lat: latitude, long: longitude).
          order('distance ASC').
          each_with_object({}) do |result, hash|
            hash[result.doctor] = result.distance
        end
    end
end