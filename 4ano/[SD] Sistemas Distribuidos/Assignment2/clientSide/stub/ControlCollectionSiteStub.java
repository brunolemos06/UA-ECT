package clientSide.stub;

import clientSide.entities.*;
import commInfra.*;

public class ControlCollectionSiteStub {
    
    /**
	 * Name of the platform where is located the controlCollectionSite server
	 */
	
     private String serverHostName;
	/**
	 * Port number for listening to service requests
	 */
	private int serverPortNumb;
	
	
	/**
	 * Instantiation of a stub to the Assault Party.
	 * 
	 * @param serverHostName name of the platform where is located the controlCollectionSite server
	 * @param serverPortNumb port number for listening to service requests
	 */
	public ControlCollectionSiteStub(String serverHostName, int serverPortNumb){
		this.serverHostName = serverHostName;
		this.serverPortNumb = serverPortNumb;
	}

    /**
     * Called by master thief
     * Get the assembling assault party id
     * @return the assembling assault party id
     */
    public int getAssaultPartyID(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_GET_ASSEMBLING_ASSAULT_PARTY_ID);
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_GET_ASSEMBLING_ASSAULT_PARTY_ID){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_GET_ASSEMBLING_ASSAULT_PARTY_ID + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        //assault party id must be between 0 and 1
        if(inMessage.getAssaultPartyID() < 0 || inMessage.getAssaultPartyID() > 1){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid assault party id!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        con.close();
        return inMessage.getAssaultPartyID();
    }

    /**
     * Called by master thief
     * Get a roomID with canvas in it
     * @return the roomID with canvas in it
     */
    public int getRoomWithCanvasID(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_GET_ROOM_WITH_CANVAS);
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_GET_ROOM_WITH_CANVAS){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_GET_ROOM_WITH_CANVAS + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        //room id must be between 0 and 5
        if(inMessage.getRoomID() < 0 || inMessage.getRoomID() > 5){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid room id!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        con.close();
        return inMessage.getRoomID();
    }

    /**
     * Called by master thief
     * Get the total number of stolen canvas
     * @return the total number of stolen canvas
     */
    public int getCollectedCanvas(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_GET_TOTAL_COLLECTED_CANVAS);
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_GET_TOTAL_COLLECTED_CANVAS){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_GET_TOTAL_COLLECTED_CANVAS + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        con.close();
        return inMessage.getTotalNumberOfStolenCanvas();
    }

    /**
     * Called by master thief
     * Start the operation
     */
    public void startOfOperation(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_START_OPERATION, ((MasterThief) Thread.currentThread()).getThiefState());
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_START_OPERATION){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_START_OPERATION + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getMasterThiefState() != MasterThiefStates.DECIDING_WHAT_TO_DO){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid master thief state!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((MasterThief) Thread.currentThread()).setThiefState(inMessage.getMasterThiefState());

        con.close();
    }

    /**
     * Called by master thief
     * Appraise situation
     * @return char with the decision
     */
    public char appraiseSit(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_APPRAISE_SIT, ((MasterThief) Thread.currentThread()).getThiefState()); ///////////////////////////
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_APPRAISE_SIT){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_APPRAISE_SIT + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getDecision() != 'E' && inMessage.getDecision() != 'R' && inMessage.getDecision() != 'P'){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid decision!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        con.close();
        return inMessage.getDecision();
    }

    /**
     * Called by master thief
     * Master Thief waits for thieves to arrive from the museum
     */
    public void takeARest(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_TAKE_A_REST, ((MasterThief) Thread.currentThread()).getThiefState());
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_TAKE_A_REST){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_TAKE_A_REST + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getMasterThiefState() != MasterThiefStates.WAITING_FOR_ARRIVAL){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid master thief state!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((MasterThief) Thread.currentThread()).setThiefState(inMessage.getMasterThiefState());

        con.close();
    }

    /**
     * Called by master thief
     * Collect a canvas
     */
    public void collectACanvas(){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_COLLECT_CANVAS, ((MasterThief) Thread.currentThread()).getThiefState());
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_COLLECT_CANVAS){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_COLLECT_CANVAS + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getMasterThiefState() != MasterThiefStates.DECIDING_WHAT_TO_DO){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid master thief state!");
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        ((MasterThief) Thread.currentThread()).setThiefState(inMessage.getMasterThiefState());

        con.close();
    }

    /**
     * Called by thief
     * Thief hand over a canvas
     * @param assaultPartyID assault party id
     */
    //AQUIIIIIIIIIIIIII adicionar targetRoom e hasCanvas aqui
    //ou seja:
    //op1: fazer os pedidas à assault party aqui e mandar o resultado para o server (server <-> client <-> server)
    //op2: fazer os pedidos à assault party no server, server <-> server (GAMEIRO ESTA OPÇÃO)
    public void handACanvas(int assaultPartyID){
        Message inMessage, outMessage;
        ClientCom con = new ClientCom(serverHostName, serverPortNumb);
        while(!con.open()){
            try{
                Thread.currentThread().sleep((long) (10));
            }catch(InterruptedException e){}
        }

        outMessage = new Message(MessageType.REQ_HAND_CANVAS, ((NormalThief) Thread.currentThread()).getThiefId(), assaultPartyID);
        con.writeObject(outMessage);
        inMessage = (Message) con.readObject();

        if(inMessage.getMsgType() != MessageType.REP_HAND_CANVAS){
            System.out.println("Thread " + Thread.currentThread().getName() + ": Invalid message type!");
            System.out.println("Expected: " + MessageType.REP_HAND_CANVAS + " Got: " + inMessage.getMsgType());
            System.out.println(inMessage.toString());
            System.exit(1);
        }

        if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId())
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief ID!");
			System.out.println("THIEF ID:\tExpected: " + ((NormalThief) Thread.currentThread()).getThiefId() + "\tReceived: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

        con.close();
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
		
		outMessage = new Message (MessageType.REQ_SHUTDOWN_CONTROL_COLLECTION_SITE);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SHUTDOWN_CONTROL_COLLECTION_SITE)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		
		//Close communication channel
		com.close ();
	}

}
