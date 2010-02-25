desc 'Run specs'
task :spec do
  sh 'bacon -s spec/*_spec.rb'
end
task :default => :spec

desc 'Install'
task :install do
  folder = '~/.heroku/plugins/heroku-mongo-sync'
  sh "rm -rf #{folder}; mkdir -p #{folder} && cp -R . #{folder}"
end