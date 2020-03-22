# Installing and Configuring Flux with GitHub

## Description

This lab introduces the steps necessary steps for installing Flux and configuring it to work with a student repository in GitHub. The student will need their own GitHub account to fork a sample repository, and this lab will spin up a Kubernetes cluster to enable the student to install and configure Flux.

## Learning Objectives

### 1. Create a GitHub Repository Under Your Own Account

To create a repository on GitHub you must log in to your own account, and then you can create a repository with the YAML files you require. Or you can find the linuxacademy/content-gitops repository and fork it. Once you create your own version of that repository, examine the YAML files in the namespaces and workloads folders.


### 2. Deploy Flux Into Your Cluster

To check whether fluxctl is installed, enter:

    $ fluxctl version

If fluxctl did not install automatically, you may enter the following command to install it:

    $ sudo snap install fluxctl --classic

Create a namespace for Flux:

    $ kubectl create ns flux

Set the GHUSER environment variable:

    $ export GHUSER=[Your GitHub Handle]

Deploy Flux using the fluxctl command:

    $ fluxctl install \
    --git-user=${GHUSER} \
    --git-email=${GHUSER}@users.noreply.github.com \
    --git-url=git@github.com:${GHUSER}/content-gitops \
    --git-path=namespaces,workloads \
    --namespace=flux | kubectl apply -f -

###  3. Verify The Deployment and Obtain the RSA Key

Verify the Flux deployment:

    $ kubectl -n flux rollout status deployment/flux

Obtain the Flux RSA key created by fluxctl:

    $ fluxctl identity --k8s-fwd-ns flux

Copy off the RSA key to implement in GitHub.


### 4. Implement the RSA Key in GitHub

Use the GitHub User Interface to Add the RSA Key obtained as a Deploy Key in GitHub.


### 5. Use the fluxctl sync Command to Synchronize the Cluster with the Repository

Use fluxctl to sync the cluster with the repository:

    $ fluxctl sync --k8s-fwd-ns flux

Then check the existence of the lasample namespace:

    $ kubectl get namespaces

Finally check that the Nginx deployment is running:

    $ kubectl get pods --all-namespaces