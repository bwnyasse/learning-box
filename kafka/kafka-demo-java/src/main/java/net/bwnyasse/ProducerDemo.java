package net.bwnyasse;

import java.util.Properties;

import org.apache.kafka.clients.producer.Callback;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.serialization.StringSerializer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProducerDemo {

   private static final Logger log = LoggerFactory.getLogger(ProducerDemo.class);

   public static void main(String[] args) {
      log.info("I am a kafka Producer");

      final String bootstrapServers = "localhost:9092";

      // create Producer properties
      final Properties properties = new Properties();
      properties.setProperty(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
      properties.setProperty(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
      properties.setProperty(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

      // create the producer
      final KafkaProducer<String, String> producer = new KafkaProducer<>(properties);

      for (int i = 0; i < 10; i++) {

         String topic = "demo_java";
         String value = "hello world " + Integer.toString(i);

         /*
          * Keys become useful when a user wants to introduce ordering and ensure
          * the messages that share the same key end up in the same partition.
          */
         String key = "id_" + Integer.toString(i);

         // create a producer record
         final ProducerRecord<String, String> producerRecord = new ProducerRecord<>(topic,
               key, value);

         // send data - asynchronous
         producer.send(producerRecord, new Callback() {
            public void onCompletion(RecordMetadata recordMetadata, Exception e) {
               // executes every time a record is successfully sent or an exception is thrown
               if (e == null) {
                  // the record was successfully sent
                  log.info("Received new metadata. \n" +
                        "Topic:" + recordMetadata.topic() + "\n" +
                        "Key:" + producerRecord.key() + "\n" +
                        "Partition: " + recordMetadata.partition() + "\n" +
                        "Offset: " + recordMetadata.offset() + "\n" +
                        "Timestamp: " + recordMetadata.timestamp());
               } else {
                  log.error("Error while producing", e);
               }
            }
         });

         /**
          * Since Kafka v2.4.0, the partitioner is a Sticky Partitioner,
          * which means the producer that receives messages sent in time
          * close to each other will try to fill a batch into ONE partition
          * before switching to creating a batch for another partition.
          * To observe the round-robin feature of Kafka, we can add a Thread.sleep(1000)
          * in between each iteration of the loop, which will force the batch to be sent
          * and a new batch to be created for a different partition.
          **/
         try {
            Thread.sleep(1000);
         } catch (InterruptedException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
         }
      }

      // flush data - synchronous
      producer.flush();

      // flush and close producer
      producer.close();
   }
}
