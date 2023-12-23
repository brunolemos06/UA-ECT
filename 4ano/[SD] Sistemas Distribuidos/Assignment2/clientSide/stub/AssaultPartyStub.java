package clientSide.stub;

import clientSide.entities.*;
import commInfra.*;
import serverSide.entities.ConcentrationSiteClientProxy;
import serverSide.entities.ControlCollectionSiteClientProxy;
import serverSide.entities.MuseumClientProxy;

public class AssaultPartyStub {
    /**
	 * Name of the platform where is located the assault party server
	 */
	private String serverHostName;
	/**
	 * Port number for listening to service requests
	 */
	private int serverPortNumb;
	
	
	/**
	 * Instantiation of a stub to the Assault Party.
	 * 
	 * @param serverHostName name of the platform where is located the assault party server
	 * @param serverPortNumb port number for listening to service requests
	 */
	public AssaultPartyStub(String serverHostName, int serverPortNumb){
		this.serverHostName = serverHostName;
		this.serverPortNumb = serverPortNumb;
	}

    /**
	 * Called by thief
	 * Return if the thief has the canvas or not
	 * @param id Id of the thief
	 * @return True if the thief has the canvas, false otherwise
	 */
    public boolean getHasCanvas(int id){
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
		
		outMessage = new Message (MessageType.REQ_GET_HAS_CANVAS, id);
        com.writeObject(outMessage);
        inMessage = (Message) com.readObject();

        //Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_GET_HAS_CANVAS)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefID() != ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId())
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief ID!");
			System.out.println("THIEF ID:\tExpected: " + ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId() + "\tReceived: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		//Close communication channel
		com.close ();
		return inMessage.getThiefHasCanvas();
    }

	/**
	 * Called by thief
	 * Set if the thief has the canvas or not
	 * @param id Id of the thief
	 * @param hasCanvas True if the thief collected the canvas, false otherwise
	 */
	public void setHasCanvas(int id, boolean hasCanvas){
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
		
		outMessage = new Message (MessageType.REQ_SET_HAS_CANVAS, id, hasCanvas);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SET_HAS_CANVAS)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		
		//Close communication channel
		com.close ();
	}
	
