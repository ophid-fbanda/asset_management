package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import assem.utils.TypeConvertor;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;
import tools.jackson.core.type.TypeReference;

import java.util.List;

// DTO for asset_transfers (the parent) plus its asset_transfer_items children.
// receivingStationId is the destination; eventStationId is the origin station
// (admin's station). items arrive as a JSON string from the client and are
// parsed via TypeConvertor. eventAdminId and event_register_id are set server-side.
@EqualsAndHashCode(callSuper = true)
@Data
public class TransferExchange extends ExchangeBase {

    @NotNull(message = "Destination station is required.")
    @Setter(AccessLevel.NONE)
    Integer receivingStationId;

    @NotNull(message = "Origin station is required.")
    @Setter(AccessLevel.NONE)
    Integer eventStationId;

    @NotEmpty(message = "At least one asset must be selected.")
    @Valid
    @Setter(AccessLevel.NONE)
    List<TransferItemExchange> items;

    String notes;

    public void setReceivingStationId(String value) {
        try { this.receivingStationId = Integer.parseInt(value); }
        catch (Exception e) { this.receivingStationId = null; }
    }

    public void setEventStationId(String value) {
        try { this.eventStationId = Integer.parseInt(value); }
        catch (Exception e) { this.eventStationId = null; }
    }

    public void setItems(String value) {
        this.items = TypeConvertor.instance().readJson(value, new TypeReference<List<TransferItemExchange>>() {});
    }
}
