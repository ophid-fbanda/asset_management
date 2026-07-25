package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

@EqualsAndHashCode(callSuper = true)
@Data
public class DisposalExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;
    public void setRegisteredAssetId(String v) {
        try { this.registeredAssetId = Integer.parseInt(v.trim()); } catch (Exception e) { this.registeredAssetId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Disposal type is required.")
    Integer disposalTypeId;
    public void setDisposalTypeId(String v) {
        try { this.disposalTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.disposalTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    String eventNotes;
}
