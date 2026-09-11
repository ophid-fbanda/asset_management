package assem.exchange;

import lombok.Data;

@Data
public class ExchangeBase {

    Integer eventId;

    // Set server-side from the session profile inside the controller. Nullable.
    Integer eventAdminId;

    public boolean hasEventId() {
        return eventId != null;
    }


    public void debug() {
        System.out.println(this);
    }
}
