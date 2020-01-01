## Information and Resources

Your company just finished releasing a candy-themed mobile game. So far, things are going well, and the back end services running in your Kubernetes cluster are servicing thousands of requests. However, there have been a few issues with the back end service.

Container Health Issues

The first issue is caused by application instances entering an unhealthy state and responding to user requests with error messages. Unfortunately, this state does not cause the container to stop, so the Kubernetes cluster is not able to detect this state and restart the container. Luckily, the application has an internal endpoint that can be used to detect whether or not it is healthy. This endpoint is /healthz on port 8081. Your first task will be to create a probe to check this endpoint periodically. If the endpoint returns an error or fails to respond, the probe will detect this and the cluster will restart the container.

Container Startup Issues

Another issue is caused by new pods when they are starting up. The application takes a few seconds after startup before it is ready to service requests. As a result, some users are getting error message during this brief time. To fix this, you will need to create another probe. To detect whether the application is ready, the probe should simply make a request to the root endpoint, /, on port 80. If this request succeeds, then the application is ready.

