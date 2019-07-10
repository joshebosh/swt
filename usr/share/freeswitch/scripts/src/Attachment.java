import java.util.HashMap;
import java.util.concurrent.ArrayBlockingQueue;


public class Attachment {
  public long requestId;
  public int commandIndex;
  public ArrayBlockingQueue<byte[]> buffer;
  public StringBuilder line;
  public Event event;
  public String remoteAddr;
  public HashMap<String, String> sessionParams;
  public boolean isInbound;
  public boolean hasDisconnectNotice;
  public boolean hasAnswered;
  public String uniqueId;
  public String origCallerIdNo;
  public String endBeep_Url;
  public HashMap<String, String> endBeep_Params;
  
public Attachment(long reqId, String rmtaddr) {
        this.requestId = reqId;
        this.remoteAddr = rmtaddr;
        this.commandIndex = 1;
        this.buffer = new ArrayBlockingQueue<byte[]>(10);
        //this.buffer = new ArrayDeque<byte[]>(5);
        this.line = new StringBuilder();
        this.event = new Event();
  }

}
