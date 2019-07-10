import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.channels.ServerSocketChannel;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.util.HashMap;
import java.util.Iterator;

public class EsoServer implements Runnable {
	private InetSocketAddress isa;
	 private ServerSocketChannel serverChannel;
	  private Selector selector;
	  private EsoWorker[] workers;
	  private HashMap<Attachment, EsoWorker> workerMap;
	  private long minTimeTaken = 100, maxTimeTaken = 0, totalTimeTaken = 0;
	  private long readminTimeTaken = 100, readmaxTimeTaken = 0, readtotalTimeTaken = 0;
	  private int readMin, readMax;
	  private ByteBuffer readBuffer = ByteBuffer.allocate(10240);
	public static void main(String[] args) throws Exception {
		EsoServer objServer = new EsoServer();
		objServer.init(args);
		objServer.start();
	}
	public void init(String[] args) throws Exception {
		try {
			this.isa = new InetSocketAddress("127.0.0.1",
	                Integer.parseInt("8084"));
				this.workers = new EsoWorker[1];
				 for (int i = 0; i < workers.length; i++) {
		                workers[i] = new EsoWorker();
		          }

				this.workerMap = new HashMap<Attachment, EsoWorker>();
				 this.workerMap = new HashMap<Attachment, EsoWorker>();
				 this.selector = Selector.open();
				 this.serverChannel = ServerSocketChannel.open();
				 this.serverChannel.configureBlocking(false);
				 this.serverChannel.register(this.selector, SelectionKey.OP_ACCEPT);
		}catch(Exception e) {
			System.out.println(e);
		}

	}
	public void start() {
		try {
			System.out.println("Started at :" + this.isa.toString());
			Thread selectorThread = new Thread(this);
			selectorThread.setName("Selector");
	          selectorThread.setPriority(Thread.MAX_PRIORITY);
	          serverChannel.socket().bind(isa, 1024);
	          selectorThread.start();
	          
	          for (int i = 0; i < workers.length; i++) {
	                Thread worker = new Thread(workers[i]);
	                worker.setName("Worker-" + i);
	                worker.start();
	          }

		} catch (Exception e) {
	          System.out.println( e);
	        }

	}
	 public void run() {
	        int loopcnt = 0;
	        int readcnt = 0;
	        String handshake = "connect\n\n";
	        ByteBuffer handshakeBuf = ByteBuffer.allocate(handshake.length());
	        handshakeBuf.clear();
	        handshakeBuf.put(handshake.getBytes());
	        handshakeBuf.flip();
	        int workerIndex = 0;
	        long requestId = 0;
	        while (true) {
	          try {
	                long start = System.currentTimeMillis();
	                this.selector.select();
	                long timeTaken = System.currentTimeMillis() - start;
	                if (timeTaken > maxTimeTaken) {
	                  maxTimeTaken = timeTaken;
	                } else if (timeTaken < minTimeTaken) {
	                  minTimeTaken = timeTaken;
	                }
	                totalTimeTaken += timeTaken;
	                Iterator<SelectionKey> selectedKeys = this.selector.selectedKeys().iterator();
	                while (selectedKeys.hasNext()) {
	                  SelectionKey key = selectedKeys.next();
	                  selectedKeys.remove();
	                  if (!key.isValid()) {
	                        continue;
	                  }
	                  if (key.isAcceptable()) {
	                        SocketChannel sockChannel = ((ServerSocketChannel) key.channel()).accept();
	                        sockChannel.configureBlocking(false);
	                        Attachment att = new Attachment(requestId++, sockChannel.getRemoteAddress().toString());
	                        sockChannel.register(this.selector, SelectionKey.OP_READ, att);

	                        while (handshakeBuf.hasRemaining()) {
	                          sockChannel.write(handshakeBuf);
	                        }
	                        handshakeBuf.rewind();
	                        workerMap.put(att, workers[workerIndex++]);
	                        if (workerIndex == workers.length)
	                          workerIndex = 0;
	                        System.out.println(att.requestId + " New request from... " + att.remoteAddr);
	                  } else if (key.isReadable()) {
	                	  
	                        long readstart = System.currentTimeMillis();
	                        int noRead = this.read(key);
	                        long readtimeTaken = System.currentTimeMillis() - readstart;
	                        if (readtimeTaken > readmaxTimeTaken) {
	                          readmaxTimeTaken = readtimeTaken;
	                          readMax = noRead;
	                        } else if (readtimeTaken < readminTimeTaken) {
	                          readminTimeTaken = readtimeTaken;
	                          readMin = noRead;
	                        }
	                        readtotalTimeTaken += readtimeTaken;
	                        readcnt++;
	                  } else if (key.isWritable()) {
	                        this.write(key);
	                  }
	                }
	          } catch (Exception e) {
	                
	          }
	          loopcnt++;
	          if (loopcnt == 100) {
	        	  System.out.println(
	                        "minTimeTaken:" + minTimeTaken + ", maxTimeTaken:" + maxTimeTaken + ", totalTimeTaken:" + totalTimeTaken);
	                minTimeTaken = 100;
	                maxTimeTaken = 0;
	                totalTimeTaken = 0;
	                loopcnt = 0;

	                System.out.println("read minTime:" + readminTimeTaken + ", Min:" + readMin + ", maxTimeTaken:" + readmaxTimeTaken
	                        + ",Max:" + readMax + ", totalTimeTaken:" + readtotalTimeTaken + ", readcnt:" + readcnt);
	                readminTimeTaken = 100;
	                readmaxTimeTaken = 0;
	                readtotalTimeTaken = 0;
	                readcnt = 0;
	          }
	        }
	        // logger.fatal("SelectorThread Exited, Please Check Application.");
	  }
	 private void write(SelectionKey key) {
		
	  }

	 private int read(SelectionKey key) throws IOException, InterruptedException {
	        SocketChannel socketChannel = (SocketChannel) key.channel();
	        Attachment att = (Attachment) key.attachment();
	        this.readBuffer.clear();
	        int numRead = 0;
	        try {
	          numRead = socketChannel.read(this.readBuffer);
	        } catch (IOException e) {
	          // The remote forcibly closed the connection, cancel
	          // the selection key and close the channel.
	          workerMap.remove(att);
	          key.cancel();
	          socketChannel.close();
	          System.out.println(att.requestId + " End request from " + att.remoteAddr + " Forcibly due to :");
	          return 0;
	        }

	        if (numRead == -1) {
	          // Remote entity shut the socket down cleanly. Do the
	          // same from our end and cancel the channel.
	          workerMap.remove(att);
	          socketChannel.close();
	          key.cancel();
	          System.out.println(att.requestId + " End request from " + att.remoteAddr + " Gracefully");
	          return 0;
	        }

	        byte[] dataCopy = new byte[numRead];
	        readBuffer.flip();
	        readBuffer.get(dataCopy);
	        att.buffer.put(dataCopy);
	        // att.buffer.add(dataCopy);
	        workerMap.get(att).enQueue(key);
	        return numRead;
	  }

}
