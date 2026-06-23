package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

// DTO for asset_transfers (the parent) plus its asset_transfer_items children.
// receivingStationId is the destination; eventStationId is the origin station
// (admin's station). items map one-to-one to asset_transfer_items rows.
// eventAdminId and event_register_id are resolved server-side.
@EqualsAndHashCode(callSuper = true)
@Data
public class Transfer extends ExchangeBase {

    @NotNull(message = "Destination station is required.")
    Integer receivingStationId;

    @NotNull(message = "Origin station is required.")
    Integer eventStationId;

    @NotEmpty(message = "At least one asset must be selected.")
    @Valid
    List<TransferItem> items;

    String notes;
}
