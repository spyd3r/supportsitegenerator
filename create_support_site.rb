#!/usr/bin/env ruby
require 'rubygems'
require 'optparse'
require 'active_support/inflector'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: create_support_app.rb [options]"
  
  opts.on('-a', '--app APPLICATION', 'Application Name') do |app|
    options[:app] = app
  end
  
  options[:create] = false
  opts.on('-c', '--create', 'Create Application') do |create|
    options[:create] = true
  end

  opts.on('-h', '--help', 'Help') do
    puts opts
    exit
  end
end
optparse.parse!
if ! options[:app].nil? && ! options[:create] == false
  rails_app = options[:app]
  if system('dpkg -l |awk {\'print $2\'} |grep libpq-dev') == false
    system('apt-get install libpq-dev')
  end
  if system('dpkg -l |awk {\'print $2\'} |grep g++') == false
    system('apt-get install g++')
  end
  if system('dpkg -l |awk {\'print $2\'} |grep postgresql-9.1') == false
    system('apt-get install postgresql-9.1')
  end
  puts "Checking to see if Rails is installed"
  rails_check = %x(gem list -l rails).chomp
  if rails_check =~ /rails/
    puts "Rails installed"
  else
    puts "Installing Rails now..."
    system('gem install rails -v=3.2.2 --no-rdoc --no-ri')
  end
  puts "Creating Rails application: #{rails_app}"
  sleep 1
  unless Dir.exists?('/opt/rails/') == true
    system("mkdir /opt/rails")
  end
  system('cp Staging/pg_hba.conf /etc/postgresql/9.1/main/ && service postgresql restart')
  system("cd /opt/rails && rails new #{rails_app} --database=postgresql")
  puts "Adding gems to Gemfile"
  sleep 1
  system("echo \"gem 'thin'\" >> /opt/rails/#{rails_app}/Gemfile && echo \"gem 'therubyracer'\" >> /opt/rails/#{rails_app}/Gemfile && echo \"gem 'eventmachine'\" >> /opt/rails/#{rails_app}/Gemfile && echo \"gem 'devise'\" >> /opt/rails/#{rails_app}/Gemfile && echo \"gem 'bootstrap-sass', '2.0.0'\" >> /opt/rails/#{rails_app}/Gemfile && echo \"gem 'cancan'\" >> /opt/rails/#{rails_app}/Gemfile && echo \"gem 'fastercsv'\" >> /opt/rails/#{rails_app}/Gemfile")
  puts "Installing Gems"
  sleep 1
  system ("cd /opt/rails/#{rails_app} && bundle install")
  puts "Creating database user"
  sleep 1
  system("psql -U postgres -c \"create role #{rails_app} login createdb;\"")
  puts "Creating databases"
  sleep 1
  system("cd /opt/rails/#{rails_app} && rake db:create:all")
  puts "Setting up Devise for authentication"
  sleep 1
  system("cd /opt/rails/#{rails_app} && rails generate devise:install && rails generate devise User && rake db:migrate")
  puts "Removing default Index page"
  sleep 1
  system("cd /opt/rails/#{rails_app} && rm -rf public/index.html")
  puts "Creating bootstrap css file: custom.css.scss"
  sleep 1
  system("cp Staging/custom.css.scss /opt/rails/#{rails_app}/app/assets/stylesheets/")
  puts "Creating application layout file"
  sleep 1
  system("cp Staging/application.html.erb /opt/rails/#{rails_app}/app/views/layouts/")
  puts "Patching application controller"
  sleep 1
  system("cp Staging/application_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  puts "Creating CanCan Abilities"
  sleep 1
  system("cp Staging/ability.rb /opt/rails/#{rails_app}/app/models/")
  puts "Adding admin attribute to User model"
  sleep 1
  system("cd /opt/rails/#{rails_app} && rails generate migration add_admin_to_users admin:boolean")
  puts "Patching Users model with product information"
  sleep 1
  system("cd /opt/rails/#{rails_app} && rails g migration add_product_selection_to_users product_selection:string && rake db:migrate")
  user_prod_migration_file = []
  Dir.entries("/opt/rails/#{rails_app}/db/migrate/").each do |file|
    if file =~ /.selection_to_users.rb/
      user_prod_migration_file.push(file)
    end
  end
  puts user_prod_migration_file[0]
  system("sed -e \"3s/add_column :users, :product_selection, :string/add_column :users, :product_selection, :string, :null => false, :default => \\\"All\\\"/\" -i /opt/rails/#{rails_app}/db/migrate/#{user_prod_migration_file[0]}")
  puts "Creating Product table"
  sleep 1
  path_line = "require '\\/opt\\/rails\\/#{rails_app}\\/config\\/environment.rb'"
  puts path_line
  system("cp Staging/init_products /opt/rails/#{rails_app}/script/")
  system("sed -e \"2s/STRING/#{path_line}/\" -i /opt/rails/#{rails_app}/script/init_products")
  system("cd /opt/rails/#{rails_app} && rails g model Product name:string")
  system("cd /opt/rails/#{rails_app} && rake db:migrate")
  system("/opt/rails/#{rails_app}/script/init_products")
  puts "Setting Controllers and Views"
  sleep 1
  system("cd /opt/rails/#{rails_app} && rails g scaffold Bug number:string kb:string description:string details:text product_family:string && rake db:migrate")
  system("cp Staging/bugs.html.erb /opt/rails/#{rails_app}/app/views/bugs/index.html.erb")
  system("cp Staging/bugs_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  system("cd /opt/rails/#{rails_app} && rails g scaffold Issue kb:string description:string details:text product_family:string && rake db:migrate")
  system("cp Staging/issues.html.erb /opt/rails/#{rails_app}/app/views/issues/index.html.erb")
  system("cp Staging/issues_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  system("cd /opt/rails/#{rails_app} && rails g scaffold FMR number:string description:string details:text product_family:string && rake db:migrate")
  system("cp Staging/fmrs.html.erb /opt/rails/#{rails_app}/app/views/fmrs/index.html.erb")
  system("cp Staging/fmrs_controller.rb /opt/rails/#{rails_app}/app/controllers/") 
  system("cd /opt/rails/#{rails_app} && rails g scaffold ReleaseNote kb:string description:string details:text product_family:string && rake db:migrate")
  system("cp Staging/notes.html.erb /opt/rails/#{rails_app}/app/views/release_notes/index.html.erb")
  system("cp Staging/release_notes_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  system("cd /opt/rails/#{rails_app} && rails g scaffold Version release:string build:string details:text kernel:string product_family:string && rake db:migrate")
  system("cp Staging/versions.html.erb /opt/rails/#{rails_app}/app/views/versions/index.html.erb")
  system("cp Staging/versions_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  system("cd /opt/rails/#{rails_app} && rails g scaffold Tip name:string description:string url:string && rake db:migrate")
  system("cp Staging/tips.html.erb /opt/rails/#{rails_app}/app/views/tips/index.html.erb")
  system("cp Staging/tips_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  system("cp Staging/bugs.csv /opt/rails/#{rails_app}/app/views/bugs/index.csv.erb")
  system("cp Staging/issues.csv /opt/rails/#{rails_app}/app/views/issues/index.csv.erb")
  system("cp Staging/frms.csv /opt/rails/#{rails_app}/app/views/fmrs/index.csv.erb")
  system("cp Staging/notes.csv /opt/rails/#{rails_app}/app/views/release_notes/index.csv.erb")
  system("cp Staging/versions.csv /opt/rails/#{rails_app}/app/views/versions/index.csv.erb")
  system("cp Staging/tips.csv /opt/rails/#{rails_app}/app/views/tips/index.csv.erb")
  system("cp Staging/find_controller.rb /opt/rails/#{rails_app}/app/controllers/")
  system("cp Staging/bug_model.rb /opt/rails/#{rails_app}/app/models/bug.rb")
  system("cp Staging/issue_model.rb /opt/rails/#{rails_app}/app/models/issue.rb")
  system("cp Staging/fmr_model.rb /opt/rails/#{rails_app}/app/models/fmr.rb")
  system("cp Staging/note_model.rb /opt/rails/#{rails_app}/app/models/release_note.rb")
  system("cp Staging/version_model.rb /opt/rails/#{rails_app}/app/models/version.rb")
  system("cp Staging/tip_model.rb /opt/rails/#{rails_app}/app/models/tip.rb")
  system("mkdir /opt/rails/#{rails_app}/app/views/find && cp Staging/find.html.erb /opt/rails/#{rails_app}/app/views/find/")
  puts "Setting up routes file"
  sleep 1
  route_line = rails_app.split("_").each {|a| a.capitalize!}.join + "::Application.routes.draw do"
  system("cp Staging/routes.rb /opt/rails/#{rails_app}/config/")
  system("sed -i '1s/^/#{route_line}/' /opt/rails/#{rails_app}/config/routes.rb")
  puts "Setting up application helpers"
  sleep 1
  system("cp Staging/application_helper.rb /opt/rails/#{rails_app}/app/helpers/")
  system("cd /opt/rails/#{rails_app}/ && rake db:drop && rake db:create && rake db:migrate")
  puts "Creating admin utility"
  sleep 1
  system("cp Staging/create_admin /opt/rails/#{rails_app}/script/")
  system("sed -e \"2s/STRING/#{path_line}/\" -i /opt/rails/#{rails_app}/script/create_admin")
  system("chmod 755 /opt/rails/#{rails_app}/script/create_admin && /opt/rails/#{rails_app}/script/create_admin")
  puts "Starting web application server for #{rails_app}"
  sleep 1
  system("cd /opt/rails/#{rails_app} && thin -e development -a localhost -p 80 -d start")
  puts "Creating validators"
  sleep 1
  puts "Finished creating #{rails_app}"
  puts "Access 'http://localhost' in a web browser"
  #system("sed -e \"3s/ /get \\\"find/find\\\"\nroot to: \\\"bugs#index\\\"\nget \\\"/find\\\" => \\\"find#find\\\"/\" -i /opt/rails/#{rails_app}/config/routes.rb")
else 
  system("#{$0} -h")
end
