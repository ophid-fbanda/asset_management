package assem.exchange.profiles;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class StaffCreateExchange {

    // staff_profiles.id is not serial — admin assigns the login id manually.
    @NotNull(message = "Staff id is required.")
    Integer id;

    @NotBlank(message = "Full name is required.")
    String fullName;

    @NotBlank(message = "Email is required.")
    String staffEmail;

    @NotBlank(message = "Phone is required.")
    String staffPhone;

    @JsonProperty("password")
    @NotBlank(message = "Password is required.")
    @Size(min = 4, max = 255, message = "Password must be between 4 and 255 characters.")
    String secretKey;

    // Station for the auto-provisioned General User baseline.
    @NotNull(message = "Home station is required.")
    Integer homeStationId;
}
