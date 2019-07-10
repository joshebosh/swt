import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.lang.ClassNotFoundException;
import java.net.ServerSocket;
import java.net.Socket;
import org.freeswitch.esl.*;

/**
 * This class implements java Socket server
 * @author pankaj
 *
 */
public class SocketServerExample {

	//static ServerSocket variable
	private static ServerSocket server;
	//socket server port on which it will listen
	private static int port = 8025;

	public static void main(String args[]) throws IOException, ClassNotFoundException{
		//create the socket server object
		server = new ServerSocket(port);
		//keep listens indefinitely until receives 'exit' call or program terminates
		while(true){
			System.out.println("Waiting for client request");
			//creating socket and waiting for client connection
			Socket socket = server.accept();
		   
			
			//ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
			//oos.writeObject("api log crit this works here");

			//read from socket to ObjectInputStream object
			ObjectInputStream ois = new ObjectInputStream(socket.getInputStream());
			//convert ObjectInputStream object to String
			String message = (String) ois.readObject();
			System.out.println("Message Received: " + message);
			//create ObjectOutputStream object

			//ObjectOutputStream oos = new ObjectOutputStream(socket.getOutputStream());
			//write object to Socket

			oos.writeObject("Hi Client "+message);
			//close resources
			ois.close();
			oos.close();
			socket.close();
			//terminate the server if client sends exit request
			if(message.equalsIgnoreCase("exit")) break;
		}
		System.out.println("Shutting down Socket server!!");
		//close the ServerSocket object
		server.close();
	}

}
