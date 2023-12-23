package serverSide.main;

import java.rmi.registry.*;
import java.rmi.*;
import java.rmi.server.*;
import serverSide.objects.*;
import interfaces.*;

/**
 *   Instantiation and registering of an object that enables the registration of other objects located
 *   in the same or other processing nodes of a parallel machine in the local RMI registry service.
 *
 *     Communication is based on Java RMI.
 */
public class ServerRegisterRemoteObject
{
  /**
   *  Main method.
   *
   *    @param args runtime arguments
   *        args[0] - port number for listening to service requests
   *        args[1] - name of the platform where is located the RMI registering service
   *        args[2] - port nunber where the registering service is listening to service requests
   */
    public static void main(String[] args){
        int portNumb = -1;                                             // port number for listening to service requests
        String rmiRegHostName;                                         // name of the platform where is located the RMI registering service
        int rmiRegPortNumb = -1;                                       // port number where the registering service is listening to service requests

        if (args.length != 3){ 
            System.out.println("Wrong number of parameters!");
            System.exit (1);
        }

        try{ 
            portNumb = Integer.parseInt (args[0]);
        }
        catch (NumberFormatException e){ 
            System.out.println("args[0] is not a number!");
            System.exit (1);
        }
        if ((portNumb < 22130) || (portNumb >= 22139)){ 
            System.out.println("args[0] is not a valid port number!");
            System.exit (1);
        }

        rmiRegHostName = args[1];

        try{ 
            rmiRegPortNumb = Integer.parseInt (args[2]);
        }
        catch (NumberFormatException e){ 
            System.out.println("args[2] is not a number!");
            System.exit (1);
        }
        if ((rmiRegPortNumb < 22130) || (rmiRegPortNumb >= 22139)){ 
            System.out.println("args[2] is not a valid port number!");
            System.exit (1);
        }

        /* create and install the security manager */

        if (System.getSecurityManager () == null)
            System.setSecurityManager (new SecurityManager ());
        
        System.out.println("Security manager was installed!");

        /* instantiate a registration remote object and generate a stub for it */

        RegisterRemoteObject regEngine = new RegisterRemoteObject (rmiRegHostName, rmiRegPortNumb);  // object that enables the registration of other remote objects
        Register regStub = null;                                                               // remote reference to it

        try
        { regStub = (Register) UnicastRemoteObject.exportObject (regEngine, portNumb);
        }
        catch (RemoteException e){ 
            System.out.println("RegisterRemoteObject stub generation exception: " + e.getMessage ());
            System.exit (1);
        }
        System.out.println("Stub was generated!");

        /* register it with the local registry service */

        String nameEntry = "RegisterHandler";       // public name of the remote object that enables the registration of other remote objects
        Registry registry = null;                   // remote reference for registration in the RMI registry service

        try{ 
            registry = LocateRegistry.getRegistry (rmiRegHostName, rmiRegPortNumb);
        }
        catch (RemoteException e) { 
            System.out.println("RMI registry creation exception: " + e.getMessage ());
            System.exit (1);
        }
        System.out.println("RMI registry was created!");

        try{ 
            registry.rebind (nameEntry, regStub);
        }
        catch (RemoteException e){ 
            System.out.println("RegisterRemoteObject remote exception on registration: " + e.getMessage ());
            System.exit (1);
        }
        System.out.println("RegisterRemoteObject object was registered!");
    }
}