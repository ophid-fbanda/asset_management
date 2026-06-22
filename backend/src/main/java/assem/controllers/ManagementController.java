package assem.controllers;

import assem.exchange.commons.Result;
import assem.repository.ManagementRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/management")
public class ManagementController {

    @Autowired
    private ManagementRepository managementRepository;

    private final ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/pending/{id}")
    public ResponseEntity<?> pending(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Result<List<Map<String, Object>>> result = managementRepository.pending(id);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/history/{id}")
    public ResponseEntity<?> history(@PathVariable int id, HttpSession session) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Unauthorized");
        }

        Result<List<Map<String, Object>>> result = managementRepository.history(id);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }

        return ResponseEntity.ok(result.getData());
    }
}
