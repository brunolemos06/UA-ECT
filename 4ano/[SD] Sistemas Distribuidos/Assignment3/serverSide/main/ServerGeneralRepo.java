package serverSide.main;

import java.rmi.registry.*;
import java.rmi.*;
import java.rmi.server.*;
import serverSide.objects.*;
import interfaces.*;

/**
 *  Instantiation and registering of a server object that enables the simulation to run.
 *  Implementation of a client-server model of type 2 (server replication). 
 *  Communication is based on Java RMI.
 */
public class ServerGeneralRepo {

    /**
     * Flag signaling the end of operations.
     */
    public static boolean end = false;

    /**
     * Main method.
     * 
     * @param args runtime arguments
     *  args[0] - port number for listening to service requests
     *  args[1] - name of the platform where is located the RMI registering service
     *  args[2] - port number where the registering service is listening to service requests
     */
    public static void main(String[] args){
        int portNumb = -1;                                             // port number for listening to service requests
        String rmiRegHostName;                                         // name of the platform where is located the RMI registering service
        int rmiRegPortNumb = -1;                                       // port number where the registering service is listening to service requests

        if(args.length != 3){
            System.out.println("Wrong number of parameters!");
            System.exit(1);
        }

        try{
            portNumb = Integer.parseInt(args[0]);
        }
        catch(NumberFormatException e){
            System.out.println("args[0] is not a number!");
            System.exit(1);
        }
        if((portNumb < 22130) || (portNumb >= 22139)){
            System.out.println("args[0] is not a valid port number!");
            System.exit(1);
        }

        rmiRegHostName = args[1];
        try{
            rmiRegPortNumb = Integer.parseInt(args[2]);
        }
        catch(NumberFormatException e){
            System.out.println("args[2] is not a number!");
            System.exit(1);
        }
        if((rmiRegPortNumb < 22130) || (rmiRegPortNumb >= 22139)){
            System.out.println("args[2] is not a valid port number!");
            System.exit(1);
        }

        /* create and install the security manager */
        if (System.getSecurityManager () == null)
            System.setSecurityManager (new SecurityManager ());
        System.out.println("Security manager was installed!");

        // instantiate registry service object
        Registry registry = null;                                       // remote reference for registration in the RMI registry service

        try{
            registry = LocateRegistry.getRegistry(rmiRegHostName, rmiRegPortNumb);
        }
        catch(RemoteException e){
            System.out.println("RMI registry creation exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("RMI registry was created!");

        //instantiate GeneralRepo object
        GeneralRepo repo = new GeneralRepo("log.txt");  //general repository object
        GeneralRepoInterface repoStub = null;                       // remote reference to the general repository object

        try{
            repoStub = (GeneralRepoInterface) UnicastRemoteObject.exportObject(repo, portNumb);
        }
        catch(RemoteException e){
            System.out.println("GeneralRepo stub generation exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("Stub was generated!");

        // register GeneralRepo object
        String nameEntryBase = "RegisterHandler";                      // public name of the object that enables the registration
        String nameEntryObject = "GeneralRepo";                        // public name of the general repository object
        Register reg = null;                                            // remote reference to the object that enables the registration

        try{
            reg = (Register) registry.lookup(nameEntryBase);
        }
        catch(RemoteException e){
            System.out.println("RegisterRemoteObject lookup exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(NotBoundException e){
            System.out.println("RegisterRemoteObject not bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        try{
            reg.bind(nameEntryObject, repoStub);
        }
        catch(RemoteException e){
            System.out.println("GeneralRepo registration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(AlreadyBoundException e){
            System.out.println("GeneralRepo already bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("GeneralRepo object was registered!");

        // wait for the end of operations
        System.out.println("GeneralRepo is in operation!");
        try{
            while(!end) synchronized(Class.forName("serverSide.main.ServerGeneralRepo")){
                try{
                    (Class.forName("serverSide.main.ServerGeneralRepo")).wait();
                }
                catch(InterruptedException e){
                    System.out.println("GeneralRepo main thread was interrupted!");
                }
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type GeneralRepo was not found (blocking)!");
            e.printStackTrace();
            System.exit(1);
        }

        // server shutdown
        boolean shutdownDone = false;                                   // flag signalling the shutdown of the general repository service

        try{
            reg.unbind(nameEntryObject);
        }
        catch(RemoteException e){
            System.out.println("GeneralRepo deregistration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(NotBoundException e){
            System.out.println("GeneralRepo not bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        try{
            shutdownDone = UnicastRemoteObject.unexportObject(repo, true);
        }
        catch(NoSuchObjectException e){
            System.out.println("GeneralRepo unexport exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        if(shutdownDone)
            System.out.println("GeneralRepo was shutdown!");
    }

    /**
     * Shutdown the General Repo service
     */
    public static void shutdown(){
        end = true;
        try{
            synchronized(Class.forName("serverSide.main.ServerGeneralRepo")){
                (Class.forName("serverSide.main.ServerGeneralRepo")).notify();
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type GeneralRepo was not found (waking up)!");
            e.printStackTrace();
            System.exit(1);
        }
    }
    
}
