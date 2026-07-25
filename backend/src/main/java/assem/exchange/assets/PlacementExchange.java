package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

@EqualsAndHashCode(callSuper = true)
@Data
public class PlacementExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;
    public void setRegisteredAssetId(String v) {
        try { this.registeredAssetId = Integer.parseInt(v.trim()); } catch (Exception e) { this.registeredAssetId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Placement type is required.")
    Integer placementTypeId;
    public void setPlacementTypeId(String v) {
        try { this.placementTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.placementTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    String eventNotes;
}
