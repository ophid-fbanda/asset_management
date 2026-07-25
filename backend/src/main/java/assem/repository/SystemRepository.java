package assem.repository;

import assem.exchange.commons.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Repository
public class SystemRepository {

    public static final class FieldDef {
        public final String name;
        public final String label;
        public final String type;       // text | number | lookup
        public final String lookup;     // meta table for lookup fields
        public final String optionLabel;

        FieldDef(String name, String label, String type) {
            this(name, label, type, null, null);
        }

        FieldDef(String name, String label, String type, String lookup, String optionLabel) {
            this.name = name;
            this.label = label;
            this.type = type;
            this.lookup = lookup;
            this.optionLabel = optionLabel;
        }

        Map<String, Object> asMap() {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("name", name);
            map.put("label", label);
            map.put("type", type);
            if (lookup != null) {
                map.put("lookup", lookup);
                map.put("optionLabel", optionLabel);
            }
            return map;
        }
    }

    public static final class LookupDef {
        public final String key;
        public final String label;
        public final boolean manualId;
        public final List<FieldDef> fields;

        LookupDef(String key, String label, boolean manualId, List<FieldDef> fields) {
            this.key = key;
            this.label = label;
            this.manualId = manualId;
            this.fields = fields;
        }

        Map<String, Object> asMap() {
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("key", key);
            map.put("label", label);
            map.put("manualId", manualId);
            map.put("fields", fields.stream().map(FieldDef::asMap).collect(Collectors.toList()));
            return map;
        }

        Set<String> fieldNames() {
            return fields.stream().map(f -> f.name).collect(Collectors.toSet());
        }
    }

