#!/bin/bash

#assign CLI arguments to variables
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Validate arguments
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

# Collect hardware specifications
hostname=$(hostname -f)
cpu_number=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
cpu_architecture=$(lscpu | grep "Architecture:" | awk '{print $2}')
cpu_model=$(lscpu | grep "Model name:" | sed -r 's/Model name:\s{1,}//')
cpu_mhz=$(lscpu | grep "CPU MHz:" | awk '{print $3}')
l2_cache=$(lscpu | grep "L2 cache:" | awk '{print $3}' | sed 's/K//') # Remove 'K' to store as KB
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}') # Value in KB
timestamp=$(date +"%Y-%m-%d %T") # Current time in 'YYYY-MM-DD HH:MM:SS' format

# Construct the INSERT statement
insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp) VALUES ('$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, $total_mem, '$timestamp');"

# Execute the INSERT statement
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -U $psql_user -d $db_name -c "$insert_stmt"

# Check if the INSERT was successful
if [ $? -eq 0 ]; then
  echo "Data inserted successfully"
else
  echo "An error occurred"
fi

