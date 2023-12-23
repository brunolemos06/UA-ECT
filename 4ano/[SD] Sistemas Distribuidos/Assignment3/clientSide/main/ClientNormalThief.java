package clientSide.main;

import interfaces.*;
import serverSide.main.SimulPar;
import clientSide.entities.*;
import java.rmi.registry.*;
import java.rmi.*;
import java.util.Random;
/**
 *    Client side of the Normal Thief
 *
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on Java RMI.
 */
public class ClientNormalThief {
    
    /**
	 *	Main method. 
	 * 		@param args runtime arguments
	 * 			args[0] - name of the platform where is located the RMI registering service
	 * 			args[1] - port number where the registering service is listening to service requests 
	 */
    public static void main(String[] args){
        String rmiRegHostName;
        int rmiRegPortNumb = -1;

        if (args.length != 2) {
            System.out.println("Wrong number of parameters!");
            System.exit (1);
        }

        rmiRegHostName = args[0];
        try {
            rmiRegPortNumb = Integer.parseInt(args[1]);
        } catch (NumberFormatException e) {
            System.out.println("args[1] is not a number!");
            System.exit (1);
        }
        if ((rmiRegPortNumb < 22130) || (rmiRegPortNumb >= 22139)) {
            System.out.println("args[1] is not a valid port number!");
            System.exit (1);
        }

        String nameEntryConcentrationSite = "ConcentrationSite";            // public name of the concentration site object
        String nameEntryControlCollectionSite = "ControlCollectionSite";    // public name of the control collection site object
        String nameEntryAssaultParty0 = "AssaultParty0";                    // public name of the assault party 0 object
        String nameEntryAssaultParty1 = "AssaultParty1";                    // public name of the assault party 1 object
        String nameEntryMuseum = "Museum";                                  // public name of the museum object
        String nameEntryGeneralRepo = "GeneralRepo";                        // public name of the general repository object

        ConcentrationSiteInterface concentrationSiteStub = null;                   // remote reference to the concentration site object
        ControlCollectionSiteInterface controlCollectionSiteStub = null;           // remote reference to the control collection site object
        AssaultPartyInterface[] assaultPartiesStub = new AssaultPartyInterface[SimulPar.N_PARTIES]; // remote reference to the assault party objects
        MuseumInterface museumStub = null;                                         // remote reference to the museum object
        GeneralRepoInterface generalRepoStub = null;                               // remote reference to the general repository object

        Registry registry = null;   // remote reference for registration in the RMI registry service

        NormalThief[] normalThief = new NormalThief[SimulPar.M-1];  // normal thief threads

        // Locate the RMI registry service
        try {
            registry = LocateRegistry.getRegistry (rmiRegHostName, rmiRegPortNumb);
        } catch (RemoteException e) {
            System.out.println("RMI registry creation exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // Localize the concentration site in the RMI registry service
        try {
            concentrationSiteStub = (ConcentrationSiteInterface) registry.lookup (nameEntryConcentrationSite);
        } catch (RemoteException e) {
            System.out.println("Concentration Site lookup exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        } catch (NotBoundException e) {
            System.out.println("Concentration Site not bound exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // Localize the control collection site in the RMI registry service
        try {
            controlCollectionSiteStub = (ControlCollectionSiteInterface) registry.lookup (nameEntryControlCollectionSite);
        } catch (RemoteException e) {
            System.out.println("Control Collection Site lookup exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        } catch (NotBoundException e) {
            System.out.println("Control Collection Site not bound exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // Localize the assault parties in the RMI registry service

        // Assault party 0
        try {
            assaultPartiesStub[0] = (AssaultPartyInterface) registry.lookup (nameEntryAssaultParty0);
        } catch (RemoteException e) {
            System.out.println("Assault Party 0 lookup exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        } catch (NotBoundException e) {
            System.out.println("Assault Party 0 not bound exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // Assault party 1
        try {
            assaultPartiesStub[1] = (AssaultPartyInterface) registry.lookup (nameEntryAssaultParty1);
        } catch (RemoteException e) {
            System.out.println("Assault Party 1 lookup exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        } catch (NotBoundException e) {
            System.out.println("Assault Party 1 not bound exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // Localize the museum in the RMI registry service
        try {
            museumStub = (MuseumInterface) registry.lookup (nameEntryMuseum);
        } catch (RemoteException e) {
            System.out.println("Museum lookup exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        } catch (NotBoundException e) {
            System.out.println("Museum not bound exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // Localize the general repository in the RMI registry service
        try {
            generalRepoStub = (GeneralRepoInterface) registry.lookup (nameEntryGeneralRepo);
        } catch (RemoteException e) {
            System.out.println("General Repository lookup exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        } catch (NotBoundException e) {
            System.out.println("General Repository not bound exception: " + e.getMessage ());
            e.printStackTrace ();
            System.exit (1);
        }

        // initialize normal thief threads
        Random rand = new Random();
        int [] thiefAgility = new int[SimulPar.M-1];
        for (int i = 0; i < SimulPar.M-1; i++){
            thiefAgility[i] = rand.nextInt(6-2+1)+2;
            normalThief[i] = new NormalThief(i, thiefAgility[i], controlCollectionSiteStub, concentrationSiteStub, assaultPartiesStub, museumStub);
        }

        //send agility to general repository
        //TO DO - this way?
        try{
            generalRepoStub.setAgility(thiefAgility);
        }catch(RemoteException e){
            System.out.println("Error sending agility to general repository: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        // start normal thief threads
        for (int i = 0; i < SimulPar.M-1; i++){
            normalThief[i].start();
        }

        // wait for the end of the normal thief threads
        for (int i = 0; i < SimulPar.M-1; i++){
            try{
                normalThief[i].join();
            }catch(InterruptedException e){
                System.out.println("Normal Thief thread " + i + " has terminated.");
            }
        }

        System.out.println("Normal Thief threads have terminated.");

        //museum shutdown
        try{
            museumStub.shutdown();
        }catch(RemoteException e){
            System.out.println("Error shutting down museum: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        //assault parties shutdown
        for (int i = 0; i < SimulPar.N_PARTIES; i++){
            try{
                assaultPartiesStub[i].shutdown();
            }catch(RemoteException e){
                System.out.println("Error shutting down assault party " + i + ": " + e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }
        }

        //control collection site shutdown
        try{
            controlCollectionSiteStub.shutdown();
        }catch(RemoteException e){
            System.out.println("Error shutting down control collection site: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        //concentration site shutdown
        try{
            concentrationSiteStub.shutdown();
        }catch(RemoteException e){
            System.out.println("Error shutting down concentration site: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        //general repository shutdown
        try{
            generalRepoStub.shutdown();
        }catch(RemoteException e){
            System.out.println("Error shutting down general repository: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
