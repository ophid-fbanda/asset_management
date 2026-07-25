package assem.exchange.assets;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class IssuanceItemExchange {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;
    public void setRegisteredAssetId(String v) {
        try { this.registeredAssetId = Integer.parseInt(v.trim()); } catch (Exception e) { this.registeredAssetId = null; }
    }

    // Set server-side after the parent issuance is persisted.
    Integer assetIssuanceId;
}
