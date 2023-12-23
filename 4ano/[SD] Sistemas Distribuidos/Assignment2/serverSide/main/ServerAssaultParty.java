package serverSide.main;

import serverSide.entities.*;
import serverSide.sharedRegions.*;
import clientSide.stub.*;
import commInfra.*;
import java.net.*;

/**
 * Server side of AssaultParty
 * 
 *  Implementation of a client-server model of type 2 (server replication).
 *  Communication is based on a communication channel under the TCP protocol.
 */
public class ServerAssaultParty {
    /**
     * Flag signaling the service is active.
     */

     public static boolean waitConnection;

    /**
     *  Main method.
     *
     *    @param args runtime arguments
     *       args[0] - port number for listening to service requests
     *       args[1] - name of the platform where is located the server for the general repository
     *       args[2] - port number where the server for the general repository is listening to service requests
     *       args[3] - id of the assault party
     */

     public static void main(String [] args){
        ServerCom scon, sconi;                           // communication channels
        
        GeneralRepoStub reposStub;                       // stub for accessing the general repository
        
        AssaultParty assaultParty;                       // assault party
        AssaultPartyInterface assaultPartyInter;         // interface to the assault party


        // check args, ports must be between 22130 and 22139
        if(args.length != 4){
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

        int reposPortNumb = -1;
        try{
            reposPortNumb = Integer.parseInt(args[2]);
            if((reposPortNumb < 22130) || (reposPortNumb > 22139)){
                System.out.println("args[2] is not a valid port number!");
                System.exit(1);
            }
        }catch(NumberFormatException e){
            System.out.println("args[2] is not a number!");
            System.exit(1);
        }

        //id must be 0 or 1
        if(!args[3].equals("0") && !args[3].equals("1")){
            System.out.println("args[3] is not a valid id!");
            System.exit(1);
        }

        /* service is established */
        scon = new ServerCom(portNumb);

        reposStub = new GeneralRepoStub(args[1], reposPortNumb);

        assaultParty = new AssaultParty(Integer.parseInt(args[3]),reposStub);
        assaultPartyInter = new AssaultPartyInterface(assaultParty);

        scon.start();
        System.out.println("AssaultParty is established!");
        System.out.println("Server is listening for service requests.");

        /* service request processing */

        AssaultPartyClientProxy cliProxy;
        waitConnection = true;
        while (waitConnection){
            try{
                sconi = scon.accept();
                cliProxy = new AssaultPartyClientProxy(sconi, assaultPartyInter);
                cliProxy.start();
            }catch(SocketTimeoutException e){}
        }
        scon.end();
        System.out.println("Server AssaultParty was shutdown!");

     }
}
