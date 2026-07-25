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

@EqualsAndHashCode(callSuper = true)
@Data
public class TransferExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Destination station is required.")
    Integer receivingStationId;
    public void setReceivingStationId(String v) {
        try { this.receivingStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.receivingStationId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Origin station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    @NotEmpty(message = "At least one asset must be selected.")
    @Valid
    List<TransferItemExchange> items;

    String notes;
}
