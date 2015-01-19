require './environment'
require './advisors/drug_advisor'
require './advisors/doctor_advisor'
require 'sinatra'

set :haml, format: :html5
set :port, 80 if Sinatra::Base.environment == 'production'

def symptoms
  params[:symptoms] || []
end

def allergies
  params[:allergies] || []
end

def age
  params[:age].to_i
end

def latitude
  params[:latitude].to_f
end

def longitude
  params[:longitude].to_f
end

get '/' do
  @symptoms  = Symptom.all
  @allergies = Allergy.all
  haml :index
end

get '/drug' do
  @drugs = DrugAdvisor.new.find(symptoms, age, allergies)
  @drugs.map(&:name).to_json
end

get '/doctor' do
  results = DoctorAdvisor.new.find(symptoms, age, allergies, latitude, longitude)
  results.inject({}) do |hash, pair|
    doctor, distance = pair
    hash.merge!(doctor.name => distance.round(2))
  end.to_json
end