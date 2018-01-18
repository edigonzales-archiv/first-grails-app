sudo locale-gen de_CH.utf8
echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get upgrade
apt-get install -y postgresql-10 
apt-get install -y postgresql-client-10
apt-get install -y postgresql-10-postgis-2.4
sudo -u postgres psql -d postgres -c "CREATE ROLE ddluser LOGIN PASSWORD 'ddluser';"
sudo -u postgres psql -d postgres -c "CREATE ROLE dmluser LOGIN PASSWORD 'dmluser';"
sudo -u postgres psql -d postgres -c 'CREATE DATABASE sogis OWNER ddluser;'
sudo -u postgres psql -d sogis -c 'CREATE EXTENSION postgis;'
sudo -u postgres psql -d sogis -c 'CREATE EXTENSION "uuid-ossp";'
sudo -u postgres psql -d sogis -c 'GRANT SELECT ON geometry_columns TO dmluser;'
sudo -u postgres psql -d sogis -c 'GRANT SELECT ON spatial_ref_sys TO dmluser;'
sudo -u postgres psql -d sogis -c 'GRANT SELECT ON geography_columns TO dmluser;'
sudo -u postgres psql -d sogis -c 'GRANT SELECT ON raster_columns TO dmluser;'
systemctl stop postgresql
rm /etc/postgresql/10/main/postgresql.conf
rm /etc/postgresql/10/main/pg_hba.conf
cp /vagrant/postgresql.conf /etc/postgresql/10/main
cp /vagrant/pg_hba.conf /etc/postgresql/10/main
sudo -u root chown postgres:postgres /etc/postgresql/10/main/postgresql.conf
sudo -u root chown postgres:postgres /etc/postgresql/10/main/pg_hba.conf
service postgresql start