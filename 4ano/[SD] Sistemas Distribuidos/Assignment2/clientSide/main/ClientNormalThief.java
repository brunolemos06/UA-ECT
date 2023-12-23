package clientSide.main;

import clientSide.entities.NormalThief;
import clientSide.stub.*;
import java.util.Random;

/**
*   Client Side of Normal Thief (entity)
*   Implementation of a client-server model of type 2 (server replication).
*	Communication is based on a communication channel under the TCP protocol.
*/
public class ClientNormalThief {
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
     * args[8] - name of platform where the museum is located
     * args[9] - port number where the museum is listening to service requests
     * args[10] - name of platform where the general repo is located
     * args[11] - port number where the general repo is listening to service requests
     */
    public static void main(String[] args){
        NormalThief[] thiefs;      // Thief Thread
        ConcentrationSiteStub concentrationSite; // Concentration Site Stub
        ControlCollectionSiteStub controlCollectionSite; // Control Collection Site Stub
        AssaultPartyStub[] assaultParties; // Assault Parties Stubs
        MuseumStub museum; // Museum Stub
        GeneralRepoStub repo; // General Repository Stub

        Random rand = new Random();

        if(args.length != 12) {
            System.out.println("Wrong number of arguments!");
            System.exit(1);
        }

        //check port numbers and check if they are between 22130 - 22139
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
        museum = new MuseumStub(args[8], Integer.parseInt(args[9]));
        repo = new GeneralRepoStub(args[10], Integer.parseInt(args[11]));

        System.out.println("Launching Normal Thief Threads");

        
        int [] thiefAgility = new int[6];
        thiefs = new NormalThief[6];
        for(int i=0; i<6; i++) {
            thiefAgility[i] = rand.nextInt(6-2+1)+2;
            thiefs[i] = new NormalThief(i, thiefAgility[i], controlCollectionSite, concentrationSite, assaultParties, museum);
        }

        //send agility to repo
        repo.setAgility(thiefAgility);
        //repo.header();

        for(int i=0; i<6; i++) {
            thiefs[i].start();
        }

        for(int i=0; i<6; i++) {
            try {
                thiefs[i].join();
            } catch (InterruptedException e) {}
            System.out.println("Thief Thread " + i + " has terminated!");
        }
        
        System.out.println("Thief Thread has terminated!");
        museum.shutdown();
        assaultParties[0].shutdown();
        assaultParties[1].shutdown();
        controlCollectionSite.shutdown();
        concentrationSite.shutdown();
        repo.shutdown();
    }
}
