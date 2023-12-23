package clientSide.entities;

import interfaces.*;
import java.rmi.RemoteException;

/**
 *    Master Thief thread.
 *
 *      It simulates the life cycle.
 *      Implementation of a client-server model of type 2 (server replication).
 *      Communication is based on remote calls under Java RMI.
 */
public class MasterThief extends Thread{
    /**
    * Reference to the Concentration Site
    */
    private ConcentrationSiteInterface concentrationSiteInter;

    /**
    * Reference to the Assault Parties
    */
    private AssaultPartyInterface[] assaultPartiesInter;

    /**
    * Reference to the Control Collection Site
    */
    private ControlCollectionSiteInterface controlCollectionSiteInter;
    
    /**
    *  Master Thief state
    */
    private int state;

    /**
    * Master Thief instantiation
    * @param CCS reference to the Control Collection Site
    * @param CS reference to the Concentration Site
    * @param assaultParties array with the assault parties
    */
    public MasterThief(ControlCollectionSiteInterface CCS, ConcentrationSiteInterface CS, AssaultPartyInterface[] assaultParties) {
        super("Master_Thief");
        state = MasterThiefStates.PLANNING_THE_HEIST;

        controlCollectionSiteInter = CCS;
        concentrationSiteInter = CS;
        assaultPartiesInter = assaultParties;
    }

    /**
    * Set the state of the master thief
    * @param state of the thief
    */ 
    public void setThiefState(int state) {
        this.state = state;
    }

    /**
    * Get the state of the master thief
    * @return master thief state
    */
    public int getThiefState() {
        return state;
    }

    /**
    * Master Thief life cycle
    */
    @Override
    public void run(){
        char oper;
        System.out.println("Starting operation");
        startOfOperation();
        while( (oper=appraiseSit()) != 'E'){
            switch(oper){
                case 'P':
                    int assaultPartyID = getAssaultPartyID();
                    int room = getRoomWithCanvasID();
                    prepareAssaultParty(assaultPartyID, room);
                    sendAssaultParty(assaultPartyID);
                    break;
                    
                case 'R':
                    takeARest();
                    collectACanvas();
                    break;
            }
        }
        System.out.println("Summing up results");
        sumUpResults(getCollectedCanvas());

    }

    /**
     * Operation start of operation
     * Remote operation
     * Master thief starts the heist
     */
    private void startOfOperation(){
        try{
            state = controlCollectionSiteInter.startOfOperation();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on startOfOperations: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Operation appraise situation
     * Remote operation
     * Master thief appraises the situation
     * @return character of the next operation
     */
    private char appraiseSit(){
        char decision = ' ';
        try{
            decision = controlCollectionSiteInter.appraiseSit();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on appraiseSit: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        //check if decision is valid (P or R or E)
        if(decision != 'P' && decision != 'R' && decision != 'E'){
            System.out.println("Master Thief invalid decision on appraiseSit: " + decision);
            System.exit(1);
        }
        return decision;
    }

    /**
     * Operation get assault party ID
     * Remote operation
     * Master thief tries to get available assault party ID
     * @return assault party ID
     */
    private int getAssaultPartyID(){
        int assaultPartyID = -1;
        try{
            assaultPartyID = controlCollectionSiteInter.getAssaultPartyID();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on getAssaultPartyID: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        //check if assaultPartyID is valid (0 or 1)
        if(assaultPartyID != 0 && assaultPartyID != 1){
            System.out.println("Master Thief invalid assaultPartyID on getAssaultPartyID: " + assaultPartyID);
            System.exit(1);
        }
        return assaultPartyID;
    }

    /**
     * Operation get room with canvas ID
     * Remote operation
     * Master thief tries to get room with canvas ID
     * @return room with canvas ID
     */
    private int getRoomWithCanvasID(){
        int roomWithCanvasID = -1;
        try{
            roomWithCanvasID = controlCollectionSiteInter.getRoomWithCanvasID();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on getRoomWithCanvasID: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        //check if roomWithCanvasID is valid (0 to 4)
        if(roomWithCanvasID < 0 || roomWithCanvasID > 4){
            System.out.println("Master Thief invalid roomWithCanvasID on getRoomWithCanvasID: " + roomWithCanvasID);
            System.exit(1);
        }
        return roomWithCanvasID;
    }

    /**
     * Operation prepare assault party
     * Remote operation
     * Master thief prepares the assault party, setting the target room and the ID of the assault party
     * @param assaultPartyID assault party ID
     * @param roomID target room ID
     */
    private void prepareAssaultParty(int assaultPartyID, int roomID){
        try{
            state = concentrationSiteInter.prepareAssaultParty(assaultPartyID, roomID);
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on prepareAssaultParty: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Operation send assault party
     * Remote operation
     * Master thief sends the assault party
     * @param assaultPartyID assault party ID
     */
    private void sendAssaultParty(int assaultPartyID){
        try{
            state = assaultPartiesInter[assaultPartyID].sendAssaultParty();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on sendAssaultParty: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Operation take a rest
     * Remote operation
     * Master thief takes a rest, waiting for the thieves to return
     */
    private void takeARest(){
        try{
            state = controlCollectionSiteInter.takeARest();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on takeARest: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Operation collect a canvas
     * Remote operation
     * Master thief collects a canvas from a thief
     */
    private void collectACanvas(){
        try{
            state = controlCollectionSiteInter.collectACanvas();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on collectACanvas: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Operation sum up results
     * Remote operation
     * Master thief sums up the results, waits for all thieves to exit the concentration site
     * @param collectedCanvas number of collected canvas
     */
    private void sumUpResults(int collectedCanvas){
        try{
            state = concentrationSiteInter.sumUpResults(collectedCanvas);
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on sumUpResults: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    /**
     * Operation get collected canvas
     * Remote operation
     * Master thief gets the number of the stolen canvas
     * @return number of collected canvas
     */
    private int getCollectedCanvas(){
        int collectedCanvas = -1;
        try{
            collectedCanvas = controlCollectionSiteInter.getCollectedCanvas();
        }catch(RemoteException e){
            System.out.println("Master Thief remote exception on getCollectedCanvas: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
        return collectedCanvas;
    }

}
