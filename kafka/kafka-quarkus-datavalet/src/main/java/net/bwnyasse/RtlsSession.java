package net.bwnyasse;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.ToString;


@Data
@AllArgsConstructor
@ToString
public class RtlsSession {
    public String uuid;
    public String site_uuid;
    public String device_mac;
    public String start;
    public String lastseen;
    public String end;
    public int duration;
    public int walkin_duration;
    public boolean has_walkin;
    public boolean has_associated;
    public boolean is_associated;
    public boolean is_random;
    public int last_rssi;
    public int max_rssi;
    public int event_count;
    public String session_state;
    public String customer;
    public String brand;
    public String site;
    public String timezone;
    public boolean notify_enabled;
    public int rssi_threshold;
    public int lag_ms;
    public int session_timeout_ms;
}
