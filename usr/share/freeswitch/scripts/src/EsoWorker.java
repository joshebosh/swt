import java.util.LinkedList;
import java.util.concurrent.ArrayBlockingQueue;
import java.nio.ByteBuffer;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.channels.SelectionKey;
import java.nio.channels.SocketChannel;



public class EsoWorker implements Runnable {
	
	public static final String EVENT = "event";
	  public static final String EVENT_NAME = "Event-Name";
	  public static final String CHANNEL_EXECUTE_COMPLETE = "CHANNEL_EXECUTE_COMPLETE";
	  public static final String ANSWER_STATE = "Answer-State";
	  public static final String HANGUP = "hangup";
	  public static final String APPLICATION = "Application";
	  public static final String PLAYBACK = "playback";
	  public static final String SEND_DTMF = "send_dtmf";
	  public static final String PLAY_AND_GET_DIGITS = "play_and_get_digits";
	  public static final String BRIDGE = "bridge";
	  public static final String RECORD = "record";
	  public static final String SPEAK = "speak";
	  public static final String SAY = "say";
	  public static final String SLEEP = "sleep";
	  public static final String CHANNEL_BRIDGE = "CHANNEL_BRIDGE";
	  public static final String CHANNEL_UNBRIDGE = "CHANNEL_UNBRIDGE";
	  public static final String CUSTOM = "CUSTOM";
	  public static final String EVENT_SUBCLASS = "Event-Subclass";
	  public static final String CONFERENCE_MAINTENANCE = "conference::maintenance";
	  public static final String ACTION = "Action";
	  public static final String UTF8 = "UTF-8";
	  public static final String ADD_MEMBER = "add-member";
	  public static final String CONFERENCE_NAME = "Conference-Name";
	  public static final String MEMEBER_ID = "Member-ID";
	  public static final String DIGITSMATCH = "digitsMatch";
	  public static final String CALLBACKURL = "callbackUrl";
	  public static final String DEL_MEMBER = "del-member";
	  public static final String TRANSFER = "transfer";
	  public static final String DIGITS_MATCH = "digits-match";
	  public static final String START_TALKING = "start-talking";
	  public static final String STOP_TALKING = "stop-talking";
	  public static final String CALLSTATUS = "callstatus";
	  public static final String COMPLETED = "completed";
	  public static final String INPROGRESS = "inprogress";
	

	
	 private LinkedList<SelectionKey> queue = new LinkedList<SelectionKey>();
	 private long minTimeTaken = 100, maxTimeTaken = 0, totalTimeTaken = 0;
	  private long pminTimeTaken = 100, pmaxTimeTaken = 0, ptotalTimeTaken = 0;

