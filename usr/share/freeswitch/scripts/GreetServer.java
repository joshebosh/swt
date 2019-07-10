import java.net.*;
import java.io.*;

public class GreetServer {
	private ServerSocket serverSocket;
	private Socket clientSocket;
	private PrintWriter out;
	private BufferedReader in;

	public void start(int port) {
		serverSocket = new ServerSocket(port);
		clientSocket = serverSocket.accept();
		out = new PrintWriter(clientSocket.getOutputStream(), true);
		in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
		String greeting = in.readLine();
	   
	}

	public void stop() {
		in.close();
		out.close();
		clientSocket.close();
		serverSocket.close();
	}
	public static void main(String[] args) {
		GreetServer server=new GreetServer();
		server.start(8025);
	}
}