	/**
	 * Return the target room distance
	 * @return Target room distance
	 */
	public int getRoomDistance(){
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
		
		outMessage = new Message (MessageType.REQ_GET_ROOM_DISTANCE);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_GET_ROOM_DISTANCE)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId())
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief ID!");
			System.out.println("THIEF ID:\tExpected: " + ((NormalThief) Thread.currentThread()).getThiefId() + "\tReceived: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		//Close communication channel
		com.close ();
		return inMessage.getRoomDistance();
	}

	/**
	 * Called by thief
	 * Return the id of the target room
	 * @param region 0 if called on control collection site, 1 if called on museum
	 * @return Id of the target room
	 */
	public int getTargetRoom(int region){
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

		if(region == 0)
			outMessage = new Message (MessageType.REQ_GET_TARGET_ROOM_ID, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId());
		else
			outMessage = new Message (MessageType.REQ_GET_TARGET_ROOM_ID, ((MuseumClientProxy) Thread.currentThread()).getThiefId());
		
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_GET_TARGET_ROOM_ID)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(region == 0){
			if(inMessage.getNormalThiefID() != ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId())
			{
				System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief ID!");
				System.out.println("THIEF ID:\tExpected: " + ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId() + "\tReceived: " + inMessage.getNormalThiefID());
				System.out.println (inMessage.toString ());
				System.exit (1);
			}
		}else if(region == 1){
			if(inMessage.getNormalThiefID() != ((MuseumClientProxy) Thread.currentThread()).getThiefId())
			{
				System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief ID!");
				System.out.println("THIEF ID:\tExpected: " + ((MuseumClientProxy) Thread.currentThread()).getThiefId() + "\tReceived: " + inMessage.getNormalThiefID());
				System.out.println (inMessage.toString ());
				System.exit (1);
			}
		}
		//Close communication channel
		com.close ();
		return inMessage.getRoomID();
	}

	/**
	 * Called by master thief
	 * Sets the ID of the assault party
	 * @param assaultID ID of the assault party
	 */
	public void setAssaultID(int assaultID){
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
		
		outMessage = new Message (MessageType.REQ_SET_ASSAULT_PARTY_ID, assaultID);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SET_ASSAULT_PARTY_ID)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		//Close communication channel
		com.close ();
	}

	/**
	 * Called by master thief
	 * Set the ID of the target room
	 * @param targetRoom ID of the target room
	 */
	public void setTargetRoom(int targetRoom){
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
		
		outMessage = new Message (MessageType.REQ_SET_TARGET_ROOM_ID, targetRoom);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SET_TARGET_ROOM_ID)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		//Close communication channel
		com.close ();
	}

	/**
	 * Called by master thief
	 * Set the distance to the target room
	 * @param roomDistance Distance to the target room
	 */
	public void setRoomDistance(int roomDistance){
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
		
		outMessage = new Message (MessageType.REQ_SET_TARGET_ROOM_DISTANCE, roomDistance);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SET_TARGET_ROOM_DISTANCE)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		//Close communication channel
		com.close ();
	}

	/**
	 * Called by thief
	 * Adds the ID of a thief to the list of thieves in the assault party
	 */
	public void addThief(){
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
		
		outMessage = new Message (MessageType.REQ_ADD_THIEF_TO_ASSAULT_PARTY, ((ConcentrationSiteClientProxy) Thread.currentThread()).getThiefId());
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_ADD_THIEF_TO_ASSAULT_PARTY)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefID() != ((ConcentrationSiteClientProxy) Thread.currentThread()).getThiefId())
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief ID!");
			System.out.println("THIEF ID:\tExpected: " + ((NormalThief) Thread.currentThread()).getThiefId() + "\tReceived: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		//Close communication channel
		com.close ();
	}
	
	/**
	 * Called by thief
	 * Sets the assault party to go back to the concentration site
	 */
	public void reverseDirection(){
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
		
		outMessage = new Message (MessageType.REQ_REVERSE_DIRECTION, ((NormalThief) Thread.currentThread()).getThiefId(), ((NormalThief) Thread.currentThread()).getThiefState());
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_REVERSE_DIRECTION)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
			System.out.println ("THIEF ID:\tExpected : " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefState() != NormalThiefStates.CRAWLING_OUTWARDS){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief state!");
			System.out.println ("THIEF STATE:\tExpected : " + NormalThiefStates.CRAWLING_OUTWARDS + " Received: " + inMessage.getNormalThiefState());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		((NormalThief) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
		//Close communication channel
		com.close ();
	}

	/**
	 * Called by thief
	 * Thief crawls inwards
	 */
	public void crawlIn(){
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
		
		outMessage = new Message (MessageType.REQ_CRAWL_IN, ((NormalThief) Thread.currentThread()).getThiefId(), ((NormalThief) Thread.currentThread()).getThiefState(), ((NormalThief) Thread.currentThread()).getAgility());
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_CRAWL_IN)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
			System.out.println ("THIEF ID:\tExpected : " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		
		if(inMessage.getNormalThiefState() != NormalThiefStates.AT_A_ROOM){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief state!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		((NormalThief) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
		//Close communication channel
		com.close ();
	}

	/**
	 * Called by thief
	 * Thief crawls outwards
	 */
	public void crawlOut(){
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
		
		outMessage = new Message (MessageType.REQ_CRAWL_OUT, ((NormalThief) Thread.currentThread()).getThiefId(), ((NormalThief) Thread.currentThread()).getThiefState(), ((NormalThief) Thread.currentThread()).getAgility());
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_CRAWL_OUT)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefID() != ((NormalThief) Thread.currentThread()).getThiefId()){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief id!");
			System.out.println ("THIEF ID:\tExpected : " + ((NormalThief) Thread.currentThread()).getThiefId() + " Received: " + inMessage.getNormalThiefID());
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		if(inMessage.getNormalThiefState() != NormalThiefStates.COLLECTION_SITE){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief state!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		((NormalThief) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
		//Close communication channel
		com.close ();
	}
	
	/**
	 * Called by master thief
	 * Sends the assault party
	 */
	public void sendAssaultParty(){
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
		
		outMessage = new Message (MessageType.REQ_SEND_ASSAULT_PARTY, ((MasterThief) (Thread.currentThread())).getThiefState());
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SEND_ASSAULT_PARTY)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		if(inMessage.getMasterThiefState() != MasterThiefStates.DECIDING_WHAT_TO_DO){
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid thief state!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}

		((MasterThief) (Thread.currentThread())).setThiefState(inMessage.getMasterThiefState());
		//Close communication channel
		com.close ();
	}

	/**
	 * Called by master thief
	 * Waits for the thiefs to join the assault party
	 */
	public void waitForThivesToBeReady(){
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
		
		outMessage = new Message (MessageType.REQ_WAIT_FOR_THIEVES_TO_BE_READY);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_WAIT_FOR_THIEVES_TO_BE_READY)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		//Close communication channel
		com.close ();
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
		
		outMessage = new Message (MessageType.REQ_SHUTDOWN_ASSAULT_PARTY);
		com.writeObject(outMessage);
		inMessage = (Message) com.readObject();

		//Validate inGoing message type and arguments
		if(inMessage.getMsgType() != MessageType.REP_SHUTDOWN_ASSAULT_PARTY)
		{
			System.out.println ("Thread " + Thread.currentThread ().getName () + ": Invalid message type!");
			System.out.println (inMessage.toString ());
			System.exit (1);
		}
		
		//Close communication channel
		com.close ();
	}

}
