package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import assem.utils.TypeConvertor;
import tools.jackson.core.type.TypeReference;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

// DTO for asset_registrations (the parent) plus its staged registered_assets.
// referenceAttachment is persisted via FileUtil.save() which yields the stored
// path. supplier arrives as a name (editable on the client); the service
// resolves it to supplier_id. event_register_id, event_admin_id and stamp are
// server-side.
@EqualsAndHashCode(callSuper = true)
@Data
public class Registration extends ExchangeBase {

    @NotNull(message = "Program is required.")
    @Setter(AccessLevel.NONE)
    Integer programId;

    @NotNull(message = "Acquisition type is required.")
    @Setter(AccessLevel.NONE)
    Integer acquisitionTypeId;

    @NotNull(message = "Reference attachment is required.")
    MultipartFile referenceAttachment;

    // Set server-side from FileUtil.save(referenceAttachment); persisted to
    // reference_attachment. Nullable until the upload is stored.
    String referenceAttachmentPath;

    @NotNull(message = "Reference type is required.")
    @Setter(AccessLevel.NONE)
    Integer referenceTypeId;

    @NotNull(message = "Reference date is required.")
    @Setter(AccessLevel.NONE)
    LocalDate referenceDate;

    @NotBlank(message = "Supplier is required.")
    @Size(max = 255, message = "Supplier must be at most 255 characters.")
    String supplierName;

    // Resolved server-side from supplierName via AssetsRepository.resolveSupplierId.
    // Nullable until set.
    Integer supplierId;

    String notes;

    @NotNull(message = "Station is required.")
    @Setter(AccessLevel.NONE)
    Integer eventStationId;

    @NotEmpty(message = "At least one asset is required.")
    @Valid
    @Setter(AccessLevel.NONE)
    List<Asset> assets;

    public void setProgramId(String value) {
        try {
            this.programId = Integer.parseInt(value);
        } catch (Exception e) {
            this.programId = null;
        }
    }

    public void setAcquisitionTypeId(String value) {
        try {
            this.acquisitionTypeId = Integer.parseInt(value);
        } catch (Exception e) {
            this.acquisitionTypeId = null;
        }
    }

    public void setReferenceTypeId(String value) {
        try {
            this.referenceTypeId = Integer.parseInt(value);
        } catch (Exception e) {
            this.referenceTypeId = null;
        }
    }

    public void setEventStationId(String value) {
        try {
            this.eventStationId = Integer.parseInt(value);
        } catch (Exception e) {
            this.eventStationId = null;
        }
    }

    // Tolerates both "yyyy-MM-dd" and full ISO timestamps by reading the date head.
    public void setReferenceDate(String value) {
        try {
            this.referenceDate = LocalDate.parse(value.substring(0, 10));
        } catch (Exception e) {
            this.referenceDate = null;
        }
    }

    // Assets arrive as a serialized JSON string from the client; readJson is
    // already fail-safe (returns null on bad input).
    public void setAssets(String value) {
        this.assets = TypeConvertor.instance().readJson(value, new TypeReference<List<Asset>>() {});
    }
}
