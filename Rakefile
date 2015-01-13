require './environment'
load 'neo4j/tasks/neo4j_server.rake'

namespace :db do
  task :seed do
    seed_file = File.join('db/seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end

  task :clear do
    Neo4j::Session.current.query('MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r')
  end
end