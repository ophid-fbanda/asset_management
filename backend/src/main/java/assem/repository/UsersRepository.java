package assem.repository;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileRole;
import assem.exchange.profiles.StaffCreateExchange;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Repository
public class UsersRepository {

    // Baseline login role — not assignable / removable from Users admin.
    private static final int GENERAL_USER_ROLE_TYPE_ID = 10;

    @Autowired
    private BaseRepo base;

    // List rows shaped for the staff cards (same shape a table would consume).
    public Result<List<Map<String, Object>>> getStaff() {
        Result<List<Map<String, Object>>> staff = base.fetch("""
                SELECT staff_profiles.id AS entity_id,
                       staff_profiles.full_name,
                       staff_profiles.staff_email,
                       staff_profiles.staff_phone
                FROM staff_profiles
                ORDER BY staff_profiles.full_name
                """, Map.of());
        if (!staff.isOk()) return staff;

        Result<List<Map<String, Object>>> roles = base.fetch("""
                SELECT staff_roles.id AS instance_id,
                       staff_roles.staff_profile_id,
                       staff_roles.role_type_id,
                       role_types.name AS role_type_name,
                       staff_roles.role_station_id AS station_id,
                       stations.station_code,
                       stations.station_name
                FROM staff_roles
                JOIN role_types ON role_types.id = staff_roles.role_type_id
                JOIN stations ON stations.id = staff_roles.role_station_id
                ORDER BY role_types.name, stations.station_name
                """, Map.of());
        if (!roles.isOk()) return Result.error(roles.getMessage());

        Map<Integer, List<ProfileRole>> rolesByStaff = new HashMap<>();
        Map<Integer, Map<String, Object>> homeByStaff = new HashMap<>();
        for (Map<String, Object> role : roles.getData()) {
            int staffId = ((Number) role.get("staff_profile_id")).intValue();
            // General User is baseline existence — expose as home station, not as an assignable role.
            if (((Number) role.get("role_type_id")).intValue() == GENERAL_USER_ROLE_TYPE_ID) {
                Map<String, Object> home = new LinkedHashMap<>();
                home.put("home_station_id", role.get("station_id"));
                home.put("home_station_name", role.get("station_name"));
                homeByStaff.putIfAbsent(staffId, home);
                continue;
            }
            ProfileRole profileRole = new ProfileRole(role);
            if (profileRole.isEmpty()) continue;
            rolesByStaff.computeIfAbsent(staffId, ignored -> new ArrayList<>()).add(profileRole);
        }

        List<Map<String, Object>> rows = new ArrayList<>();
        for (Map<String, Object> person : staff.getData()) {
            Map<String, Object> row = new LinkedHashMap<>(person);
            int entityId = ((Number) person.get("entity_id")).intValue();
            Map<String, Object> home = homeByStaff.getOrDefault(entityId, Map.of());
            row.put("home_station_id", home.get("home_station_id"));
            row.put("home_station_name", home.get("home_station_name"));
            row.put("roles", rolesByStaff.getOrDefault(entityId, List.of()));
            rows.add(row);
        }
        return Result.ok(rows);
    }

    public Result<Map<String, Object>> getStaffById(int entityId) {
        Result<List<Map<String, Object>>> all = getStaff();
        if (!all.isOk()) return Result.error(all.getMessage());
        for (Map<String, Object> row : all.getData()) {
            if (((Number) row.get("entity_id")).intValue() == entityId) {
                return Result.ok(row);
            }
        }
        return Result.error("Staff member not found.");
    }

    // Profile + login account + General User baseline (existence qualification).
    public Result<Boolean> createStaff(StaffCreateExchange staff) {
        Result<Map<String, Object>> taken = base.fetchOne("""
                SELECT staff_profiles.id
                FROM staff_profiles
                WHERE staff_profiles.id = :id
                   OR staff_profiles.staff_email = :staffEmail
                   OR staff_profiles.staff_phone = :staffPhone
                """, staff);
        if (!taken.isOk()) return Result.error(taken.getMessage());
        if (taken.getData() != null) {
            return Result.error("Staff id, email, or phone is already in use.");
        }

        Result<Boolean> profile = base.execute("""
                INSERT INTO staff_profiles (id, full_name, staff_email, staff_phone)
                VALUES (:id, :fullName, :staffEmail, :staffPhone)
                """, staff);
        if (!profile.isOk()) return Result.error(profile.getMessage());

        Result<Boolean> account = base.execute("""
                INSERT INTO staff_accounts (staff_profile_id, secret_key)
                VALUES (:id, encode(digest(:secretKey, 'sha256'), 'hex'))
                """, staff);
        if (!account.isOk()) {
            base.execute("DELETE FROM staff_profiles WHERE staff_profiles.id = :id", staff);
            return Result.error(account.getMessage());
        }

        Result<Boolean> baseline = base.execute("""
                INSERT INTO staff_roles (staff_profile_id, role_type_id, role_station_id)
                VALUES (:id, :roleTypeId, :homeStationId)
                """, Map.of(
                "id", staff.getId(),
                "roleTypeId", GENERAL_USER_ROLE_TYPE_ID,
                "homeStationId", staff.getHomeStationId()
        ));
        if (!baseline.isOk()) {
            base.execute("DELETE FROM staff_accounts WHERE staff_accounts.staff_profile_id = :id", staff);
            base.execute("DELETE FROM staff_profiles WHERE staff_profiles.id = :id", staff);
            return Result.error(baseline.getMessage());
        }

        return Result.ok(true);
    }

