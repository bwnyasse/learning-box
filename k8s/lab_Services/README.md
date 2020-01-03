## Additional Information and Resources

Your company has just deployed two components of a web application to a Kubernetes cluster, using deployments with multiple replicas. They need a way to provide dynamic network access to these replicas so that there will be uninterrupted access to the components whenever replicas are created, removed, and replaced. One deployment is called auth-deployment, an authentication provider that needs to be accessible from outside the cluster. The other is called data-deployment, and it is a component designed to be accessed only by other pods within the cluster.

The team wants you to create two services to expose these two components. Examine the two deployments, and create two services that meet the following criteria:

#### auth-svc
- The service name is auth-svc.
- The service exposes the pod replicas managed by the deployment named auth-deployment.
- The service listens on port 8080 and its targetPort matches the port exposed by the pods.
- The service type is NodePort.

#### data-svc
- The service name is data-svc.
- The service exposes the pod replicas managed by the deployment named data-deployment.
- The service listens on port 8080 and its targetPort matches the port exposed by the pods.
- The service type is ClusterIP.
Note: All work should be done in the default namespace.
