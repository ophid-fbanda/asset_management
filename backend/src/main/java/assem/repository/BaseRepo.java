package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.BeanPropertySqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BaseRepo {

    @Autowired
    private NamedParameterJdbcTemplate run;

    public Result<List<Map<String, Object>>> fetch(String sql, Object params) {
        try {
            List<Map<String, Object>> result = run.queryForList(sql, new BeanPropertySqlParameterSource(params));
            return Result.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error(e.getMessage());
        }
    }

    public Result<List<Map<String, Object>>> fetch(String sql, Map<String, Object> params) {
        try {
            List<Map<String, Object>> result = run.queryForList(sql, params);
            return Result.ok(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error(e.getMessage());
        }
    }

    public Result<Map<String, Object>> fetchOne(String sql, Object params) {
        Result<List<Map<String, Object>>> pulled = fetch(sql, params);
        if (!pulled.isOk()) {
            return Result.error(pulled.getMessage());
        }
        List<Map<String, Object>> rows = pulled.getData();
        if (rows.isEmpty()) {
            return Result.ok(null);
        }
        return Result.ok(rows.getFirst());
    }

    public Result<Map<String, Object>> fetchOne(String sql, Map<String, Object> params) {
        Result<List<Map<String, Object>>> pulled = fetch(sql, params);
        if (!pulled.isOk()) {
            return Result.error(pulled.getMessage());
        }
        List<Map<String, Object>> rows = pulled.getData();
        if (rows.isEmpty()) {
            return Result.ok(null);
        }
        return Result.ok(rows.getFirst());
    }

    public Result<Boolean> execute(String sql, Object params) {
        try {
            int result = run.update(sql, new BeanPropertySqlParameterSource(params));
            return Result.ok(result > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error(e.getMessage());
        }
    }

    public Result<Boolean> execute(String sql, Map<String, Object> params) {
        try {
            int result = run.update(sql, params);
            return Result.ok(result > 0);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error(e.getMessage());
        }
    }

    // Opens a new event_register row and returns its id, or null on failure.
    // Domain-leaning for a base repo, but event_register is shared scaffolding
    // every module's records hang off, so it lives here for reuse.
    public Integer createEventId() {
        Result<Map<String, Object>> result = fetchOne(
                "INSERT INTO event_register DEFAULT VALUES RETURNING id", Map.of());
        if (!result.isOk() || result.getData() == null) {
            return null;
        }
        return ((Number) result.getData().get("id")).intValue();
    }
}
