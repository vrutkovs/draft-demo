#!/bin/bash
sudo docker rm -f draft-demo ; \
sudo docker build -t vrutkovs/draft-demo . && \
sudo docker run -d --name draft-demo --rm -ti -p 8080:8080 vrutkovs/draft-demo
