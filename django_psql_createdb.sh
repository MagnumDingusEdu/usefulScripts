#!/usr/bin/env bash

printf "Listing current databases...\n\n";
psql postgres -c "SELECT datname FROM pg_database WHERE datistemplate = false;" | cat

printf "Enter the name of the database : ";
read database_name;
if [[ ! $database_name == ${database_name//[ \"]/_} ]] ; then  
   echo "Database name cannot contain spaces or quotes." 
   exit
fi
printf "Enter the username : ";
read user_name;
if [[ ! $user_name == ${user_name//[ \"]/_} ]] ; then  
   echo "Username cannot contain spaces or quotes." 
   exit
fi
printf "Enter the password : ";
read password;
if [[ ! $password == ${password//[ \"]/_} ]] ; then  
   echo "Password cannot contain spaces or quotes." 
   exit
fi



read -r -d '' SQL_COMMANDS << EOM
CREATE DATABASE $database_name;
CREATE USER ${user_name} WITH PASSWORD '${password}';
ALTER ROLE ${user_name} SET client_encoding TO 'utf8';
ALTER ROLE ${user_name} SET default_transaction_isolation TO 'read committed';
ALTER ROLE ${user_name} SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE ${database_name} TO ${user_name};
EOM

printf "$SQL_COMMANDS" > commands.sql
psql -U postgres postgres -f commands.sql
rm -f commands.sql

echo "Database created !"
