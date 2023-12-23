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
public class ServerConcentrationSite{

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

        // instantiate ConcentrationSite object
        Random rand = new Random();
        int[] roomDistance = new int[SimulPar.N];
        for (int i = 0; i < roomDistance.length; i++) {
            roomDistance[i] = rand.nextInt(30-15+1) + 15;
        }

        //set room distance in general repo
        try{
            generalRepoStub.setRoomsDistance(roomDistance);
        }
        catch(RemoteException e){
            System.out.println("Remote exception setting room distance: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }


        ConcentrationSite concentrationSite = new ConcentrationSite(assaultPartiesStub, roomDistance, generalRepoStub);
        ConcentrationSiteInterface concentrationSiteStub = null;   // remote reference to the concentration site object

        try{
            concentrationSiteStub = (ConcentrationSiteInterface) UnicastRemoteObject.exportObject(concentrationSite, portNumb);
        }
        catch(RemoteException e){
            System.out.println("ConcentrationSite stub generation exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("Stub was generated!");

        // register ConcentrationSite object
        String nameEntryBase = "RegisterHandler";       // public name of the object that enables the registration
        String nameEntryObject = "ConcentrationSite";   // public name of the concentration site object
        Register reg = null;                            // remote reference for registration in the RMI registry service

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
            reg.bind(nameEntryObject, concentrationSiteStub);
        }
        catch(RemoteException e){
            System.out.println("ConcentrationSite registration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(AlreadyBoundException e){
            System.out.println("ConcentrationSite already bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("ConcentrationSite object was registered!");

        // wait for the end of operations
        System.out.println("ConcentrationSite is in operation!");
        try{
            while(!end) synchronized(Class.forName("serverSide.main.ServerConcentrationSite")){
                try{
                    (Class.forName("serverSide.main.ServerConcentrationSite")).wait();
                }
                catch(InterruptedException e){
                    System.out.println("ConcentrationSite main thread was interrupted!");
                }
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type ConcentrationSite was not found (blocking)!");
            e.printStackTrace();
            System.exit(1);
        }

        // server shutdown
        boolean shutdownDone = false;       // flag signalling the shutdown of the concentration site service

        try{
            reg.unbind(nameEntryObject);
        }
        catch(RemoteException e){
            System.out.println("ConcentrationSite deregistration exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        catch(NotBoundException e){
            System.out.println("ConcentrationSite not bound exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        System.out.println("ConcentrationSite object was deregistered!");

        try{
            shutdownDone = UnicastRemoteObject.unexportObject(concentrationSite, true);
        }
        catch(RemoteException e){
            System.out.println("ConcentrationSite unexport exception: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        if(shutdownDone)
            System.out.println("ConcentrationSite was shutdown!");
    }

    /**
     * Shutdown the Concentration Site service
     */
    public static void shutdown(){
        end = true;
        try{
            synchronized(Class.forName("serverSide.main.ServerConcentrationSite")){
                (Class.forName("serverSide.main.ServerConcentrationSite")).notify();
            }
        }
        catch(ClassNotFoundException e){
            System.out.println("The data type ConcentrationSite was not found (waking up)!");
            e.printStackTrace();
            System.exit(1);
        }
    }

}