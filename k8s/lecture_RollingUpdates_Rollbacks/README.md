### Perfom a rolling update.

	kubectl set image deployment/rolling-deployment nginx=nginx:1.7.9 --record

### Explore the rollout history of the deployment.

	kubectl rollout history deployment/rolling-deployment

	kubectl rollout history deployment/rolling-deployment --revision=2

### You can roll back to the previous revision like so.

	kubectl rollout undo deployment/rolling-deployment

### You can also roll back to a specific earlier revision by providing the revision number.

	kubectl rollout undo deployment/rolling-deployment --to-revision=1
