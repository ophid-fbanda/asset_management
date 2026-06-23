package assem.exchange.assets;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

// DTO for asset_transfer_items.
// registeredAssetId maps to asset_transfer_items.registered_asset_id.
// assetTransferId is set server-side after the parent asset_transfers row is
// inserted; it is not part of the client payload.
@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class TransferItem {

    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;

    // Set server-side after the parent transfer is persisted.
    Integer assetTransferId;
}
