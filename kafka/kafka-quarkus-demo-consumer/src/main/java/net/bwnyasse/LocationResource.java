package net.bwnyasse;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.jboss.logging.Logger;

import io.smallrye.mutiny.Multi;
import tech.allegro.schema.json2avro.converter.JsonAvroConverter;

@Path("/location")
public class LocationResource {

    String schema = "{\"fields\":[{\"name\":\"record_uuid\",\"type\":\"string\"},{\"name\":\"source_uuid\",\"type\":\"string\"},{\"name\":\"source_timestamp\",\"type\":\"long\"},{\"name\":\"ap_oem\",\"type\":\"string\"},{\"name\":\"device_mac\",\"type\":\"string\"},{\"name\":\"timestamp\",\"type\":\"long\"},{\"name\":\"x_coord\",\"type\":\"float\"},{\"name\":\"y_coord\",\"type\":\"float\"},{\"name\":\"floorplan_id\",\"type\":\"string\"},{\"name\":\"variance\",\"type\":\"float\"},{\"name\":\"units\",\"type\":\"string\"}],\"name\":\"Location\",\"type\":\"record\"}";

    @Inject
    Logger logger;

    @Channel("topic_location")
    Multi<byte[]> locations;

    @GET
    @Produces(MediaType.SERVER_SENT_EVENTS)
    public Multi<byte[]> stream() {
        JsonAvroConverter converter = new JsonAvroConverter();
        return locations.map(item -> converter.convertToJson(item, schema));
    }

}
