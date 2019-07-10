import java.io.*;
import java.net.*;
public class echo3 {
	public static void main(String args[]) {
		// declaration section:
		// declare a server socket and a client socket for the server
		// declare an input and an output stream
		ServerSocket echoServer = null;
		String line;
		DataOutputStream send;
		DataInputStream dis;
		DataOutputStream dos;
		PrintStream os;
		Socket clientSocket = null;
		// Try to open a server socket on port 9999
		// Note that we can't choose a port less than 1023 if we are not
		// privileged users (root)
		try {
			echoServer = new ServerSocket(8025);
		}
		catch (IOException e) {
			System.out.println(e);
		}
		// Create a socket object from the ServerSocket to listen and accept
		// connections.
		// Open input and output streams
		try {
			clientSocket = echoServer.accept();
			dis = new DataInputStream(clientSocket.getInputStream());
			dos = new PrintStream(clientSocket.getOutputStream());
			os = new PrintStream(clientSocket.getOutputStream());
			// As long as we receive data, echo that data back to the client.
			while (true) {
				send = dos.println("api version");
				line = dis.readLine();
				os.println(line);
			}
		}
		catch (IOException e) {
			System.out.println(e);
		}
	}
}