	 public static final String hangupStr = "sendmsg \ncall-command: execute\nexecute-app-name: hangup\nevent-lock: true\ncontent-type: text/plain\ncontent-length: 15\n\nNORMAL_CLEARING\n";
	 public void enQueue(SelectionKey key) {
	        synchronized (queue) {
	          queue.add(key);
	          queue.notify();
	        }
	  }
	public void run() {
		int loopcnt = 0;
        SelectionKey selKey;
        byte[] chunk = null;
        while (true) {
        	long start = System.currentTimeMillis();
        	 synchronized (queue) {
                 while (queue.isEmpty()) {
                   try {
                         queue.wait();
                   } catch (InterruptedException e) {
                   }
                 }
                 selKey = queue.remove(0);
           }
        	 long timeTaken = System.currentTimeMillis() - start;
             if (timeTaken > maxTimeTaken) {
                   maxTimeTaken = timeTaken;
             } else if (timeTaken < minTimeTaken) {
                   minTimeTaken = timeTaken;
             }
             totalTimeTaken += timeTaken;

             Attachment attachment = (Attachment) selKey.attachment();
             SocketChannel channel = (SocketChannel) selKey.channel();
             ArrayBlockingQueue<byte[]> buffer = attachment.buffer;
             StringBuilder line = attachment.line;
             Event event = attachment.event;
             chunk = buffer.poll();
             if (chunk == null)
                   continue;
             int i = 0;
             if (event.contentIndex < event.contentLength) {
                 if (event.headers.get("Content-Type").equals("text/event-plain")) {
                   for (; i < chunk.length && event.contentIndex < event.contentLength; event.contentIndex++, i++) {
                         if (chunk[i] != 10) {
                           if (chunk[i] == 58)
                                 event.colonIndex = line.length();
                           line.append((char) chunk[i]);
                         } else if (line.length() != 0) {
                           event.addHeader(line);
                           line.delete(0, line.length());
                         }
                   }
                   if (event.contentIndex < event.contentLength) {
                         continue;
                   }
                 } else {
                   for (; i < chunk.length && event.contentIndex < event.contentLength; event.contentIndex++, i++) {
                         line.append((char) chunk[i]);
                   }
                   if (event.contentIndex < event.contentLength) {
                         continue;
                   }
                   event.raw_body = line.toString();
                 }
                 doCallback(event, chunk, attachment, channel);
                 event.resetEvent();
                 line.delete(0, line.length());
           }
             for (; i < chunk.length; i++) {
                 if (chunk[i] != 10) {
                   if (chunk[i] == 58)
                         event.colonIndex = line.length();
                   line.append((char) chunk[i]);
                 } else if (line.length() == 0) {
                   if (event.headers.containsKey("Content-Length")) {
                         event.contentLength = Integer.parseInt(event.headers.get("Content-Length"));
                         event.contentIndex = 0;
                         i++;
                         if (event.headers.get("Content-Type").equals("text/event-plain")) {
                           for (; i < chunk.length && event.contentIndex < event.contentLength; event.contentIndex++, i++) {
                                 if (chunk[i] != 10) {
                                   if (chunk[i] == 58)
                                         event.colonIndex = line.length();
                                   line.append((char) chunk[i]);
                                 } else if (line.length() != 0) {
                                   event.addHeader(line);
                                   line.delete(0, line.length());
                                 }
                           }
                           if (event.contentIndex < event.contentLength) {
                                 break;
                           } else {
                                 i--;
                           }
                         } else {
                           for (; i < chunk.length && event.contentIndex < event.contentLength; event.contentIndex++, i++) {
                                 line.append((char) chunk[i]);
                           }
                           if (event.contentIndex < event.contentLength) {
                                 break;
                           } else {
                                 i--;
                           }
                           event.raw_body = line.toString();
                         }
                   }
                   doCallback(event, chunk, attachment, channel);
                   event.resetEvent();
                   line.delete(0, line.length());
                 } else {
                   event.addHeader(line);
                   line.delete(0, line.length());
                 }
           }
             loopcnt++;
             long ptimeTaken = System.currentTimeMillis() - (start + timeTaken);
             if (ptimeTaken > pmaxTimeTaken) {
                   pmaxTimeTaken = ptimeTaken;
             } else if (ptimeTaken < pminTimeTaken) {
                   pminTimeTaken = ptimeTaken;
             }
             ptotalTimeTaken += ptimeTaken;
             if (loopcnt == 100) {
                   System.out.println(attachment.requestId + " Wqueue minTime:" + minTimeTaken + ", maxTime:" + maxTimeTaken
                           + ", totalTime:" + totalTimeTaken);
                   minTimeTaken = 100;
                   maxTimeTaken = 0;
                   totalTimeTaken = 0;
                   loopcnt = 0;
                   System.out.println(attachment.requestId + " Wprocess  minTime:" + pminTimeTaken + ", maxTime:" + pmaxTimeTaken
                           + ", totalTime:" + ptotalTimeTaken);
                   pminTimeTaken = 100;
                   pmaxTimeTaken = 0;
                   ptotalTimeTaken = 0;
             }
        }
	}
	 private void doCallback(Event event, byte[] chunk, Attachment attachment, SocketChannel channel) {
	        try {

	          switch (event.headers.get("Content-Type")) {
	          case "command/reply":
	                if (attachment.commandIndex != 1) {
	                  for (String key : event.headers.keySet()) {
	                	  System.out.println(attachment.requestId + " " + key + ":" + event.headers.get(key));
	                  }
	                }
	                if (!attachment.hasDisconnectNotice)
	                  doCommandReply(event, chunk, attachment, channel);
	                break;
	          case "api/response":
	                  for (String key : event.headers.keySet()) {
	                	  System.out.println(attachment.requestId + " " + key + ":" + event.headers.get(key));
	                  }
	                  System.out.println(attachment.requestId + " " + event.raw_body);
	                break;
	          case "text/disconnect-notice":
	                attachment.hasDisconnectNotice = true;
	                
	                break;
	          case "text/event-plain":
	                	System.out.println(attachment.requestId + " Event-Subclass : " + event.headers.get(EVENT_SUBCLASS) + " ,Event-Name:"
	                          + event.headers.get(EVENT_NAME) + " ; Application:" + event.headers.get(APPLICATION)
	                          + ",Application-Response:" + event.headers.get("Application-Response") + ",Answer-State:"
	                          + event.headers.get(ANSWER_STATE) + ",sip_hangup_disposition:"
	                          + event.headers.get("variable_sip_hangup_disposition") + ",Action:" + event.headers.get(ACTION));
	                if (event.headers.containsKey(EVENT_NAME))
	                  doEventPlain(event, chunk, attachment, channel);
	                
	                System.out.println(attachment.requestId + "Event ignored...below are content");
	                 /* for (String key : event.headers.keySet()) {
	                	  System.out.println(attachment.requestId + " " + key + ":" + event.headers.get(key));
	                  }*/
	                
	                break;
	          case "text/event-json":
	                break;
	          }
	        } catch (Exception e) {
	        	System.out.println("error 1 ");
	        	System.out.println(e.getMessage());
	        	 e.printStackTrace();
	            writeToChannel(new StringBuilder(hangupStr), attachment, channel);
	          attachment.hasDisconnectNotice = true;
	        }
	  }
	 public void doCommandReply(Event event, byte[] chunk, Attachment attachment, SocketChannel channel) {
	        StringBuilder writeData = new StringBuilder();
	        switch (attachment.commandIndex++) {
	        case 1:
				initCall(attachment, event, channel);
	          break;
	        case 2:
	          writeData.append("linger \n\n");
	          break;
	        case 3:
	          writeData.append("myevents \n\n");
	          break;
	        case 4:
	          writeData.append("divert_events on\n\n");
	          break;
	        case 5:
	          writeData.append("filter Event-Name CHANNEL_EXECUTE_COMPLETE\n\n");
	          break;
	        case 6:
              writeData.append("filter Event-Name CHANNEL_ANSWER\n\n");
              break;
	        case 7:
	        	if(!attachment.hasAnswered) {
	   			 writeData.append("sendmsg \ncall-command: execute\nexecute-app-name: answer\nevent-lock: true\ncontent-type: text/plain\ncontent-length: 0\n\n\n");
	   		 	}else {
	   		 		
	   		 	}
	          break;
	        }
	        writeToChannel(writeData, attachment, channel);
	  }
	 public void doEventPlain(Event event, byte[] chunk, Attachment attachment, SocketChannel channel)
	          throws UnsupportedEncodingException {
		 StringBuilder writeData = new StringBuilder();
		 try {
	          if (event.headers.containsKey(EVENT)) {
	        	  System.out.println(java.net.URLDecoder.decode(event.headers.get(EVENT), UTF8));
	                String[] bdaValues = java.net.URLDecoder.decode(event.headers.get(EVENT), UTF8).split(",");
	                for (String value : bdaValues) {
	                  int equalIndex = value.indexOf("=");
	                  event.headers.put(value.substring(0, equalIndex), value.substring(equalIndex + 1).trim());
	                }
	          } else if (!event.headers.containsKey(EVENT_NAME)) {
	                return;
	          }
	          attachment.hasDisconnectNotice = attachment.hasDisconnectNotice ? true
	                  : (event.headers.containsKey(ANSWER_STATE) ? event.headers.get(ANSWER_STATE).equals(HANGUP) : false);
	        } catch (Exception ex) {
	        	System.out.println("Error in doEventPlain"+ ex);
	          for (String key : event.headers.keySet()) {
	                System.out.println(key + ":" + event.headers.get(key));
	          }
	        }
		 if (event.headers.get(EVENT_NAME).equals(CHANNEL_EXECUTE_COMPLETE)) {
			 if (attachment.isInbound && event.headers.get(APPLICATION).equals("answer")) {
					System.out.println(attachment.requestId + " Inbound Call (From:" + event.headers.get("Caller-Caller-ID-Number")
						+ ",To:" + event.headers.get("Caller-Destination-Number") + ") has Answered..");
					
					// what ever DP tool you want to execute, execute here .... 
					StringBuilder playbackArg = new StringBuilder();
					playbackArg.append("/usr/src/master/freeswitch/html5/verto/video_demo-live_canvas/sounds/bell_ring2.wav");
					writeData.append("sendmsg \ncall-command: execute\n");
					writeData.append("execute-app-name: playback\nevent-lock: true\ncontent-type: text/plain\ncontent-length: ");
					writeData.append(playbackArg.length());
					writeData.append("\n\n");
					writeData.append(playbackArg);
					writeData.append("\n");
					writeToChannel(writeData, attachment, channel);
					
				  }
			 System.out.println("Application----------------> " + event.headers.get(APPLICATION));
			 switch (event.headers.get(APPLICATION)) {
			 case PLAYBACK:
				 System.out.println(attachment.requestId + " Play Finished Response:" + event.headers.get("Application-Response")
				  + " playback_ms:" + event.headers.get("variable_playback_ms"));
				 //After playing File i am executing Hangup command to end the call.. 
				 writeToChannel(new StringBuilder(hangupStr), attachment, channel);
				 return;
			 case PLAY_AND_GET_DIGITS:
				  String pagdInput = event.headers.get("variable_pagd_input");
				  if (pagdInput != null) {
					  System.out.println(attachment.requestId + " GetDigits, Digits  Received : " + pagdInput);
					return;
				  }
				  System.out.println(attachment.requestId + " GetDigits Finished No Digits Received");
				  break;			 
			 }
		 }
	 }
	 private void initCall(Attachment attachment, Event event, SocketChannel channel) {
		 attachment.uniqueId = event.headers.get("Unique-ID");
		 if (event.headers.get("Call-Direction").toLowerCase().equals("inbound")) {
	          attachment.isInbound = true;
	          attachment.hasAnswered = false;
	          attachment.origCallerIdNo = event.headers.get("Caller-Destination-Number");
	          writeToChannel(new StringBuilder("resume \n\n"), attachment, channel);
	          
		 }else {
			 attachment.origCallerIdNo = event.headers.get("Caller-Callee-ID-Number");
			 if (event.headers.get("Answer-State").equals("ringing") || event.headers.get("Answer-State").equals("early")) {

	                attachment.hasAnswered = false;
	                writeToChannel(new StringBuilder("resume \n\n"), attachment, channel);
	                return;
			 } else {
	                attachment.hasAnswered = true;
	          }
		 }
	 }
	 public void writeToChannel(StringBuilder writeData, Attachment attachment, SocketChannel channel) {
	        if (writeData.length() > 0) {
	          
	                System.out.println(attachment.requestId + " Writing data : " + writeData);
	          ByteBuffer buf = ByteBuffer.allocate(writeData.length());
	          buf.put(writeData.toString().getBytes());
	          buf.flip();
	          try {
	                while (channel.isConnected() && buf.hasRemaining()) {
	                  channel.write(buf);
	                }
	          } catch (IOException e) {
	        	  System.out.println(attachment.requestId + " Error while writing data:" + writeData.toString() + " to "
	                        + attachment.remoteAddr + " is->" + e.toString());
	          }
	        }
	  }
	

}
