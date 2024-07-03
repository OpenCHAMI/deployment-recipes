#!/bin/bash
#
# Adapted from:
# https://github.com/mrts/docker-postgresql-multiple-databases/blob/master/create-multiple-postgresql-databases.sh

set -e
set -u

function create_user_and_database() {
	local database=$1
	local username=$2
	local password="'$3'"
	echo "  Creating user '$username' and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	    CREATE USER "$username" WITH PASSWORD $password;
	    CREATE DATABASE "$database";
	    GRANT ALL PRIVILEGES ON DATABASE "$database" TO "$username";
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for dbstr in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		dbname=$(echo $dbstr | cut -d: -f1)
		username=$(echo $dbstr | cut -d: -f2)
		password=$(echo $dbstr | cut -d: -f3)
		echo "Creating: db=$dbname user=$username"
		create_user_and_database $dbname $username $password
	done
	echo "Multiple databases created"
fi
