# Example usage:
#   run-docker-postgres postgres postgres postgres
#   docker exec -it <container-id> bash
#   psql -h localhost -p 5432 -U postgres
function run-docker-postgres --description "Creates a new postgres docker container"
    set -lx username $argv[1]
    set -lx password $argv[2]
    set -lx dbname $argv[3]
    if test -z $dbname
        set dbname postgres
    end
    docker run --name $username -e POSTGRES_PASSWORD=$password -d -p 5432:5432 $dbname
end
