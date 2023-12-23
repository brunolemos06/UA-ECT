package serverSide.entities;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.ServerCom;
import serverSide.sharedRegions.ControlCollectionSiteInterface;

/**
 *  Service provider agent for access to the ControlCollectionSite.
 *
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */


 public class ControlCollectionSiteClientProxy extends Thread implements MasterThiefClone, NormalThiefClone{

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
     * Assault party ID
     */
    private int assaultPartyID;

    /**
     * RoomId with canvas
     */
    private int roomIdWithCanvas;

    /**
     * Total number of canvas collected
     */
    private int totalNumberOfCanvasCollected;

     /**
     * Interface to the ControlCollectionSite.
     */    
    private final ControlCollectionSiteInterface controlCollectionSiteInterface;

    /**
     * Number of instatiayed threads
     */
     private static int nProxy = 0;

     /**
      * Number of instantiated threads.
      */
    private ServerCom sconi;

    /**
     * Instantiation of the interface to the controlCollectionSite.
     *
     *    @param sconi communication channel
     *    @param controlCollectionSiteInterface interface to the controlCollectionSite
     */
    public ControlCollectionSiteClientProxy (ServerCom sconi, ControlCollectionSiteInterface controlCollectionSiteInterface)
    {
       super ("Proxy_" + ControlCollectionSiteClientProxy.getProxyId ());

       this.sconi = sconi;
       this.controlCollectionSiteInterface = controlCollectionSiteInterface;
    }

    /**
     * Generation of the instantiation identifier.
     */
    private static int getProxyId ()
    {
       Class<?> cl = null;             // representation of the ControlCollectionSiteClientProxy object in JVM
       int proxyId;                    // instantiation identifier

       try
       { cl = Class.forName ("serverSide.entities.ControlCollectionSiteClientProxy");
       }
       catch (ClassNotFoundException e)
       { System.out.println("Data type ControlCollectionSiteClientProxy was not found!");
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
       { outMessage = controlCollectionSiteInterface.processAndReply (inMessage);         // process it
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
     * Set the thief ID
     * @param id thief
     */
    @Override
    public void setThiefId(int id) {
        this.thiefID = id;
    }

    /**
     * Get the thief ID
     * @return thief ID
     */
    @Override
    public int getThiefId() {
        return this.thiefID;
    }

    /**
     * Set the thief agility
     * @param agility of the thief
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
     * Set the assault party ID
     * @param id of the assault party
     */
    public void setAssaultPartyId(int id) {
        this.assaultPartyID = id;
    }

    /**
     * Get the assault party ID
     * @return assault party ID
     */
    public int getAssaultPartyId() {
        return this.assaultPartyID;
    }

    /**
     * Set the room ID with canvas
     * @param id of the room
     */
    public void setRoomWithCanvasID(int id) {
        this.roomIdWithCanvas = id;
    }

    /**
     * Get the room ID with canvas
     * @return room ID with canvas
     */
    public int getRoomWithCanvasID() {
        return this.roomIdWithCanvas;
    }

    /**
     * Set the total number of canvas collected
     */
    public void setCollectedCanvas(int canvas) {
        this.totalNumberOfCanvasCollected = canvas;
    }

    /**
     * Get the total number of canvas collected
     * @return total number of canvas collected
     */
    public int getCollectedCanvas() {
        return this.totalNumberOfCanvasCollected;
    }
}
