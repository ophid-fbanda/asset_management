package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

@Repository
public class MetaRepository {

    private static final Pattern IDENTIFIER = Pattern.compile("^[a-z][a-z0-9_]*$");

    @Autowired
    private BaseRepo base;

    public boolean isValidIdentifier(String name) {
        return name != null && IDENTIFIER.matcher(name).matches();
    }

    public Result<List<Map<String, Object>>> selectAll(String table) {
        return base.fetch("SELECT * FROM " + table, Map.of());
    }

    public Result<List<Map<String, Object>>> selectColumn(String table, String column) {
        return base.fetch("SELECT " + column + " FROM " + table, Map.of());
    }

    public Result<List<Map<String, Object>>> selectByColumnValue(String table, String column, String value) {
        return base.fetch(
                "SELECT * FROM " + table + " WHERE " + column + " = :value",
                Map.of("value", value)
        );
    }
}
