# Configure Redis using a ConfigMap


Insert the **redis.conf** file provided in [01 - Create a Redis server image](../01-Create_a_Redis_server_image/README.md) within a ConfigMap.

Use the Docker image created in the same lab to run a Redis container within a Pod. This Redis container has to be configured using the ConfigMap created earlier.

Artifacts to be created:

- **redis-config-map.yaml** (containing the key **redis.conf**)
- **redis-deployment.yaml** 
- **redis-service.yaml** (type: NodePort)
