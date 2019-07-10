
import org.freeswitch.esl.*;


public class FsOutbound {
	public static void main(String [] args) {                                                                                                                   
		/* Once you get libesljni.so compiled you can either put it in your java library path and                                                               
		 * use System.loadlibrary or just use System.load with the absolute path.*/                                                                                                                                                     
		   
		/* Trying to keep this simple (and I'm no java expert) I am instantiating the ESLconnection and                                                         
		 * ESLevent object in a static reference here so remember if you don't plan on doing everything in main                                                 
		 * you will need to instantiate your class first or you will get compile-time errors. */                                                                                                                                                     
		ESLconnection con = new ESLconnection("127.0.0.1","8021","ClueCon");                                                                                    
		ESLevent evt;                                                                                                                                           
		if (con.connected() == 1) System.out.println("connected");                                                                                              
		con.events("plain","all");                                                                                                                              
		// Loop while connected to the socket -- not sure if this method is constantly updated so may not be a good test                                        
		while (con.connected() == 1) {                                                                                                                          
			// Get an event - recvEvent will block if nothing is queued                                                                                         
			evt = con.recvEvent();                                                                                                                              
			// Print the entire event in key : value format. serialize() according to the wiki usually takes no arguments                                       
			// but if you do not put in something you will not get any output so I just stuck plain in.                                                         
			System.out.println(evt.serialize("plain"));                                                                                                           
		}                                                                                                                                                       
	}                                  
}
