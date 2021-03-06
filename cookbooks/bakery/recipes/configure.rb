include_recipe "database::mysql"
include_recipe "database::postgresql"

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

postgresql_connection_info = {
  :host     => '127.0.0.1',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

# Create Default Users for Databases
mysql_database_user 'bakery' do
  connection mysql_connection_info
  password 'secret'
  action :create
end

postgresql_database_user 'bakery' do
  connection postgresql_connection_info
  password 'secret'
  action :create
end

# Create All Of The Defined Databases
node['databases'].each do |database|
  mysql_database database do
    connection mysql_connection_info
    action :create
  end

  mysql_database_user 'bakery' do
    connection mysql_connection_info
    database_name database
    password 'secret'
    action :grant
  end

  postgresql_database database do
    connection postgresql_connection_info
    action :create
  end

  postgresql_database_user 'bakery' do
    connection postgresql_connection_info
    database_name database
    password 'secret'
    action :grant
  end

  mysql_database "test_#{database}" do
    connection mysql_connection_info
    action :create
  end

  mysql_database_user 'bakery' do
    connection mysql_connection_info
    database_name "test_#{database}"
    password 'secret'
    action :grant
  end

  postgresql_database "test_#{database}" do
    connection postgresql_connection_info
    action :create
  end

  postgresql_database_user 'bakery' do
    connection postgresql_connection_info
    database_name "test_#{database}"
    password 'secret'
    action :grant
  end
end

# Create All Of The Defined Sites
node['sites'].each do |site|
  template node['nginx']['dir'] + "/sites-available/" + site['map'] do
    source "site.erb"
    owner "root"
    group "root"
    mode 0644
    variables(
      :server_name => site['map'],
      :root => site['to'],
      :vars => site['variables'] || []
    )
    notifies :restart, "service[nginx]"
  end

  link node['nginx']['dir'] + "/sites-enabled/" + site['map'] do
    to node['nginx']['dir'] + "/sites-available/" + site['map']
  end
end


# Configure All Of The Server Environment Variables
node['variables'].each do |key, value|
  magic_shell_environment key.to_s do
    value value.to_s
  end
end

# Install PHP Mods
%w(mcrypt mysql).each do |mod|
  apt_package "php5-#{mod}" do
    action :install
  end

  execute "php5enmod" do
    command "php5enmod #{mod}"
  end
end
