package serverSide.entities;

import clientSide.entities.*;
import commInfra.Message;
import commInfra.MessageException;
import commInfra.ServerCom;
import serverSide.sharedRegions.MuseumInterface;

/**
 *  Service provider agent for access to the Museum.
 *
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */


public class MuseumClientProxy extends Thread implements NormalThiefClone{

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
     * Interface to the Museum.
     */    
    private final MuseumInterface MuseumInterface;

    /**
     * Number of instatiayed threads
     */
     private static int nProxy = 0;

     /**
      * Number of instantiated threads.
      */
    private ServerCom sconi;

    /**
     * Instantiation of the interface to the Museum.
     *
     *    @param sconi communication channel
     *    @param MuseumInterface interface to the Museum
     */
    public MuseumClientProxy (ServerCom sconi, MuseumInterface MuseumInterface)
    {
       super ("Proxy_" + MuseumClientProxy.getProxyId ());

       this.sconi = sconi;
       this.MuseumInterface = MuseumInterface;
    }

    /**
     * Generation of the instantiation identifier.
     */
    private static int getProxyId ()
    {
       Class<?> cl = null;             // representation of the MuseumClientProxy object in JVM
       int proxyId;                    // instantiation identifier

       try
       { cl = Class.forName ("serverSide.entities.MuseumClientProxy");
       }
       catch (ClassNotFoundException e)
       { System.out.println("Data type MuseumClientProxy was not found!");
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
       { outMessage = MuseumInterface.processAndReply (inMessage);         // process it
       }
       catch (MessageException e)
       {  System.out.println("Thread " + getName () + ": " + e.getMessage () + "!");
          System.out.println(e.getMessageVal ().toString ());
         System.exit (1);
       }
       sconi.writeObject (outMessage);                                // send service reply
       sconi.close ();                                                // close the communication channel
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
     * @param id of the thief
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
}
