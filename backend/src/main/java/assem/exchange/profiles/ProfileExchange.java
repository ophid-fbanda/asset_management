package assem.exchange.profiles;

import java.util.List;
import lombok.Data;
import assem.exchange.commons.Station;
import java.util.Map;
import java.util.stream.Collectors;

@Data
public class ProfileExchange {
    private Integer profileId;
    private String name;
    private String email;
    private String phone;
    private List<ProfileRole> roles;

    public ProfileExchange(Map<String, Object> profile) {
        try {
        this.profileId = (int) profile.get("profile_id");
            this.name = (String) profile.get("full_name");
            this.email = (String) profile.get("staff_email");
            this.phone = (String) profile.get("staff_phone");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            clear();
        }
    }

    public void clear() {
        this.profileId = null;
        this.name = null;
        this.email = null;
        this.phone = null;
        this.roles = null;
    }

    public boolean isEmpty() {
        return this.profileId == null ||
        this.name == null ||
        this.email == null ||
        this.phone == null;
    }

    public boolean hasRoles() {
        return this.roles != null && !this.roles.isEmpty();
    }

    public List<Station> getStations(int roleTypeId) {
        return roles
        .stream()
        .filter(role -> role.getRoleTypeId() == roleTypeId)
        .map(role -> new Station(role.getStationId(), role.getStationCode(), role.getStationName()))
        .collect(Collectors.toList());
    }

    public boolean hasRole(int roleTypeId) {
        return roles
        .stream()
        .anyMatch(role -> role.getRoleTypeId() == roleTypeId);
    }

    public boolean hasRole(int roleTypeId, int stationId) {
        return roles
        .stream()
        .anyMatch(role -> role.getRoleTypeId() == roleTypeId && role.getStationId() == stationId);
    }
}
