package clientSide.stub;

import clientSide.entities.*;
import commInfra.*;

public class ConcentrationSiteStub {
    /**
	 * Name of the platform where is located the ConcentrationSite server
	 */
	private String serverHostName;
	/**
	 * Port number for listening to service requests
	 */
	private int serverPortNumb;

    /**
     * Instantiation of a concentration site stub.
     * 
     * @param hostName
     *            name of the platform where is located the concentration site
     *            server
     * @param port
     *            port number for listening to service requests
     */
    public ConcentrationSiteStub(String hostName, int port) {
        serverHostName = hostName;
        serverPortNumb = port;
    }

    /**
     * Called by the master thief 
     * Prepare the assault party.
     * @param assaultPartyID
     * @param roomID
     */
    public void prepareAssaultParty(int assaultPartyID, int roomID) {
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_PREPARE_ASSAULT_PARTY, assaultPartyID, ((MasterThief) Thread.currentThread()).getThiefState(), roomID);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // Validate message type and arguments
        if ((inMessage.getMsgType() != MessageType.REP_PREPARE_ASSAULT_PARTY) || (inMessage.getAssaultPartyID() != assaultPartyID)) { //remove ver for assaultPartyID?
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getMasterThiefState() != MasterThiefStates.ASSEMBLING_GROUP){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("MT_STATE:\tExpected: " + MasterThiefStates.ASSEMBLING_GROUP + " Received: " + inMessage.getMasterThiefState());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((MasterThief) Thread.currentThread()).setThiefState(inMessage.getMasterThiefState());

        com.close();
    }

    /**
     * Called by thief
     * Prepares excursion (thief joins the assault party).
     * @return assault party ID
     */
    public int prepareExcursion(){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_PREPARE_EXCURSION, ((NormalThief) Thread.currentThread()).getThiefId(), ((NormalThief) Thread.currentThread()).getThiefState());
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // Validate message type and arguments
        if (inMessage.getMsgType() != MessageType.REP_PREPARE_EXCURSION) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("THIEF_ID:\tExpected: " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefState() != NormalThiefStates.CRAWLING_INWARDS){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("THIEF_STATE:\tExpected: " + NormalThiefStates.CRAWLING_INWARDS + " Received: " + inMessage.getNormalThiefState());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((NormalThief) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());

        com.close();

        return inMessage.getAssaultPartyID();
    }

    /**
     * Called by thief
     * Thief waits until is needed by the master thief.
     * @return true if thief is needed, false otherwise
     */
    public boolean amINeeded(){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread ().sleep ((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_AM_I_NEEDED, ((NormalThief) Thread.currentThread()).getThiefId(), ((NormalThief) Thread.currentThread()).getThiefState());
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // Validate message type and arguments
        if (inMessage.getMsgType() != MessageType.REP_AM_I_NEEDED) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("THIEF_ID:\tExpected: " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefState() != NormalThiefStates.CONCENTRATION_SITE){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("THIEF_STATE:\tExpected: " + NormalThiefStates.CONCENTRATION_SITE + " Received: " + inMessage.getNormalThiefState());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((NormalThief) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());

        com.close();

        return inMessage.getThiefIsNeeded();
    }

    /**
     * Called by master thief
     * Presents the results
     * @param collectedCanvas number of canvas collected
     */
    public void sumUpResults(int collectedCanvas) {
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_SUM_UP_RESULTS, collectedCanvas, ((MasterThief) Thread.currentThread()).getThiefState());
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // Validate message type and arguments
        if ((inMessage.getMsgType() != MessageType.REP_SUM_UP_RESULTS)) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getMasterThiefState() != MasterThiefStates.PRESENTING_THE_REPORT){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("MT_STATE:\tExpected: " + MasterThiefStates.PRESENTING_THE_REPORT + " Received: " + inMessage.getMasterThiefState());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((MasterThief) Thread.currentThread()).setThiefState(inMessage.getMasterThiefState());

        com.close();
    }

    /**
	 * Operation server shutdown
	 */
    public void shutdown(){
		ClientCom com;					//Client communication
		Message outMessage, inMessage; 	//outGoing and inGoing messages

		com = new ClientCom (serverHostName, serverPortNumb);
		//Wait for a connection to be established
		while(!com.open())
		{	try 
		  	{ Thread.currentThread ().sleep ((long) (10));
		  	}
			catch (InterruptedException e) {}
		}
		
		outMessage = new Message (MessageType.REQ_SHUTDOWN_CONCENTRATION_SITE);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SHUTDOWN_CONCENTRATION_SITE)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		
		//Close communication channel
		com.close ();
	}

}
