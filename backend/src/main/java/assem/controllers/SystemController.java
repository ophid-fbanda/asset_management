package assem.controllers;

import assem.exchange.commons.Result;
import assem.exchange.profiles.ProfileExchange;
import assem.repository.SystemRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/system")
public class SystemController {

    private static final int SYSTEM_ADMIN_ROLE_TYPE_ID = 80;

    @Autowired
    private SystemRepository systemRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    private ResponseEntity<?> denyUnlessSystemAdmin(HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }
        ProfileExchange profile = checks.getProfile(session);
        if (!profile.hasRole(SYSTEM_ADMIN_ROLE_TYPE_ID)) {
            return ResponseEntity.status(403).body("System administrator role required.");
        }
        return null;
    }

    @GetMapping("/lookups")
    public ResponseEntity<?> catalog(HttpSession session) {
        ResponseEntity<?> denied = denyUnlessSystemAdmin(session);
        if (denied != null) return denied;
        return ResponseEntity.ok(systemRepository.catalog());
    }

    @GetMapping("/lookups/{table}")
    public ResponseEntity<?> list(@PathVariable String table, HttpSession session) {
        ResponseEntity<?> denied = denyUnlessSystemAdmin(session);
        if (denied != null) return denied;

        Result<List<Map<String, Object>>> result = systemRepository.list(table);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    // Literal suffixes (/create|/update|/delete) — avoid ambiguous POST /lookups/{table}
    // swallowing paths like .../programs/update as table="programs/update".
    @PostMapping("/lookups/{table}/create")
    public ResponseEntity<?> create(
            @PathVariable String table,
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        ResponseEntity<?> denied = denyUnlessSystemAdmin(session);
        if (denied != null) return denied;

        Result<Boolean> result = systemRepository.create(table, body);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @PostMapping("/lookups/{table}/update")
    public ResponseEntity<?> update(
            @PathVariable String table,
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        ResponseEntity<?> denied = denyUnlessSystemAdmin(session);
        if (denied != null) return denied;

        Result<Boolean> result = systemRepository.update(table, body);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(true);
    }

    @PostMapping("/lookups/{table}/delete")
    public ResponseEntity<?> delete(
            @PathVariable String table,
            @RequestBody Map<String, Object> body,
            HttpSession session
    ) {
        ResponseEntity<?> denied = denyUnlessSystemAdmin(session);
        if (denied != null) return denied;

        Object raw = body != null ? body.get("id") : null;
        if (!(raw instanceof Number)) {
            return ResponseEntity.badRequest().body("Id is required.");
        }

        Result<Boolean> result = systemRepository.delete(table, ((Number) raw).intValue());
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        if (Boolean.FALSE.equals(result.getData())) {
            return ResponseEntity.badRequest().body("Lookup row not found.");
        }
        return ResponseEntity.ok(true);
    }
}
