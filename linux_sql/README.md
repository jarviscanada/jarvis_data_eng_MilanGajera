Introduction
This project, a Linux Cluster Monitoring Agent, is designed for monitoring and managing a cluster of Linux servers via automated tools. Utilizing bash scripts, a PostgreSQL database, and crontab for scheduling, the agent tracks hardware specifications and resource usages in real-time, such as CPU and memory information. The target users are system administrators and DevOps teams who require a straightforward, efficient way to monitor server health and performance across multiple machines. This solution leverages technologies including Bash for scripting, Docker for containerization, PostgreSQL for data storage, and Git for version control, ensuring a versatile and scalable monitoring system.

Quick Start
bash
Copy code
# Start a psql instance using psql_docker.sh
./scripts/psql_docker.sh create db_username db_password

# Create tables using ddl.sql
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# Insert hardware specs data into the DB using host_info.sh
./scripts/host_info.sh localhost 5432 host_agent postgres password

# Insert hardware usage data into the DB using host_usage.sh
./scripts/host_usage.sh localhost 5432 host_agent postgres password

# Crontab setup
(crontab -l 2>/dev/null; echo "* * * * * bash /path/to/your/script/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log") | crontab -
Implementation
The Linux Cluster Monitoring Agent is implemented to automate the monitoring of multiple Linux servers, focusing on simplicity and scalability.

Architecture
The cluster diagram is saved in the assets directory as requested.

Scripts
psql_docker.sh
bash
Copy code
# Create/start/stop a Docker PostgreSQL container
./scripts/psql_docker.sh start|stop|create db_username db_password
host_info.sh
bash
Copy code
# Collect and insert hardware specifications into the database
./scripts/host_info.sh localhost 5432 host_agent postgres password
host_usage.sh
bash
Copy code
# Collect and insert hardware usage data into the database
./scripts/host_usage.sh localhost 5432 host_agent postgres password
crontab
bash
Copy code
# Edit crontab jobs
crontab -e

# Add host_usage.sh execution every minute
* * * * * bash /path/to/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log
queries.sql
This script contains SQL queries that solve business problems such as finding average memory usage for each host, detecting potential server failures, and grouping hosts by hardware configurations.
Database Modeling
host_info Table
Column Name	Type	Description
id	SERIAL	Primary key for host information
hostname	VARCHAR	Unique name of the host
cpu_number	INT	Number of CPUs
cpu_architecture	VARCHAR	CPU architecture
cpu_model	VARCHAR	Model of CPU
cpu_mhz	FLOAT	Speed of the CPU in MHz
l2_cache	INT	Size of L2 cache in KB
total_mem	INT	Total memory in KB
timestamp	TIMESTAMP	Time at which this information was collected
host_usage Table
Column Name	Type	Description
timestamp	TIMESTAMP	Time at which this information was collected
host_id	INT	Foreign key to id in host_info table
memory_free	INT	Amount of free memory in MB
cpu_idle	INT	Percentage of time the CPU is idle
cpu_kernel	INT	Percentage of time the CPU runs kernel/system code
disk_io	INT	Number of disk I/O
disk_available	INT	Available disk space in MB
Test
To ensure reliability, each bash script and the DDL file (ddl.sql) were thoroughly tested. Running the ddl.sql script successfully created the host_info and host_usage tables with the correct schema in the PostgreSQL database. Script execution was followed by inserting data using host_info.sh and host_usage.sh, then validating entries via SQL queries to confirm accurate data collection and storage.

Deployment
The deployment process utilized GitHub for source code management, crontab for scheduling the host_usage.sh script to run every minute, and Docker to containerize the PostgreSQL instance, ensuring a consistent and isolated environment.

Improvements
Handle Hardware Updates: Implement functionality to detect and log changes in hardware specifications, ensuring data remains current.
Expand Monitoring Capabilities: Introduce monitoring for additional metrics, such as network traffic and process statistics, for a comprehensive
