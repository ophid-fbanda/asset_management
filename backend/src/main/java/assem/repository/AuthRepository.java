package assem.repository;

import assem.exchange.auth.StaffProfileRequest;
import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import assem.exchange.profiles.ProfileExchange;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import assem.exchange.profiles.ProfileRole;

@Repository
public class AuthRepository {

    @Autowired
    private BaseRepo base;


    public Result<ProfileExchange> profileByCredentials(StaffProfileRequest credentials) {
      String sql = """
      SELECT staff_profiles.id AS profile_id,
                       staff_profiles.full_name,
                       staff_profiles.staff_email,
                       staff_profiles.staff_phone
                FROM staff_profiles 
                JOIN staff_accounts ON staff_accounts.staff_profile_id = staff_profiles.id
                WHERE staff_accounts.staff_profile_id = :staffProfileId
                  AND staff_accounts.secret_key = encode(digest(:secretKey, 'sha256'), 'hex')
                """;
        Result<Map<String, Object>> result = base.fetchOne(sql, credentials);
        

        if(!result.isOk()){
          return Result.error("We could not find your profile.");
        }

        Map<String, Object> data = result.getData();
        if(data == null){
          return Result.error("Invalid credentials.");
        }

        //System.out.println(data);

        ProfileExchange profile = new ProfileExchange(data);

        if(profile.isEmpty()){
          return Result.error("Account processing error.");
        }


        Result<List<Map<String, Object>>> rolesResult = rolesByProfileId(profile.getProfileId());
        if(!rolesResult.isOk()){
          return Result.error("Role assignment error.");
        }


        List<Map<String, Object>> roles = rolesResult.getData();
        if( roles.isEmpty()){
          return Result.error("Access denied.");
        }

        List<ProfileRole> profileRoles = roles.stream()
        .map(role -> new ProfileRole(role))
        .collect(Collectors.toList())
        .stream()
        .filter(profileRole -> !profileRole.isEmpty())
        .collect(Collectors.toList());

        if(profileRoles.isEmpty()){
          return Result.error("Access denied.");
        }

        profile.setRoles(profileRoles);

        return Result.ok(profile);
    }

    public Result<List<Map<String, Object>>> rolesByProfileId(Integer staffProfileId) {
        if(staffProfileId == null){
          return Result.error("Invalid profile ID.");
        }

        String sql = """
        SELECT staff_roles.id as instance_id,
                       staff_roles.role_type_id,
                       role_types.name AS role_type_name,
                       staff_roles.role_station_id as station_id,
                       stations.station_code,
                       stations.station_name
                FROM staff_roles
                JOIN role_types ON role_types.id = staff_roles.role_type_id
                JOIN stations ON stations.id = staff_roles.role_station_id
                WHERE staff_roles.staff_profile_id = :staffProfileId
                """;
        Result<List<Map<String, Object>>> result = base.fetch(sql, Map.of("staffProfileId", staffProfileId));

        if(!result.isOk()){
          return Result.error("Error fetching roles.");
        }

        return Result.ok(result.getData());
        
    }
}
