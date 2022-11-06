# Replace "kafka-console-consumer" 
# by "kafka-console-consumer.sh" or "kafka-console-consumer.bat" based on your system # (or bin/kafka-console-consumer.sh or bin\windows\kafka-console-consumer.bat if you didn't setup PATH / Environment variables)

kafka-console-consumer.sh 

# consuming
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic

# other terminal
kafka-console-producer.sh --broker-list localhost:9092 --topic first_topic

# consuming from beginning
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic first_topic --from-beginning

# display key, values and timestamp in consumer
kafka-console-consumer.sh --bootstrap-server localhost:9092 \
--topic first_topic \
--formatter kafka.tools.DefaultMessageFormatter \
--property print.timestamp=true \
--property print.key=true \
--property print.value=true \
--from-beginning