package clientSide.main;

import interfaces.*;
import clientSide.entities.*;
import java.rmi.registry.*;
import java.rmi.*;

/**
 *    Client side of the Master Thief
 *
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on Java RMI.
 */
public class ClientMasterThief {
    
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

        ConcentrationSiteInterface concentrationSiteStub = null;                   // remote reference to the concentration site object
        ControlCollectionSiteInterface controlCollectionSiteStub = null;           // remote reference to the control collection site object
        AssaultPartyInterface[] assaultPartiesStub = new AssaultPartyInterface[2]; // remote reference to the assault party objects

        Registry registry = null;   // remote reference for registration in the RMI registry service

        MasterThief masterThief;    // master thief thread

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

        // Assault Party 0
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

        // Assault Party 1
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

        //initialize the master thief
        masterThief = new MasterThief(controlCollectionSiteStub, concentrationSiteStub, assaultPartiesStub);

        //start the master thief
        masterThief.start();

        //wait for the master thief to end
        try{
            masterThief.join();
        }catch(InterruptedException e){}

        System.out.println("The master thief thread has terminated.");

        //assault parties shutdown
        for(int i = 0; i < 2; i++){
            try{
                assaultPartiesStub[i].shutdown();
            }catch(RemoteException e){
                System.out.println("Master Thief Client remote exception on Assault Party shutdown: " + e.getMessage());
                e.printStackTrace();
                System.exit(1);
            }
        }

        //control collection site shutdown
        try{
            controlCollectionSiteStub.shutdown();
        }catch(RemoteException e){
            System.out.println("Master Thief Client remote exception on Control Collection Site shutdown: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }

        //concentration site shutdown
        try{
            concentrationSiteStub.shutdown();
        }catch(RemoteException e){
            System.out.println("Master Thief Client remote exception on Concentration Site shutdown: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        







    }

}
