package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

import java.util.List;

// DTO for asset_requests (parent) plus staged asset_request_items.
// event_register_id, event_admin_id and stamp are server-side.
@EqualsAndHashCode(callSuper = true)
@Data
public class RequestExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Program is required.")
    Integer requestProgramId;

    public void setRequestProgramId(String v) {
        try {
            this.requestProgramId = Integer.parseInt(v.trim());
        } catch (Exception e) {
            this.requestProgramId = null;
        }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Station is required.")
    Integer eventStationId;

    public void setEventStationId(String v) {
        try {
            this.eventStationId = Integer.parseInt(v.trim());
        } catch (Exception e) {
            this.eventStationId = null;
        }
    }

    String notes;

    @NotEmpty(message = "At least one line item is required.")
    @Valid
    List<RequestItemExchange> items;
}
