function restart-last-docker-container
    docker restart (docker ps -lq)
end
