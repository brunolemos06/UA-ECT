package serverSide.entities;

import serverSide.sharedRegions.*;
import commInfra.*;


/**
 * General Repository Client Proxy
 * It is responsible for receiving and processing messages sent by the client
 * and for sending messages back to the client
 */

public class GeneralReposClientProxy extends Thread
{
    /**
     * Number of instatiayed threads
     */

    private static int nProxy = 0;

    /**
     * Communication channel
     */

    private ServerCom sconi;

    /**
     *  Interface to the General Repository of Information.
     */

   private GeneralRepoInterface reposInter;

   
   /**
    * Instantiation of a General Repository Client Proxy.
    * @param sconi communication channel
    * @param reposInter interface to the General Repository of Information
    */

    public GeneralReposClientProxy (ServerCom sconi, GeneralRepoInterface reposInter)
    {
        super ("GeneralReposProxy_" + GeneralReposClientProxy.getProxyId ());

        this.sconi = sconi;
        this.reposInter = reposInter;
    }

    /**
     * Generation of the instantiation identifier
     * 
     * @return instantiation identifier
     */
     
    private static int getProxyId ()
    {
        Class<?> cl = null;                                 // representation of the class or interface
        int proxyId;                                        // instantiation identifier

        try
        { cl = Class.forName ("serverSide.entities.GeneralReposClientProxy");
        }
        catch (ClassNotFoundException e)
        { System.out.println("O tipo de dados GeneralReposProxy não foi encontrado!");
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
       { outMessage = reposInter.processAndReply (inMessage);         // process it
       }
       catch (MessageException e)
       {  System.out.println("Thread " + getName () + ": " + e.getMessage () + "!");
          System.out.println(e.getMessageVal ().toString ());
         System.exit (1);
       }
       sconi.writeObject (outMessage);                                // send service reply
       sconi.close ();                                                // close the communication channel
    }

}