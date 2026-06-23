package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

// DTO for asset_transfers (the parent) plus its asset_transfer_items.
// receivingStationId is the destination; eventStationId is the origin (from
// the admin's current station). assetIds maps to asset_transfer_items rows.
// eventAdminId and the event_register_id are resolved server-side.
@EqualsAndHashCode(callSuper = true)
@Data
public class Transfer extends ExchangeBase {

    @NotNull(message = "Destination station is required.")
    Integer receivingStationId;

    @NotNull(message = "Origin station is required.")
    Integer eventStationId;

    @NotEmpty(message = "At least one asset must be selected.")
    List<Integer> assetIds;

    String notes;
}
