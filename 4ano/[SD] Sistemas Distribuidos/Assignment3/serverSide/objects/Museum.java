package serverSide.objects;

import java.rmi.RemoteException;

import serverSide.main.*;
import interfaces.*;

/**
 *  Museum (shared region)
 *  This class implements the Museum
 *  Public methods executed in mutual exclusion
 *  Implementation of a client-server model of type 2 (server replication).
 *  Communication is based on Java RMI.
 */
public class Museum implements MuseumInterface
{
    /**
    * Reference to the general repository 
    */
    private GeneralRepoInterface repo;

    /**
    * Reference to the assault parties
    */
    private AssaultPartyInterface[] assaultParties;

    /**
    * Number of paintings in each room, rooms[id] = number of paintings
    */
    private int[] rooms;

    /**
    * Preserves how many members of each assault party are ready to enter/leave the room
    */
    private int[] membersReady;

    /**
    * When the last member of the assault party is ready to enter/leave the room, the other members are woken up
    */
    private boolean[] lastMemberReady;

    /**
     * Number of shutdowns received
     */
    private int shutdowns = 0;

    /**
    * Museum instantiation
    * @param repo reference to the general repository
    * @param assaultParties array with the assault parties
    * @param paintings array with the number of paintings in each room, rooms[id] = number of paintings
    */
    public Museum (GeneralRepoInterface repo, AssaultPartyInterface[] assaultParties, int[] paintings) {
        this.repo = repo;
        this.assaultParties = assaultParties;
        rooms = paintings;
        membersReady = new int[SimulPar.N_PARTIES];
        lastMemberReady = new boolean[SimulPar.N_PARTIES];

        for(int i = 0; i < SimulPar.N_PARTIES; i++) {
            membersReady[i] = 0;
            lastMemberReady[i] = false;
        }
    }

    /**
    * A canvas is stolen from a room 
    * @param assaultPartyID assault party id
    * @return true if the canvas was stolen, false if there are no more paintings in the room
    */
    @Override
    public synchronized void rollACanvas(int thiefID, int assaultPartyID) throws RemoteException{
        boolean hasCanvas;
        if(membersReady[assaultPartyID] == (SimulPar.K-1)) {
            // Reset the number of members that are ready to leave the room
            // Wake up the other members of the assault party
            lastMemberReady[assaultPartyID] = true;
            membersReady[assaultPartyID] = 0;
            notifyAll();
        }else{
            membersReady[assaultPartyID]++;
            while(!lastMemberReady[assaultPartyID]){
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        // Steal if there are paintings in the room
        if(rooms[assaultParties[assaultPartyID].getTargetRoom()] > 0) {
            rooms[assaultParties[assaultPartyID].getTargetRoom()]--;
            repo.changehasacanvas(thiefID, 1, assaultParties[assaultPartyID].getTargetRoom(),assaultPartyID);           
            hasCanvas = true;
        }else {
            hasCanvas = false;
        }

        assaultParties[assaultPartyID].setHasCanvas(thiefID, hasCanvas);

        if(membersReady[assaultPartyID] == (SimulPar.K-1)) {
            lastMemberReady[assaultPartyID] = false;
            membersReady[assaultPartyID] = 0;
            notifyAll();
        }else{
            membersReady[assaultPartyID]++;
            while(lastMemberReady[assaultPartyID]){
                try {
                    wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
	 * Operation museum server shutdown
	 */
    @Override
	public synchronized void shutdown() throws RemoteException{
		shutdowns += 1;
		if(shutdowns >= SimulPar.MUSEUM_SHUTDOWN)
			ServerMuseum.shutdown();
	}

}