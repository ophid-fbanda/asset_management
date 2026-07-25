package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class IssuanceExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Recipient is required.")
    Integer receivingStaffId;
    public void setReceivingStaffId(String v) {
        try { this.receivingStaffId = Integer.parseInt(v.trim()); } catch (Exception e) { this.receivingStaffId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Issuance type is required.")
    Integer issuanceTypeId;
    public void setIssuanceTypeId(String v) {
        try { this.issuanceTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.issuanceTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Origin station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    @NotEmpty(message = "At least one asset must be selected.")
    @Valid
    List<IssuanceItemExchange> items;

    String notes;
}
