FROM mongo:3.3.10

USER root

# Update pour faire le cron
RUN apt-get update && \
    apt-get install -y cron && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Export
COPY ./export.sh /
RUN sed -i 's/\r$//' /export.sh && chmod +x /export.sh

# Import
COPY ./import.sh /
COPY ./import.json /
RUN sed -i 's/\r$//' /import.sh && chmod +x /import.sh

# Starter
COPY ./start.sh /
RUN sed -i 's/\r$//' /start.sh && chmod +x /start.sh

VOLUME /backup

# Le responsable de l'instanciation du container devra être responsable de l'appel du script start.sh avec
# les bons paramètres
CMD [""]
