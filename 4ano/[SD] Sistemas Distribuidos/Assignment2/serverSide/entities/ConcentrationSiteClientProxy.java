package serverSide.entities;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.ServerCom;
import serverSide.sharedRegions.ConcentrationSiteInterface;

/**
 *  Service provider agent for access to the ConcentrationSite.
 *
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */


public class ConcentrationSiteClientProxy extends Thread implements MasterThiefClone, NormalThiefClone{

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
     * Interface to the ConcentrationSite.
     */    
    private final ConcentrationSiteInterface concentrationSiteInterface;

    /**
     * Number of instatiayed threads
     */
     private static int nProxy = 0;

     /**
      * Number of instantiated threads.
      */
    private ServerCom sconi;

    /**
     * Instantiation of the interface to the ConcentrationSite.
     *
     *    @param sconi communication channel
     *    @param concentrationSiteInterface interface to the ConcentrationSite
     */
    public ConcentrationSiteClientProxy (ServerCom sconi, ConcentrationSiteInterface concentrationSiteInterface)
    {
       super ("Proxy_" + ConcentrationSiteClientProxy.getProxyId ());

       this.sconi = sconi;
       this.concentrationSiteInterface = concentrationSiteInterface;
    }

    /**
     * Generation of the instantiation identifier.
     */
    private static int getProxyId ()
    {
       Class<?> cl = null;             // representation of the ConcentrationSiteClientProxy object in JVM
       int proxyId;                    // instantiation identifier

       try
       { cl = Class.forName ("serverSide.entities.ConcentrationSiteClientProxy");
       }
       catch (ClassNotFoundException e)
       { System.out.println("Data type ConcentrationSiteClientProxy was not found!");
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
       { outMessage = concentrationSiteInterface.processAndReply (inMessage);         // process it
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
     * Set the number of the room that the thief is
     * @param id of the room
     */
    @Override
    public void setThiefId(int id) {
        this.thiefID = id;
    }

    /**
     * Get the number of the room that the thief is
     * @return room number
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
    
}
