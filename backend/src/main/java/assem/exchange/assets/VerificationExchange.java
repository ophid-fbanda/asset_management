package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

@EqualsAndHashCode(callSuper = true)
@Data
public class VerificationExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;
    public void setRegisteredAssetId(String v) {
        try { this.registeredAssetId = Integer.parseInt(v.trim()); } catch (Exception e) { this.registeredAssetId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Verification type is required.")
    Integer verificationTypeId;
    public void setVerificationTypeId(String v) {
        try { this.verificationTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.verificationTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Verified condition is required.")
    Integer verifiedConditionTypeId;
    public void setVerifiedConditionTypeId(String v) {
        try { this.verifiedConditionTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.verifiedConditionTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    String eventNotes;
}
