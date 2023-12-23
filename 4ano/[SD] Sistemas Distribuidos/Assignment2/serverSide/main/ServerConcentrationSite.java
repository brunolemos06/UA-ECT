package serverSide.main;

import serverSide.entities.*;
import serverSide.sharedRegions.*;
import clientSide.stub.*;
import commInfra.*;

import java.net.*;
import java.util.Random;    // to generate random numbers

/**
 * Server side of ConcentrationSite
 * 
 *  Implementation of a client-server model of type 2 (server replication).
 *  Communication is based on a communication channel under the TCP protocol.
 */

public class ServerConcentrationSite {
/**
     * Flag signaling the service is active.
     */

     public static boolean waitConnection;

    /**
     *  Main method.
     *
     *    @param args runtime arguments
    *        args[0] - port number for listening to service requests
    *        args[1] - name of the platform where is located the server for the general repository
    *        args[2] - port number where the server for the general repository is listening to service requests
    *        args[3] - name of the platform where is located the server for the assault party 1
    *        args[4] - port number where the server for the assault party 1 is listening to service requests
    *        args[5] - name of the platform where is located the server for the assault party 2
     *       args[6] - port number where the server for the assault party 2 is listening to service requests
     * 
     */

     public static void main(String [] args){
        ServerCom scon, sconi;                              // communication channels

        GeneralRepoStub reposStub;                              // stub for accessing the general repository
        AssaultPartyStub[] partyStub = new AssaultPartyStub[SimulPar.N_PARTIES]; // stub for accessing the assault parties

        ConcentrationSite concentrationSite;                // concentration site
        ConcentrationSiteInterface concentrationSiteInter;  // interface to the concentration site


        // check args, ports must be between 22130 and 22139
        if(args.length != 7){
            System.out.println("Wrong number of parameters!");
            System.exit(1);
        }

        int portNumb = -1;
        try{
            portNumb = Integer.parseInt(args[0]);
            if((portNumb < 22130) || (portNumb > 22139)){
                System.out.println("args[0] is not a valid port number!");
                System.exit(1);
            }
        }catch(NumberFormatException e){
            System.out.println("args[0] is not a number!");
            System.exit(1);
        }

        int resposPortNumb = -1;
        try{
            resposPortNumb = Integer.parseInt(args[2]);
            if((resposPortNumb < 22130) || (resposPortNumb > 22139)){
                System.out.println("args[2] is not a valid port number!");
                System.exit(1);
            }  
        }catch(NumberFormatException e){
            System.out.println("args[2] is not a number!");
            System.exit(1);
        }

        int party1PortNumb = -1;
        try{
            party1PortNumb = Integer.parseInt(args[4]);
            if((party1PortNumb < 22130) || (party1PortNumb > 22139)){
                System.out.println("args[4] is not a valid port number!");
                System.exit(1);
            }
        }catch(NumberFormatException e){
            System.out.println("args[4] is not a number!");
            System.exit(1);
        }

        int party2PortNumb = -1;
        try{
            party2PortNumb = Integer.parseInt(args[6]);
            if((party2PortNumb < 22130) || (party2PortNumb > 22139)){
                System.out.println("args[6] is not a valid port number!");
                System.exit(1);
            }
        }catch(NumberFormatException e){
            System.out.println("args[6] is not a number!");
            System.exit(1);
        }

        Random rand = new Random();
        int[] roomDistance = new int[SimulPar.N];
        for (int i = 0; i < roomDistance.length; i++) {
            roomDistance[i] = rand.nextInt(30-15+1) + 15;
        }
        

        /* service is established */
        scon = new ServerCom(portNumb);
        reposStub = new GeneralRepoStub(args[1], resposPortNumb);
        //send room distance to repo
        reposStub.setRoomsDistance(roomDistance);
        partyStub[0] = new AssaultPartyStub(args[3], party1PortNumb);
        partyStub[1] = new AssaultPartyStub(args[5], party2PortNumb);

        concentrationSite = new ConcentrationSite(partyStub, roomDistance, reposStub);
        concentrationSiteInter = new ConcentrationSiteInterface(concentrationSite);
        
        scon.start();
        System.out.println("Service is established!");
        System.out.println("Server is listening for service requests.");

        /* service request processing */

        ConcentrationSiteClientProxy cliProxy;
        waitConnection = true;
        while (waitConnection){
            try{
                sconi = scon.accept();
                cliProxy = new ConcentrationSiteClientProxy(sconi, concentrationSiteInter);
                cliProxy.start();
            }catch(SocketTimeoutException e){}
        }
        scon.end();
        System.out.println("Server ConcentrationSite was shutdown!");

     }
}
