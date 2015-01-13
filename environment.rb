require 'bundler'
Bundler.setup
require 'neo4j'

session = Neo4j::Session.open(:server_db, 'http://localhost:7474/')
#session.start

Dir["models/**/*.rb"].each do |model|
  load model
end
