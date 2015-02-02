class DrugAdvisor
  def find(symptom_names, age, allergy_names = [])
    find_query(symptom_names, age, allergy_names).pluck('DISTINCT(drug)')
  end

  def find_query(symptom_names, age, allergy_names = [])
    Symptom.all.where(name: symptom_names).
      pathologies.
      drug_classes(:drug_class, :cures).where('cures.age_min <= {age} AND {age} < cures.age_max').
      params(age: age).
      drugs.query_as(:drug).
      match(allergy: :Allergy).
      where('(NOT (drug)-[:may_cause_allergy]->(allergy) OR NOT(allergy.name IN {allergy_names}))').
      params(age: age, allergy_names: allergy_names)
  end
end