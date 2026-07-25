package assem.exchange.assets;

import assem.exchange.ExchangeBase;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AccessLevel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;

import java.math.BigDecimal;

@EqualsAndHashCode(callSuper = true)
@Data
public class EvaluationExchange extends ExchangeBase {

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Asset is required.")
    Integer registeredAssetId;
    public void setRegisteredAssetId(String v) {
        try { this.registeredAssetId = Integer.parseInt(v.trim()); } catch (Exception e) { this.registeredAssetId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Evaluation type is required.")
    Integer evaluationTypeId;
    public void setEvaluationTypeId(String v) {
        try { this.evaluationTypeId = Integer.parseInt(v.trim()); } catch (Exception e) { this.evaluationTypeId = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Evaluated value is required.")
    @Positive(message = "Evaluated value must be greater than zero.")
    BigDecimal evaluatedValue;
    public void setEvaluatedValue(String v) {
        try { this.evaluatedValue = new BigDecimal(v.trim()); } catch (Exception e) { this.evaluatedValue = null; }
    }

    @Setter(AccessLevel.NONE)
    @NotNull(message = "Station is required.")
    Integer eventStationId;
    public void setEventStationId(String v) {
        try { this.eventStationId = Integer.parseInt(v.trim()); } catch (Exception e) { this.eventStationId = null; }
    }

    String eventNotes;
}
