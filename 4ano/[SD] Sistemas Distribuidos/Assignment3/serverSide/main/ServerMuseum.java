package serverSide.main;

import java.rmi.registry.*;
import java.rmi.*;
import java.rmi.server.*;
import serverSide.objects.*;
import interfaces.*;
import java.util.Random;

/**
 *  Instantiation and registering of a server object that enables the simulation to run.
 *  Implementation of a client-server model of type 2 (server replication). 
 *  Communication is based on Java RMI.
 */
public class ServerMuseum {

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

        // get remote reference to the general repository object
        GeneralRepoInterface generalRepoStub = null;   // remote reference to the general repository object
        try{
            generalRepoStub = (GeneralRepoInterface) registry.lookup("GeneralRepo");
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

        // get remote reference to the assault parties object
        AssaultPartyInterface[] assaultPartiesStub = new AssaultPartyInterface[SimulPar.N_PARTIES];   // remote reference to the assault parties object
        for(int i=0; i<SimulPar.N_PARTIES; i++){
            try{
                assaultPartiesStub[i] = (AssaultPartyInterface) registry.lookup("AssaultParty"+i);
            }
            catch(RemoteException e){
                System.out.println("AssaultParty"+i+" lookup exception: " + e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }
            catch(NotBoundException e){
                System.out.println("AssaultParty"+i+" not bound exception: " + e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }
        }

        // instantiate Museum object
        Random rand = new Random();
        int[] paintings = new int[SimulPar.N];
        for (int i = 0; i < paintings.length; i++) {
            paintings[i] = rand.nextInt(16-8+1) + 8;
        }

        //send paintings to general repo
        try{
            generalRepoStub.setPaintings(paintings);
        }
        catch(RemoteException e){
            System.out.println("GeneralRepo set paintings exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        Museum museum = new Museum(generalRepoStub, assaultPartiesStub, paintings);
        MuseumInterface museumStub = null;                              // remote reference to the museum object

        try{
            museumStub = (MuseumInterface) UnicastRemoteObject.exportObject(museum, portNumb);
        }
        catch(RemoteException e){
            System.out.println("Museum stub generation exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("Stub was generated!");

        // register Museum object
        String nameEntryBase = "RegisterHandler";                       // public name of the object that enables the registration
        String nameEntryObject = "Museum";                              // public name of the museum object
        Register reg = null;                                            // remote reference for registration in the RMI registry service

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
            reg.bind(nameEntryObject, museumStub);
        }
        catch(RemoteException e){
            System.out.println("Museum registration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(AlreadyBoundException e){
            System.out.println("Museum already bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("Museum object was registered!");

        // Wait for the end of operations
        System.out.println("Museum is in operation!");
        try{
            while(!end) synchronized(Class.forName("serverSide.main.ServerMuseum")){
                try{
                    (Class.forName("serverSide.main.ServerMuseum")).wait();
                }
                catch(InterruptedException e){
                    System.out.println("Museum main thread was interrupted!");
                }
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type Museum was not found (blocking)!");
            e.printStackTrace();
            System.exit(1);
        }

        //server shutdown
        boolean shutdownDone = false;                                   // flag signalling the shutdown of the Museum service

        try{
            reg.unbind(nameEntryObject);
        }
        catch(RemoteException e){
            System.out.println("Museum deregistration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(NotBoundException e){
            System.out.println("Museum not bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        try{
            shutdownDone = UnicastRemoteObject.unexportObject(museum, true);
        }
        catch(NoSuchObjectException e){
            System.out.println("Museum unexport exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        if(shutdownDone)
            System.out.println("Museum was shutdown!");
    }

    /**
     * Shutdown the Museum service
     */
    public static void shutdown(){
        end = true;
        try{
            synchronized(Class.forName("serverSide.main.ServerMuseum")){
                (Class.forName("serverSide.main.ServerMuseum")).notify();
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type Museum was not found (waking up)!");
            e.printStackTrace();
            System.exit(1);
        }
    }
    
}
