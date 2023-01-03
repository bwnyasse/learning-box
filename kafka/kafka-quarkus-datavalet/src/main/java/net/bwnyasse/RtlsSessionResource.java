package net.bwnyasse;

import javax.inject.Inject;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.eclipse.microprofile.reactive.messaging.Channel;
import org.jboss.logging.Logger;

import io.smallrye.mutiny.Multi;

@Path("/rtlssession")
public class RtlsSessionResource {
    
    @Inject
    Logger logger;


    @Channel("RTLS_Sessions")
    Multi<RtlsSession> rtlsSessions;

    @GET
    @Produces(MediaType.SERVER_SENT_EVENTS) 
    public Multi<RtlsSession> stream() {
        return rtlsSessions; 
    }
}
