package assem.exchange.profiles;

import lombok.Data;
import java.util.Map;
@Data
public class ProfileRole{
    private int instanceId;
    private int roleTypeId;
    private String roleTypeName;
    private int stationId;
    private String stationCode;
    private String stationName;

    public ProfileRole(
                int instanceId, 
                int roleTypeId, 
                String roleTypeName, 
                int stationId, 
                String stationCode, 
                String stationName
        ) {
        if(instanceId == 0 || roleTypeId == 0 || stationId == 0 || stationCode == null || stationName == null || roleTypeName == null){
            clear();
            return;
        }

        this.instanceId = instanceId;
        this.roleTypeId = roleTypeId;
        this.roleTypeName = roleTypeName;
        this.stationId = stationId;
        this.stationCode = stationCode;
        this.stationName = stationName;
    }

    public ProfileRole(Map<String, Object> role) {
        try {
            this.instanceId = (int) role.get("instance_id");
            this.roleTypeId = (int) role.get("role_type_id");
            this.roleTypeName = (String) role.get("role_type_name");
            this.stationId = (int) role.get("station_id");
            this.stationCode = (String) role.get("station_code");
            this.stationName = (String) role.get("station_name");
        } catch (Exception e) {
            clear();
        }
    }

    public void clear() {
        this.instanceId = 0;
        this.roleTypeId = 0;
        this.roleTypeName = null;
        this.stationId = 0;
        this.stationCode = null;
        this.stationName = null;
    }

    public boolean isEmpty() {
        return this.instanceId == 0 ||
        this.roleTypeId == 0 ||
        this.roleTypeName == null ||
        this.stationId == 0 ||
        this.stationCode == null ||
        this.stationName == null;
    }
}
