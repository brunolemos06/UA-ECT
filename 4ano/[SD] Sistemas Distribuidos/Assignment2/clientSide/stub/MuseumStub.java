package clientSide.stub;

import clientSide.entities.*;
import commInfra.*;

public class MuseumStub {
    /**
     * Name of the platform where is located the Museum server
     */
    private String serverHostName;

    /**
     * Port number for listening to service requests
     */
    private int serverPortNumb;

    /**
     * Instantiation of a museum stub.
     * 
     * @param hostName
     *            name of the platform where is located the museum server
     * @param port
     *            port number for listening to service requests
     */
    public MuseumStub(String hostName, int port) {
        serverHostName = hostName;
        serverPortNumb = port;
    }

    /**
     * Called by the thief
     * Thief rolls a canvas
     * @param assaultPartyID
     * @return true if thief stole a canvas and false otherwise
     */
    public boolean rollACanvas(int assaultPartyID) {
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_ROLL_A_CANVAS, ((NormalThief) Thread.currentThread()).getThiefId(), assaultPartyID);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // Validate message type and arguments
        if ((inMessage.getMsgType() != MessageType.REP_ROLL_A_CANVAS)) { //remove ver for assaultPartyID?
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

        com.close();

        return inMessage.getThiefHasCanvas();
    }

    /**
	 * Operation server shutdown
	 */
    public void shutdown(){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_SHUTDOWN_MUSEUM);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        // Validate message type and arguments
        if ((inMessage.getMsgType() != MessageType.REP_SHUTDOWN_MUSEUM)) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }
}