    private static final List<LookupDef> CATALOG = List.of(
            new LookupDef("stations", "Stations", false, List.of(
                    new FieldDef("station_code", "Station code", "text"),
                    new FieldDef("station_name", "Station name", "text"),
                    new FieldDef("latitude", "Latitude", "number"),
                    new FieldDef("longitude", "Longitude", "number")
            )),
            new LookupDef("condition_types", "Asset conditions", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("evaluation_types", "Evaluation types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("role_types", "Role types", true, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("asset_types", "Asset types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("brand_types", "Brand names", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("model_types", "Model names", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("asset_brands", "Asset brands", false, List.of(
                    new FieldDef("asset_type_id", "Asset type", "lookup", "asset_types", "name"),
                    new FieldDef("brand_type_id", "Brand", "lookup", "brand_types", "name")
            )),
            new LookupDef("asset_models", "Asset models", false, List.of(
                    new FieldDef("asset_brand_id", "Asset brand", "lookup", "asset_brands", "label"),
                    new FieldDef("model_type_id", "Model", "lookup", "model_types", "name")
            )),
            new LookupDef("incident_types", "Incident types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("disposal_types", "Disposal types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("verification_types", "Verification types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("issuance_types", "Issuance types", true, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("placement_types", "Placement types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("acquisition_types", "Acquisition types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("reference_types", "Reference types", false, List.of(
                    new FieldDef("name", "Name", "text")
            )),
            new LookupDef("programs", "Programs", false, List.of(
                    new FieldDef("program_code", "Program code", "text"),
                    new FieldDef("program_name", "Program name", "text")
            )),
            new LookupDef("suppliers", "Suppliers", false, List.of(
                    new FieldDef("supplier_name", "Supplier name", "text")
            ))
    );

    private static final Map<String, LookupDef> BY_KEY = CATALOG.stream()
            .collect(Collectors.toMap(d -> d.key, d -> d, (a, b) -> a, LinkedHashMap::new));

    @Autowired
    private BaseRepo base;

    public List<Map<String, Object>> catalog() {
        return CATALOG.stream().map(LookupDef::asMap).collect(Collectors.toList());
    }

    public LookupDef require(String table) {
        return BY_KEY.get(table);
    }

    public Result<List<Map<String, Object>>> list(String table) {
        LookupDef def = require(table);
        if (def == null) return Result.error("Unknown lookup: " + table);

        // Junction lookups are all *_id columns — join labels so the table has visible fields
        // (objectHeaders hides id / *_id on the frontend).
        if ("asset_brands".equals(table)) {
            return base.fetch("""
                    SELECT asset_brands.id,
                           asset_brands.asset_type_id,
                           asset_types.name AS asset_type,
                           asset_brands.brand_type_id,
                           brand_types.name AS brand
                    FROM asset_brands
                    JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                    JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                    ORDER BY asset_types.name, brand_types.name
                    """, Map.of());
        }
        if ("asset_models".equals(table)) {
            return base.fetch("""
                    SELECT asset_models.id,
                           asset_models.asset_brand_id,
                           (asset_types.name || ' / ' || brand_types.name) AS asset_brand,
                           asset_models.model_type_id,
                           model_types.name AS model
                    FROM asset_models
                    JOIN asset_brands ON asset_brands.id = asset_models.asset_brand_id
                    JOIN asset_types ON asset_types.id = asset_brands.asset_type_id
                    JOIN brand_types ON brand_types.id = asset_brands.brand_type_id
                    JOIN model_types ON model_types.id = asset_models.model_type_id
                    ORDER BY asset_types.name, brand_types.name, model_types.name
                    """, Map.of());
        }

        return base.fetch("SELECT * FROM " + table + " ORDER BY id", Map.of());
    }

    public Result<Boolean> create(String table, Map<String, Object> body) {
        LookupDef def = require(table);
        if (def == null) return Result.error("Unknown lookup: " + table);

        Map<String, Object> params = sanitize(def, body, false);
        if (params == null) return Result.error("Invalid lookup fields.");

        if (def.manualId) {
            Object id = body.get("id");
            if (!(id instanceof Number) || ((Number) id).intValue() <= 0) {
                return Result.error("Id is required for this lookup.");
            }
            params.put("id", ((Number) id).intValue());
        }

        List<String> cols = new ArrayList<>(params.keySet());
        String columnSql = String.join(", ", cols);
        String valueSql = cols.stream().map(c -> ":" + c).collect(Collectors.joining(", "));
        Result<Boolean> result = base.execute(
                "INSERT INTO " + table + " (" + columnSql + ") VALUES (" + valueSql + ")",
                params
        );
        return softenDbError(result, "create");
    }

    public Result<Boolean> update(String table, Map<String, Object> body) {
        LookupDef def = require(table);
        if (def == null) return Result.error("Unknown lookup: " + table);

        Object id = body.get("id");
        if (!(id instanceof Number) || ((Number) id).intValue() <= 0) {
            return Result.error("Id is required.");
        }

        Map<String, Object> params = sanitize(def, body, true);
        if (params == null || params.isEmpty()) return Result.error("Invalid lookup fields.");
        params.put("id", ((Number) id).intValue());

        String sets = params.keySet().stream()
                .filter(k -> !"id".equals(k))
                .map(k -> k + " = :" + k)
                .collect(Collectors.joining(", "));
        if (sets.isBlank()) return Result.error("Nothing to update.");

        Result<Boolean> result = base.execute(
                "UPDATE " + table + " SET " + sets + " WHERE " + table + ".id = :id",
                params
        );
        return softenDbError(result, "update");
    }

    public Result<Boolean> delete(String table, int id) {
        LookupDef def = require(table);
        if (def == null) return Result.error("Unknown lookup: " + table);
        if ("role_types".equals(table) && id == 10) {
            return Result.error("General User role type cannot be deleted.");
        }
        Result<Boolean> result = base.execute(
                "DELETE FROM " + table + " WHERE " + table + ".id = :id",
                Map.of("id", id)
        );
        return softenDbError(result, "delete");
    }

    // Never surface JDBC/Postgres text to the UI — map common failures to plain language.
    private Result<Boolean> softenDbError(Result<Boolean> result, String action) {
        if (result == null) return Result.error("Could not " + action + " that lookup.");
        if (result.isOk()) return result;

        String raw = result.getMessage() != null ? result.getMessage().toLowerCase() : "";
        if (raw.contains("duplicate key") || raw.contains("unique constraint")) {
            return Result.error("That lookup entry already exists.");
        }
        if (raw.contains("foreign key") || raw.contains("violates foreign key")) {
            if ("delete".equals(action)) {
                return Result.error("That lookup is in use and cannot be deleted.");
            }
            return Result.error("One of the selected references is invalid.");
        }
        if (raw.contains("not-null") || raw.contains("null value")) {
            return Result.error("Complete all required fields.");
        }
        return Result.error("Could not " + action + " that lookup.");
    }

    private Map<String, Object> sanitize(LookupDef def, Map<String, Object> body, boolean forUpdate) {
        if (body == null) return null;
        Map<String, Object> params = new LinkedHashMap<>();
        for (FieldDef field : def.fields) {
            if (!body.containsKey(field.name)) {
                if (forUpdate) continue;
                return null;
            }
            Object value = body.get(field.name);
            if (value == null || (value instanceof String s && s.isBlank())) {
                if ("number".equals(field.type) && ("latitude".equals(field.name) || "longitude".equals(field.name))) {
                    params.put(field.name, null);
                    continue;
                }
                return null;
            }
            if ("number".equals(field.type) || "lookup".equals(field.type)) {
                if (!(value instanceof Number)) {
                    try {
                        params.put(field.name, Double.parseDouble(String.valueOf(value)));
                    } catch (Exception e) {
                        return null;
                    }
                    // FK ids should be ints
                    if ("lookup".equals(field.type)) {
                        params.put(field.name, ((Number) params.get(field.name)).intValue());
                    }
                } else if ("lookup".equals(field.type)) {
                    params.put(field.name, ((Number) value).intValue());
                } else {
                    params.put(field.name, value);
                }
            } else {
                params.put(field.name, String.valueOf(value).trim());
            }
        }
        return params;
    }
}
