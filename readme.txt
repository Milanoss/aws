docker ps
docker exec -t -i ad56b8f6cca4 /bin/bash

docker image prune
docker container prune

git update-index --chmod=+x script.sh
chmod +x script.sh
unix2dos script.sh

docker-compose up -d

fly --target channel-api login --concourse-url http://127.0.0.1:8080 -u admin -p admin

fly -t channel-api set-pipeline -c channel-api/pipeline.yml -p api