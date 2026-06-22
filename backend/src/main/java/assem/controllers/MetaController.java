package assem.controllers;

import assem.exchange.commons.Result;
import assem.repository.MetaRepository;
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
@RequestMapping("/api/meta")
public class MetaController {

    @Autowired
    private MetaRepository metaRepository;
    private ControllerCheck checks = ControllerCheck.instance();

    @GetMapping("/{table}/{column}/{value}")
    public ResponseEntity<?> byColumnValue(
            @PathVariable String table,
            @PathVariable String column,
            @PathVariable String value,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        Result<List<Map<String, Object>>> result = metaRepository.selectByColumnValue(table, column, value);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/{table}/{column}")
    public ResponseEntity<?> columnFromTable(
            @PathVariable String table,
            @PathVariable String column,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        Result<List<Map<String, Object>>> result = metaRepository.selectColumn(table, column);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }

    @GetMapping("/{table}")
    public ResponseEntity<?> allFromTable(
            @PathVariable String table,
            HttpSession session
    ) {
        if (!checks.isAuthenticated(session)) {
            return ResponseEntity.status(401).body("Not authenticated.");
        }

        Result<List<Map<String, Object>>> result = metaRepository.selectAll(table);
        if (!result.isOk()) {
            return ResponseEntity.badRequest().body(result.getMessage());
        }
        return ResponseEntity.ok(result.getData());
    }
}