    public Result<Boolean> resetPassword(int staffProfileId, String secretKey) {
        if (secretKey == null || secretKey.trim().length() < 4) {
            return Result.error("Password must be at least 4 characters.");
        }

        Result<Map<String, Object>> account = base.fetchOne("""
                SELECT staff_accounts.id
                FROM staff_accounts
                WHERE staff_accounts.staff_profile_id = :staffProfileId
                """, Map.of("staffProfileId", staffProfileId));
        if (!account.isOk()) return Result.error(account.getMessage());
        if (account.getData() == null) {
            return Result.error("Login account not found for this staff member.");
        }

        return base.execute("""
                UPDATE staff_accounts
                SET secret_key = encode(digest(:secretKey, 'sha256'), 'hex')
                WHERE staff_accounts.staff_profile_id = :staffProfileId
                """, Map.of(
                "secretKey", secretKey.trim(),
                "staffProfileId", staffProfileId
        ));
    }

    // Relocate (or provision) the General User baseline station — not shown as an assignable role.
    public Result<Boolean> updateHomeStation(int staffProfileId, int homeStationId) {
        if (homeStationId <= 0) {
            return Result.error("Home station is required.");
        }

        Result<List<Map<String, Object>>> current = base.fetch("""
                SELECT staff_roles.id, staff_roles.role_station_id
                FROM staff_roles
                WHERE staff_roles.staff_profile_id = :staffProfileId
                  AND staff_roles.role_type_id = :roleTypeId
                """, Map.of(
                "staffProfileId", staffProfileId,
                "roleTypeId", GENERAL_USER_ROLE_TYPE_ID
        ));
        if (!current.isOk()) return Result.error(current.getMessage());

        List<Map<String, Object>> rows = current.getData() != null ? current.getData() : List.of();
        if (rows.isEmpty()) {
            return base.execute("""
                    INSERT INTO staff_roles (staff_profile_id, role_type_id, role_station_id)
                    VALUES (:staffProfileId, :roleTypeId, :homeStationId)
                    """, Map.of(
                    "staffProfileId", staffProfileId,
                    "roleTypeId", GENERAL_USER_ROLE_TYPE_ID,
                    "homeStationId", homeStationId
            ));
        }

        // Collapse any duplicate baseline rows to a single home station.
        Result<Boolean> cleared = base.execute("""
                DELETE FROM staff_roles
                WHERE staff_roles.staff_profile_id = :staffProfileId
                  AND staff_roles.role_type_id = :roleTypeId
                """, Map.of(
                "staffProfileId", staffProfileId,
                "roleTypeId", GENERAL_USER_ROLE_TYPE_ID
        ));
        if (!cleared.isOk()) return Result.error(cleared.getMessage());

        return base.execute("""
                INSERT INTO staff_roles (staff_profile_id, role_type_id, role_station_id)
                VALUES (:staffProfileId, :roleTypeId, :homeStationId)
                """, Map.of(
                "staffProfileId", staffProfileId,
                "roleTypeId", GENERAL_USER_ROLE_TYPE_ID,
                "homeStationId", homeStationId
        ));
    }

    public Result<Boolean> addRole(int staffProfileId, ProfileRole role) {
        if (role == null || role.getRoleTypeId() == 0 || role.getStationId() == 0) {
            return Result.error("Role type and station are required.");
        }
        if (role.getRoleTypeId() == GENERAL_USER_ROLE_TYPE_ID) {
            return Result.error("General User is required for every account and is not optional.");
        }

        Result<Map<String, Object>> existing = base.fetchOne("""
                SELECT staff_roles.id
                FROM staff_roles
                WHERE staff_roles.staff_profile_id = :staffProfileId
                  AND staff_roles.role_type_id = :roleTypeId
                  AND staff_roles.role_station_id = :stationId
                """, Map.of(
                "staffProfileId", staffProfileId,
                "roleTypeId", role.getRoleTypeId(),
                "stationId", role.getStationId()
        ));
        if (!existing.isOk()) return Result.error(existing.getMessage());
        if (existing.getData() != null) {
            return Result.error("That role is already assigned at this station.");
        }

        return base.execute("""
                INSERT INTO staff_roles (staff_profile_id, role_type_id, role_station_id)
                VALUES (:staffProfileId, :roleTypeId, :stationId)
                """, Map.of(
                "staffProfileId", staffProfileId,
                "roleTypeId", role.getRoleTypeId(),
                "stationId", role.getStationId()
        ));
    }

    public Result<Boolean> removeRole(ProfileRole role) {
        if (role == null || role.getInstanceId() == 0) {
            return Result.error("Role assignment is required.");
        }

        Result<Map<String, Object>> current = base.fetchOne("""
                SELECT staff_roles.role_type_id
                FROM staff_roles
                WHERE staff_roles.id = :instanceId
                """, Map.of("instanceId", role.getInstanceId()));
        if (!current.isOk()) return Result.error(current.getMessage());
        if (current.getData() == null) {
            return Result.error("Role assignment not found.");
        }
        if (((Number) current.getData().get("role_type_id")).intValue() == GENERAL_USER_ROLE_TYPE_ID) {
            return Result.error("General User cannot be removed — it is required to sign in.");
        }

        return base.execute("""
                DELETE FROM staff_roles
                WHERE staff_roles.id = :instanceId
                """, Map.of("instanceId", role.getInstanceId()));
    }
}
