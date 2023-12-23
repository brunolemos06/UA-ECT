package serverSide.entities;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.ServerCom;
import serverSide.sharedRegions.AssaultPartyInterface;

/**
 *  Service provider agent for access to the AssaultParty.
 *
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class AssaultPartyClientProxy extends Thread implements MasterThiefClone, NormalThiefClone{

    /**
     * Target RoomID
     */
    private int targetRoomID;

    /**
     * Room distance
     */
    private int roomDistance;

    /**
     * Thief have canvas
     */
    private boolean hasCanvas;

    /**
     * Master Thief state.
     */
    private int masterThiefState;

    /**
     * Normal Thief state.
     */
    private int normalThiefState;

    /**
     * Thief ID
     */
    private int thiefID;

    /**
     * Thief agility
     */
    private int thiefAgility;

    /**
     * Number of instatiayed threads
     */
     private static int nProxy = 0;

    /**
     * Number of instantiated threads.
     */
    private ServerCom sconi;

    /**
     * Interface to the AssaultParty.
     */
    private AssaultPartyInterface assaultPartyInterface;

    /**
     * Instantiation of the interface to the AssaultParty.
     *
     *    @param sconi communication channel
     *    @param assaultPartyInterface interface to the AssaultParty
     */
    public AssaultPartyClientProxy(ServerCom sconi, AssaultPartyInterface assaultPartyInterface){
        super("AssaultPartyProxy_" + getProxyId());

        this.sconi = sconi;
        this.assaultPartyInterface = assaultPartyInterface;
    }

    private static int getProxyId ()
    {
        Class<?> cl = null;                                 // representation of the class or interface
        int proxyId;                                        // instantiation identifier

        try
        { cl = Class.forName ("serverSide.entities.AssaultPartyClientProxy");
        }
        catch (ClassNotFoundException e)
        { System.out.println("O tipo de dados AssaultPartyProxy não foi encontrado!");
          e.printStackTrace ();
          System.exit (1);
        }

        synchronized (cl)
        { proxyId = nProxy;
          nProxy += 1;
        }

        return proxyId;
    }

    /**
     * Life cycle of the thread that instantiates the client proxy.
     */
    public void run ()
    {
       Message inMessage = null,                                      // service request
               outMessage = null;                                     // service reply
 
      /* service providing */
 
       inMessage = (Message) sconi.readObject ();                     // get service request
       try
       { outMessage = assaultPartyInterface.processAndReply (inMessage);         // process it
       }
       catch (MessageException e)
       {  System.out.println("Thread " + getName () + ": " + e.getMessage () + "!");
          System.out.println(e.getMessageVal ().toString ());
         System.exit (1);
       }
       sconi.writeObject (outMessage);                                // send service reply
       sconi.close ();                                                // close the communication channel
    }

    // MasterThiefClone interface methods
    /**
     * Set the state of the master thief
     * @param state of the thief
     * 
     */
    @Override
    public void setMasterThiefState(int state) {
        this.masterThiefState = state;
    }

    /**
     * Get the state of the master thief
     * @return master thief state
     */
    @Override
    public int getMasterThiefState() {
        return this.masterThiefState;
    }

    // NormalThiefClone interface methods

    /**
     * Set the state of the normal thief
     * @param state of the thief
     * 
     */
    @Override
    public void setThiefState(int state) {
        this.normalThiefState = state;
    }

    /**
     * Get the state of the normal thief
     * @return normal thief state
     */
    @Override
    public int getThiefState() {
        return this.normalThiefState;
    }

    /**
     * Set the thief id
     * @param id of the thief
     * 
     */
    @Override
    public void setThiefId(int id) {
        this.thiefID = id;
    }

    /**
     * Get the thief id
     * @return thief id
     */
    @Override
    public int getThiefId() {
        return this.thiefID;
    }

    /**
     * Set the thief agility
     * @param agility of the thief
     * 
     */
    @Override
    public void setThiefAgility(int agility) {
        this.thiefAgility = agility;
    }

    /**
     * Get the thief agility
     * @return thief agility
     */
    @Override
    public int getThiefAgility() {
        return this.thiefAgility;
    }

    /**
     * Set the thief has canvas
     * @param hasCanvas
     * 
     */
    public void setHasCanvas(boolean hasCanvas) {
        this.hasCanvas = hasCanvas;
    }

    /**
     * Get the thief has canvas
     * @return hasCanvas
     */
    public boolean getHasCanvas() {
        return this.hasCanvas;
    }

    /**
     * Set the room distance
     * @param roomDistance
     * 
     */
    public void setRoomDistance(int roomDistance) {
        this.roomDistance = roomDistance;
    }

    /**
     * Get the room distance
     * @return roomDistance
     */
    public int getRoomDistance() {
        return this.roomDistance;
    }
    
    /**
     * Set the target room ID
     * @param targetRoomID
     * 
     */
    public void setTargetRoomID(int targetRoomID) {
        this.targetRoomID = targetRoomID;
    }

    /**
     * Get the target room ID
     * @return targetRoomID
     */
    public int getTargetRoomID() {
        return this.targetRoomID;
    }
}