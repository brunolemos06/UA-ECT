package sharedRegions;

import main.*;
import entities.*;

/**
 *  Museum (shared region)
 * 
 *  This class implements the Museum
 *  It is responsible to keep a continuous update of the number of paintings in the museum rooms
 */

public class Museum
{
    /**
     * 
    */
    private GeneralRepo repo;

    /**
    * 
    */
    private AssaultParty[] assaultParties;

    /**
    * Number of paintings in each room (rooms[id] = number of paintings)
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
    * Museum instantiation
    */
    public Museum (GeneralRepo repo, AssaultParty[] assaultParties, int[] paintings) {
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
    * A canvas is stolen from a room  [if room[id] > 0: (rooms[id]--) else return false]
    * @param assaultPartyID assault party id
    * @return true if the canvas was stolen, false if there are no more paintings in the room
    */
    public synchronized boolean rollACanvas(int assaultPartyID) {
        int thiefID = ((NormalThief) Thread.currentThread()).getThiefId();
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
}