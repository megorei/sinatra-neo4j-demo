require './environment'
require './advisors/drug_advisor'
require './advisors/doctor_advisor'
require 'sinatra'

set :haml, format: :html5

def symptoms(params)
  params[:symptoms] || []
end

def allergies(params)
  params[:allergies] || []
end

def age(params)
  params[:age].to_i
end

def all_symptoms
  Symptom.all.pluck('n.name')
end

def all_allergies
  Allergy.all.pluck('n.name')
end

get '/symptoms.json' do
  all_symptoms.to_json
end

get '/allergies.json' do
  all_allergies.to_json
end

get '/' do
  @symptoms  = all_symptoms
  @allergies = all_allergies
  haml :index
end

get '/drug' do
  @drugs = DrugAdvisor.new.get(symptoms(params), age(params), allergies(params))
  @drugs.map(&:name).to_json
end

get '/doctor' do
  @doctors = DoctorAdvisor.new.get(symptoms(params), age(params), allergies(params))
  @doctors.map(&:name).to_json
end