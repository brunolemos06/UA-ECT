package clientSide.stub;

import clientSide.entities.*;
import commInfra.*;
import serverSide.entities.*;

public class GeneralRepoStub {
    /**
     * Name of the plataform where is located the  general repo server
     */
    private String serverHostName;

    /**
	 * Port number for listening to service requests
     */
    private int serverPortNumb;

    /**
     *  Instantiation of a general repo stub.
     *
     *    @param serverHostName name of the platform where is located the general repo server
     *    @param serverPortNumb port number for listening to service requests
     */
    public GeneralRepoStub(String serverHostName, int serverPortNumb) {
		this.serverHostName = serverHostName;
		this.serverPortNumb = serverPortNumb;
    }

    /**
     * Prints the initial header of the log file.
     */
    public void header(){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_HEADER);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_HEADER) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in header()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close(); 
    }

    /**
     * Prints the footer of the log file.
     * @param totalcanvas the number of stolen canvas
     */
    public void finish(int totalcanvas){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_FOOTER, totalcanvas);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_FOOTER) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in finish()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close(); 
    }

    /**
     * Called by normal thief
     * Logs the thief being added to the assault party
     * @param assaultID the id of the assault party
     * @param thiefID id of the added thief
     */
    public void setThiefsInAssault(int assaultID, int thiefID){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_ADDED_THIEVES, thiefID, assaultID);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_ADDED_THIEVES) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in finish()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefID() != ((AssaultPartyClientProxy) Thread.currentThread()).getThiefId()){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
			System.out.println ("THIEF ID:\tExpected : " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

        com.close(); 
    }

    /**
     * Called by normal thief
     * Logs the thief position change on crawl in/out
     * @param elemid the *transformed* id of the thief
     * @param AssaultParty the id of the assault party
     * @param thiefposition the current position of the thief in the crawl in/out
     */
    public synchronized void changeposition(int elemid,int AssaultParty, int thiefposition){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_THIEF_POSITION, elemid, AssaultParty, thiefposition);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_THIEF_POSITION) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in changeposition()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        // if(inMessage.getNormalThiefID() != ((AssaultPartyClientProxy) Thread.currentThread()).getThiefId()){
        //     System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
        //     System.out.println ("THIEF ID:\tExpected : " + ((AssaultPartyClientProxy) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
        //     System.out.println (inMessage.toString ());
        //     System.exit (1);
        // }

        com.close();
    }

    /**
     * Called by master thief
     * Logs the assaultParty target room change
     * @param assID
     * @param targetRoom
     */
    public void settargetRoom(int assID,int targetRoom){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_TARGET_ROOM, targetRoom, assID);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_TARGET_ROOM) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in settargetRoom()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * Called by thief
     * Logs the canvas of the thief
     * @param thiefID
     * @param hasacanvas
     * @param roomid
     * @param assID
     */
    public void changehasacanvas(int thiefID,int hasacanvas,int roomid,int assID){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_THIEF_CANVAS, thiefID, hasacanvas, roomid, assID);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_THIEF_CANVAS) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in changehasacanvas()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * Called by thief
     * Logs the thief state to waiting
     * @param thiefid
     */
    public void thiefStateW(int thiefid){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_THIEF_WAITING, thiefid);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_THIEF_WAITING) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in thiefStateW()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefID() != ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId()){
            System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
            System.out.println ("THIEF ID:\tExpected : " + ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
            System.out.println (inMessage.toString ());
            System.exit (1);
        }

        com.close();
    }

    /**
     * Called by thief
     * Logs the thief state to in party
     * @param thiefid
     */
    public void thiefStateP(int thiefid){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_THIEF_IN_PARTY, thiefid);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_THIEF_IN_PARTY) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in thiefStateP()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
            System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
            System.out.println ("THIEF ID:\tExpected : " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
            System.out.println (inMessage.toString ());
            System.exit (1);
        }

        com.close();
    }

    /**
     * Called by master thief
     * Logs the master thief state 
     * @param state
     */
    public void putMasterState(int state){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_MASTER_THIEF_STATE, state);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_MASTER_THIEF_STATE) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in putMasterState()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * Called by thief
     * @param thiefid
     * @param state
     */
    public synchronized void putThiefState(int state, int thiefid){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while (!com.open()) {
            try {
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e) {
            }
        }

        outMessage = new Message(MessageType.REQ_LOG_THIEF_STATE, thiefid, state);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if (inMessage.getMsgType() != MessageType.REP_LOG_THIEF_STATE) {
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in putThiefState()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        // if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
        //     System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
        //     System.out.println ("THIEF ID:\tExpected : " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
        //     System.out.println (inMessage.toString ());
        //     System.exit (1);
        // }

        com.close();
    }

    /**
     * called by normal thief client
     * @param agility array of thieves agility
     */
    public void setAgility(int[] agility){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while(!com.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_SET_AGILITY, agility);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if(inMessage.getMsgType() != MessageType.REP_SET_AGILITY){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in setAgility()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * called by concentration site server
     * @param distance array of distances to rooms
     */
    public void setRoomsDistance(int[] distance){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while(!com.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_SET_ROOMS_DISTANCE, distance);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if(inMessage.getMsgType() != MessageType.REP_SET_ROOMS_DISTANCE){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in setRoomsDistance()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        com.close();
    }

    /**
     * called by museum server
     * @param paintings array of initial number of paintings
     */
    public void setPaintings(int[] paintings){
        ClientCom com;
        Message inMessage, outMessage;

        com = new ClientCom(serverHostName, serverPortNumb);
        while(!com.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            } catch (InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_SET_PAINTINGS, paintings);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        if(inMessage.getMsgType() != MessageType.REP_SET_PAINTINGS){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Type error in setPaintings()!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

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
		
		outMessage = new Message (MessageType.REQ_SHUTDOWN_LOGGER);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SHUTDOWN_LOGGER)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		
		//Close communication channel
		com.close ();
	}

}
