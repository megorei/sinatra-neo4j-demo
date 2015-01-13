require 'bundler'
Bundler.setup
require 'neo4j'

Neo4j::Session.open(:server_db, ENV['GRAPHENEDB_URL'] || 'http://localhost:7474/')

Dir["models/concerns/*.rb"].each do |concern|
  load concern
end

Dir["models/**/*.rb"].each do |model|
  load model
end
