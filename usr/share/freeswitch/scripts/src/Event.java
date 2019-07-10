import java.util.HashMap;

public class Event {
    HashMap<String, String> headers = new HashMap<String, String>();
    String raw_body;
    int colonIndex = 0;
    int contentLength = 0;
    int contentIndex = 0;

    public void addHeader(StringBuilder line) {
        this.headers.put(line.substring(0, this.colonIndex),
                line.substring(this.colonIndex + 1).trim());
        this.colonIndex = 0;
    }

    public void resetEvent() {
        this.headers.clear();
        this.raw_body = null;
        this.colonIndex = 0;
    }

}
