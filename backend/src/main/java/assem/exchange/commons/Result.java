package assem.exchange.commons;

import lombok.Data;

@Data
public class Result<T> {
    private T data;
    private String message;
    private boolean ok;

    public static <T> Result<T> ok(T data) {
        Result<T> result = new Result<>();
        result.setData(data);
        result.setMessage("OK");
        result.setOk(true);
        return result;
    }

    public static <T> Result<T> error(String message) {
        Result<T> result = new Result<>();
        result.setMessage(message);
        result.setOk(false);
        return result;
    }

    public boolean has(String substring) {
        return this.message.contains(substring);
    }

    public void debug() {
        System.out.println("Result: " + this);
    }
}
