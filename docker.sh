sudo docker run -d --name=WHATEVER --gpus all -it \
--shm-size=1024g --ulimit memlock=-1 --ulimit stack=67108864 \
-p PORT1:PORT1 -p PORT2:PORT2 --mount type=bind,source=SOURCE,target=YOUR_WORKING_DIR \
-v /home/USER/.ssh:/root/.ssh:ro IMAGE_NAME:VERSION jupyter lab --no-browser \
--port=PORT1 --ip=0.0.0.0 --allow-root \
--certfile=/CERT_PATH/CERT.pem --keyfile /CERT_PATH/KEY.key