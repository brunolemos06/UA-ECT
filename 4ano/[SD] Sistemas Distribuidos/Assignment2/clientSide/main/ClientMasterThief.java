package clientSide.main;

import clientSide.entities.MasterThief;
import clientSide.stub.*;

/**
*   Client Side of Master Thief (entity)
*   Implementation of a client-server model of type 2 (server replication).
*	Communication is based on a communication channel under the TCP protocol.
*/
public class ClientMasterThief {
    /**
     * Main Method
     * 
     * @param args runtime arguments
     * args[0] - name of platform where the concentration site is located
     * args[1] - port number where the concentration site is listening to service requests
     * args[2] - name of platform where the control/collection site is located
     * args[3] - port number where the control/collection site is listening to service requests
     * args[4] - name of platform where the assault party #1 is located
     * args[5] - port number where the assault party #1 is listening to service requests
     * args[6] - name of platform where the assault party #2 is located
     * args[7] - port number where the assault party #2 is listening to service requests
     */    
    public static void main(String[] args) {
        MasterThief master;     // Master Thief Thread
        ConcentrationSiteStub concentrationSite; // Concentration Site Stub
        ControlCollectionSiteStub controlCollectionSite; // Control Collection Site Stub
        AssaultPartyStub[] assaultParties; // Assault Parties Stubs

        if(args.length != 8) {
            System.out.println("Wrong number of arguments!");
            System.exit(1);
        }

        //check port numbers and check if they are between 22130 - 21139
        for(int i = 1; i < args.length; i+=2) {
            try {
                int port = Integer.parseInt(args[i]);
                if(port < 22130 || port > 22139) {
                    System.out.println("Invalid port number: " + port + "!");
                    System.exit(1);
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid port number: " + args[i] + "!");
                System.exit(1);
            }
        }

        concentrationSite = new ConcentrationSiteStub(args[0], Integer.parseInt(args[1]));
        controlCollectionSite = new ControlCollectionSiteStub(args[2], Integer.parseInt(args[3]));
        assaultParties = new AssaultPartyStub[2];
        assaultParties[0] = new AssaultPartyStub(args[4], Integer.parseInt(args[5]));
        assaultParties[1] = new AssaultPartyStub(args[6], Integer.parseInt(args[7]));

        System.out.println("Launching Master Thief Thread");
        master = new MasterThief(controlCollectionSite, concentrationSite, assaultParties);
        master.start();

        try{
            master.join();
        } catch (InterruptedException e) {
            System.out.println("Master Thief Thread was interrupted!");
            System.exit(1);
        }

        System.out.println("Master Thief Thread has finished!");

        for(int i = 0; i < assaultParties.length; i++) {
            assaultParties[i].shutdown();
        }
        controlCollectionSite.shutdown();
        concentrationSite.shutdown();

    }
}

