package assem.utils;

import tools.jackson.core.type.TypeReference;
import tools.jackson.databind.PropertyNamingStrategies;
import tools.jackson.databind.json.JsonMapper;

public class TypeConvertor {

    private final JsonMapper snakeMapper;
    private final JsonMapper jsonMapper;

    private TypeConvertor() {
        snakeMapper = JsonMapper.builder()
                .propertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE)
                .build();
        jsonMapper = JsonMapper.builder().build();
    }

    public static TypeConvertor instance() {
        return new TypeConvertor();
    }

    public <T> T convert(Object obj, Class<T> type) {
        try {
            return snakeMapper.convertValue(obj, type);
        } catch (Exception e) {
            return null;
        }
    }

    public <T> T readJson(String json, Class<T> type) {
        try {
            return jsonMapper.readValue(json, type);
        } catch (Exception e) {
            return null;
        }
    }

    public <T> T readJson(String json, TypeReference<T> type) {
        try {
            return jsonMapper.readValue(json, type);
        } catch (Exception e) {
            return null;
        }
    }
}
