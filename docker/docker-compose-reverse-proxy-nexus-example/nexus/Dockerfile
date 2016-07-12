FROM sonatype/nexus:2.11.1

USER root

# sample how to add plugins
COPY plugins/*.zip /opt/sonatype/nexus/nexus/WEB-INF/plugin-repository/
RUN cd /opt/sonatype/nexus/nexus/WEB-INF/plugin-repository && unzip -q *.zip

USER nexus
