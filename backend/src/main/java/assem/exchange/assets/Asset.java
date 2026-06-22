package assem.exchange.assets;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.Data;
import lombok.Setter;

import java.math.BigDecimal;

// DTO for registered_assets. UI-only narrowing keys (assetTypeId, assetBrandId,
// noSerial) ride along in the JSON but are intentionally ignored here.
@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class Asset {

    @NotNull(message = "Asset model is required.")
    @Setter(AccessLevel.NONE)
    Integer assetModelId;

    @NotBlank(message = "Serial number is required.")
    @Size(max = 255, message = "Serial number must be at most 255 characters.")
    String serialNumber;

    @NotNull(message = "Asset condition is required.")
    @Setter(AccessLevel.NONE)
    Integer conditionTypeId;

    @NotNull(message = "Acquisition value is required.")
    @Positive(message = "Acquisition value must be greater than zero.")
    @Setter(AccessLevel.NONE)
    BigDecimal acquisitionValue;

    // Set server-side during persistence; not part of the client payload.
    Integer assetRegistrationId;
    String assetNumber;

    public void setAssetModelId(String value) {
        try {
            this.assetModelId = Integer.parseInt(value);
        } catch (Exception e) {
            this.assetModelId = null;
        }
    }

    public void setConditionTypeId(String value) {
        try {
            this.conditionTypeId = Integer.parseInt(value);
        } catch (Exception e) {
            this.conditionTypeId = null;
        }
    }

    public void setAcquisitionValue(String value) {
        try {
            this.acquisitionValue = new BigDecimal(value);
        } catch (Exception e) {
            this.acquisitionValue = null;
        }
    }
}
