# capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker - Make sure you understand the double pipe operator
sudo systemctl status docker || sudo systemctl start docker

# Check container status (try the following cmds on terminal)
docker container inspect jrvs-psql > /dev/null 2>&1
container_status=$?

# Use switch case to handle create|stop|start options
case $cmd in 
  create)
  
  # Check if the container is already created
  if [ $container_status -eq 0 ]; then
    echo 'Container already exists'
    exit 1  
  fi

  # Check # of CLI arguments
  if [ -z "$db_username" ] || [ -z "$db_password" ]; then
    echo "Error: Missing username or password."
    exit 1
  fi
  
  # Create container
  docker volume create pgdata
  docker run --name jrvs-psql -e POSTGRES_USER=$db_username -e POSTGRES_PASSWORD=$db_password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  exit $?
  ;;

  start|stop) 
  # Check instance status; exit 1 if container has not been created
  if [ $container_status -ne 0 ]; then
    echo "Container has not been created."
    exit 1
  fi
  
  # Start or stop the container
  docker container $check if the container is already created
  if [ $container_status -eq 0 ]; then
    echo 'Container already exists'
    exit 1  
  fi

  # Check # of CLI arguments
  if [ -z "$db_username" ] || [ -z "$db_password" ]; then
    echo "Error: Missing username or password."

  exit $?
  ;;  
  
  *)
  echo 'Illegal command'
  echo 'Commands: start|stop|create'
  exit 1
  ;;
esac

