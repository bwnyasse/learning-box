## Additional Information and Resources

Your company needs a small database server to support a new application. They have asked you to deploy a pod running a MySQL container, but they want the data to persist even if the pod is deleted or replaced. Therefore, the MySQL database pod requires persistent storage.

You will need to do the following:

1. Create a PersistentVolume:
- The PersistentVolume should be named mysql-pv.
- The volume needs a capacity of 1Gi.
- Use a storageClassName of localdisk.
- Use the accessMode ReadWriteOnce.
- Store the data locally on the node using a hostPath volume at the location /mnt/data.
2. Create a PersistentVolumeClaim:
- The PersistentVolumeClaim should be named mysql-pv-claim.
- Set a resource request on the claim for 500Mi of storage.
- Use the same storageClassName and accessModes as the PersistentVolume so that this claim can bind to the PersistentVolume.

3. Create a MySQL Pod configured to use the PersistentVolumeClaim:
- The Pod should be named mysql-pod.
- Use the image mysql:5.6.
- Expose the containerPort 3306.
- Set an environment variable called MYSQL_ROOT_PASSWORD with the value password.
- Add the PersistentVolumeClaim as a volume and mount it to the container at the path /var/lib/mysql.

