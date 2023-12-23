package serverSide.sharedRegions;

import serverSide.main.*;
import clientSide.stub.*;
import serverSide.entities.MuseumClientProxy;

/**
 *  Museum (shared region)
 * 
 *  This class implements the Museum
 *  It is responsible to keep a continuous update of the number of paintings in the museum rooms
 */

public class Museum
{
    /**
    * Reference to the general repository 
    */
    private GeneralRepoStub repo;

    /**
    * Reference to the assault parties
    */
    private AssaultPartyStub[] assaultParties;

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
    public Museum (GeneralRepoStub repo, AssaultPartyStub[] assaultParties, int[] paintings) {
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
    public synchronized boolean rollACanvas(int assaultPartyID) {
        int thiefID = ((MuseumClientProxy) Thread.currentThread()).getThiefId();
        boolean hasCanvas;
        System.out.println("Thief " + thiefID + " from assault party " + assaultPartyID + " is trying to steal a canvas");
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
        if(rooms[assaultParties[assaultPartyID].getTargetRoom(1)] > 0) {
            rooms[assaultParties[assaultPartyID].getTargetRoom(1)]--;
            repo.changehasacanvas(thiefID, 1, assaultParties[assaultPartyID].getTargetRoom(1),assaultPartyID);           
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
        return hasCanvas;
    }

    /**
	 * Operation bar server shutdown
	 */
	public synchronized void shutdown()
	{
		shutdowns += 1;
		if(shutdowns >= SimulPar.MUSEUM_SHUTDOWN)
			ServerMuseum.waitConnection = false;
		notifyAll ();
	}

}