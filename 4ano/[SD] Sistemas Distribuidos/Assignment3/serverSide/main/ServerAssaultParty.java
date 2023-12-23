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
public class ServerAssaultParty{

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
     *  args[3] - id of the AssaultParty
     */
    public static void main(String[] args){
        int portNumb = -1;                                             // port number for listening to service requests
        String rmiRegHostName;                                         // name of the platform where is located the RMI registering service
        int rmiRegPortNumb = -1;                                       // port number where the registering service is listening to service requests
        int id = -1;                                                   // id of the AssaultParty      

        if(args.length != 4){
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

        try{
            id = Integer.parseInt(args[3]);
        }
        catch(NumberFormatException e){
            System.out.println("args[3] is not a number!");
            System.exit(1);
        }
        if(id != 0 && id != 1){
            System.out.println("args[3] is not a valid id!");
            System.exit(1);
        }

        /* create and install the security manager */
        if(System.getSecurityManager() == null){
            System.setSecurityManager(new SecurityManager());
        }
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

        // get remote reference to the general repository object
        GeneralRepoInterface generalRepositoryStub = null;   // remote reference to the general repository object
        try{
            generalRepositoryStub = (GeneralRepoInterface) registry.lookup("GeneralRepo");
        }
        catch(RemoteException e){
            System.out.println("GeneralRepository lookup exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(NotBoundException e){
            System.out.println("GeneralRepository not bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        // instantiate AssaultParty objects
        AssaultParty assaultParty = new AssaultParty(id, generalRepositoryStub);   // AssaultParty object
        AssaultPartyInterface assaultPartyStub = null;                             // remote reference to the AssaultParty object

        try{
            assaultPartyStub = (AssaultPartyInterface) UnicastRemoteObject.exportObject(assaultParty, portNumb);
        }
        catch(RemoteException e){
            System.out.println("AssaultParty stub generation exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("Stub was generated!");

        // register AssaultParty object
        String nameEntryBase = "RegisterHandler";           // public name of the object that enables the registration
        String nameEntryObject = "AssaultParty" + id;       // public name of the object that enables the access to the object that is going to be registered
        Register reg = null;                                // remote reference to the object that enables the registration

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
            reg.bind(nameEntryObject, assaultPartyStub);
        }
        catch(RemoteException e){
            System.out.println("AssaultParty registration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(AlreadyBoundException e){
            System.out.println("AssaultParty already bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("AssaultParty object was registered!");

        // Wait for the service to end
        System.out.println("AssaultParty is in operation!");
        try{
            while(!end) synchronized(Class.forName("serverSide.main.ServerAssaultParty")){
                try{
                    (Class.forName("serverSide.main.ServerAssaultParty")).wait();
                }
                catch(InterruptedException e){
                    System.out.println("AssaultParty main thread was interrupted!");
                }
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type ServerAssaultParty was not found (blocking)!");
            e.printStackTrace();
            System.exit(1);
        }

        // server shutdown
        boolean shutdownDone = false;           // flag signalling the shutdown of the AssaultParty service

        // unregister remote reference from the RMI registry service
        try{
            reg.unbind(nameEntryObject);
        }
        catch(RemoteException e){
            System.out.println("AssaultParty deregistration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(NotBoundException e){
            System.out.println("AssaultParty not bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("AssaultParty object was deregistered!");

        try{
            shutdownDone = UnicastRemoteObject.unexportObject(assaultParty, true);
        }
        catch(NoSuchObjectException e){
            System.out.println("AssaultParty unexport exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        if(shutdownDone){
            System.out.println("AssaultParty was shutdown!");
        }

    }

    /**
     * Shutdown the AssaultParty service.
     */
    public static void shutdown(){
        end = true;
        try{
            synchronized(Class.forName("serverSide.main.ServerAssaultParty")){
                (Class.forName("serverSide.main.ServerAssaultParty")).notify();
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type ServerAssaultParty was not found (waking up)!");
            e.printStackTrace();
            System.exit(1);
        }
    }
}