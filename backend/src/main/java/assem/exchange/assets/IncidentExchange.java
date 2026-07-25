package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

@EqualsAndHashCode(callSuper = true)
@Data
public class IncidentExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;
    public void setRegisteredAssetId(String v) {
        try { this.registeredAssetId = Integer.parseInt(v.trim()); } catch (Exception e) { this.registeredAssetId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Incident type is required.")
    Integer incidentTypeId;
    public void setIncidentTypeId(String v) {
        try { this.incidentTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.incidentTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    String eventNotes;

    MultipartFile incidentAssetImage;
    MultipartFile incidentPoliceReport;

    // Set server-side from FileUtil.save(...); nullable when no file uploaded.
    String incidentAssetImagePath;
    String incidentPoliceReportPath;
}
