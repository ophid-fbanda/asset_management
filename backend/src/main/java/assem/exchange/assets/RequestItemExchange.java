package assem.exchange.assets;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class RequestItemExchange {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset type is required.")
    Integer requestedAssetTypeId;

    public void setRequestedAssetTypeId(String v) {
        try {
            this.requestedAssetTypeId = Integer.parseInt(v.trim());
        } catch (Exception e) {
            this.requestedAssetTypeId = null;
        }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Quantity is required.")
    @Min(value = 1, message = "Quantity must be at least 1.")
    Integer requestedQuantity;

    public void setRequestedQuantity(String v) {
        try {
            this.requestedQuantity = Integer.parseInt(v.trim());
        } catch (Exception e) {
            this.requestedQuantity = null;
        }
    }

    // Set server-side after the parent request is persisted.
    Integer assetRequestId;
}
