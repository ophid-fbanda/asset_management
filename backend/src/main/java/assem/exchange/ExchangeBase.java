package assem.exchange;

import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

import java.time.LocalDate;

@Data
public class ExchangeBase {

    Integer eventId;

    // Set server-side from the session profile inside the controller. Nullable.
    Integer eventAdminId;

    // Business date of the event (not record stamp). Required by asset event tables.
    @Setter(AccessLevel.NONE)
    LocalDate eventDate;

    public void setEventDate(String value) {
        try {
            this.eventDate = LocalDate.parse(value.substring(0, 10));
        } catch (Exception e) {
            this.eventDate = null;
        }
    }

    public boolean hasEventId() {
        return eventId != null;
    }

    public void debug() {
        System.out.println(this);
    }
}
