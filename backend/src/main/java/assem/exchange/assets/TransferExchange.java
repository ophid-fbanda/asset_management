package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.List;

// DTO for asset_transfers (parent) + asset_transfer_items (children).
// Received as application/json via @RequestBody — Jackson deserialises all
// fields natively. eventAdminId and eventId are set server-side.
@EqualsAndHashCode(callSuper = true)
@Data
public class TransferExchange extends ExchangeBase {

    @NotNull(message = "Destination station is required.")
    Integer receivingStationId;

    @NotNull(message = "Origin station is required.")
    Integer eventStationId;

    @NotEmpty(message = "At least one asset must be selected.")
    @Valid
    List<TransferItemExchange> items;

    String notes;
}
