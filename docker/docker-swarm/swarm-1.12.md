
# PID - Discover Docker 1.12 / Swarm CLI commands

- ensure docker 1.12 , for all cluster node

      docker -v

- Manager 1 : CREATE SWARM

    - Initialize

          docker swarm init --advertise-addr=192.168.33.10:2377

    - Given command to add/join worker ( in secure mode ), example :

          docker swarm join \
          --token SWMTKN-1-0f526ypi8lj1uurrbq2cpnq7hh749ktkjp0seqon3bpp1x3nt3-5pxv1o4jsnyyrxan9bpcs6a47 \
          192.168.33.10:2377

    - Given command to add another manager ( -- )

          docker swarm join-token manager

    - List the node in the swarm

          docker node ls


- Worker : JOIN THE SWARM  ( without secure mode )

    - Join Swarm ( badly without token)

          docker swarm join 192.168.33.10:2377

    - Join Swarm (  with token - **Service Discovery build directly inside !!** )

          docker swarm join \
          --token SWMTKN-1-0f526ypi8lj1uurrbq2cpnq7hh749ktkjp0seqon3bpp1x3nt3-5pxv1o4jsnyyrxan9bpcs6a47 \
          192.168.33.10:2377

    - Manager command won't work on worker ... docker node ls for example

- Service :

    - in Engine , we make docker run and manage lifecycle
    - in swarm , **service** is a high level concept to ask docker swarm to manage container for us

    - Service to ping the manager VM

          docker service create --name ping00 alpine ping 192.168.33.10

    - List all running services in the swarm

          docker service ls

    - Check the instance number of a running service ,

          docker service ps ping00

    - find the container associated to this service , and see docker logs -f

    - Delete a service

          docker service rm ping00

- Load Balancing , publish port

        docker service create --name website \
        -p 8081:80 \
        -p 8091:80 \
        -p 8092:80 \
        sixeyed/docker-swarm-walkthrough

  **CHECK THIS OUT :** => Go into a VM that doesnt have the container and we will get the respons, the service is always available ( ROUTING MECH => re Routing request to the desired node )

- Scaling

        docker service update --replicas 10 website

- Rehability

    - Shut down a node and see what happens ( simulate a shutdown )

          docker swarm leave

    - manager scheduled new task on the remaining node to keep repliat to 10


#### Unknow:

d service scale website=20

Scale vs replicat ( better use  ? )

#### Reminder:

  - docker swarm init: don't work if multiple adress is present

  - docker swarm init : don't work if node already worker

  - Cluster management integrated with Docker Engine : Don't need additional orchestration software to create or manage a swarm
     ===> **No need of Consul for PID**

  - Decentralized design :
       * Master ==> **manager**
       * Slave ==> **worker**

  - Scaling : => **for each service, you can declare the number of tasks you want to run**

  - Desired state reconciliation : ==> **manager create replicas to replace, the replicas that crashed**

  - Service Discovery / LB
