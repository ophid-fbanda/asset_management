package assem.exchange.auth;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Setter;
import lombok.AccessLevel;
import assem.exchange.ExchangeBase;
import com.fasterxml.jackson.annotation.JsonProperty;

@Data
@EqualsAndHashCode(callSuper = true)
public class StaffProfileRequest extends ExchangeBase {

        @JsonProperty("username")
        @NotBlank(message = "Username is required.")
        String username;

        @JsonProperty("password")
        @NotBlank(message = "Password is required.")
        @Size(min = 4, max = 255, message = "Password must be between 4 and 255 characters.")
        String secretKey;

        @NotNull(message = "Username is invalid.")
        @Setter(AccessLevel.NONE)
        Integer staffProfileId;
        
        public void setUsername(String username) {
                this.username = username;
                try{
                        this.staffProfileId = Integer.parseInt(username);
                } catch (Exception e) {
                        this.staffProfileId = null;
                }
        }

}
