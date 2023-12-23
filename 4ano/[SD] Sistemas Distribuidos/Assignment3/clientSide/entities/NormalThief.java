package clientSide.entities;

import interfaces.*;
import java.rmi.RemoteException;

/**
 *    Normal Thief thread.
 *
 *      It simulates the life cycle.
 *      Implementation of a client-server model of type 2 (server replication).
 *      Communication is based on remote calls under Java RMI.
 */
public class NormalThief extends Thread{
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
    * Reference to the Museum
    */
    private MuseumInterface museumInter;

    /**
    * Thief ID
    */
    private int ID;

    
    /**
    * Thief state
    */
    private int thiefState;

    /**
    * Thief maximum displacement between other thieves
    */
    private int agility;

    /**
    * Set the thief state 
    * @param thiefState of the thief
    */ 
    public void setThiefState(int thiefState) {
        this.thiefState = thiefState;
    }

    /**
    * Returns the thief state
    * @return thief state
    */
    public int getThiefState() {
        return thiefState;
    }

    /**
    * Returns the thief agility
    * @return agliity
    */
    public int getAgility() {
        return agility;
    }

    /**
    * Returns the thief ID
    * @return thief ID
    */
    public int getThiefId() {
        return ID;
    }

    /**
    * Thief instantiation
    * @param ID thief ID
    * @param agility thief agility
    * @param CCS reference to the Control Collection Site
    * @param CS reference to the Concentration Site
    * @param assaultParties array with the assault parties
    * @param museum reference to the museum
    */
    public NormalThief(int ID, int agility, ControlCollectionSiteInterface CCS, ConcentrationSiteInterface CS, AssaultPartyInterface[] assaultParties, MuseumInterface museum) {
        super("Thief_" + ID);
        this.ID = ID;
        this.agility = agility;
        thiefState = NormalThiefStates.CONCENTRATION_SITE;

        controlCollectionSiteInter = CCS;
        concentrationSiteInter = CS;
        assaultPartiesInter = assaultParties;
        museumInter = museum;
    }

    /**
    * Thief life cycle
    */
    @Override
    public void run() {
        System.out.println("Thief_" + ID + " started!");
        while ( amINeeded() != false ) { 
            int assaultPartyID = prepareExcursion();

            crawlIn(assaultPartyID);

            rollACanvas(assaultPartyID);
            
            reverseDirection(assaultPartyID);
            crawlOut(assaultPartyID);
            
            handACanvas(assaultPartyID);          
        }
    }

    /**
     * Operation am I needed
     * Remote operation.
     * Normal Thief checks if he is needed or not
     * @return true if he is needed, false if not
     */
    private boolean amINeeded(){
        ReturnBoolean result = null;
        try {
            result = concentrationSiteInter.amINeeded(ID);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }
        thiefState = result.getIntStateVal();
        return result.getBooleanVal();
    }

    /**
     * Operation prepareExcursion
     * Remote operation.
     * Normal Thief prepares the excursion, changing his state to crawling inwards
     * @return assault party ID
     */
    private int prepareExcursion(){
        ReturnInt returnInt = null;
        try {
            returnInt = concentrationSiteInter.prepareExcursion(ID);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }

        //check if the assault party ID is valid (0 or 1)
        if(returnInt.getIntVal() < 0 || returnInt.getIntVal() > 1){
            System.err.println("Invalid assault party ID: " + returnInt.getIntVal());
            System.exit(1);
        }
        thiefState = returnInt.getIntStateVal();
        return returnInt.getIntVal();
    }

    /**
     * Operation crawlIn
     * Remote operation.
     * Normal Thief crawls in to the target room of the Museum
     * @param assaultPartyID assault party ID
     */
    private void crawlIn(int assaultPartyID){
        try {
            thiefState = assaultPartiesInter[assaultPartyID].crawlIn(ID, agility);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Operation rollACanvas
     * Remote operation.
     * Normal Thief rolls a canvas from the room
     * @param assaultPartyID assault party ID
     */
    private void rollACanvas(int assaultPartyID){
        try {
            museumInter.rollACanvas(ID, assaultPartyID);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Operation reverseDirection
     * Remote operation.
     * Normal Thief reverses direction, going out of the Museum
     * @param assaultPartyID assault party ID
     */
    public void reverseDirection(int assaultPartyID){
        try {
            thiefState = assaultPartiesInter[assaultPartyID].reverseDirection(ID);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Operation crawl out
     * Remote operation.
     * Normal Thief crawls out of the Museum
     * @param assaultPartyID assault party ID
     */
    public void crawlOut(int assaultPartyID){
        try {
            thiefState = assaultPartiesInter[assaultPartyID].crawlOut(ID, agility);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }
    }

    /**
     * Operation handACanvas
     * Remote operation.
     * Normal Thief hands a canvas to the Master Thief
     * @param assaultPartyID assault party ID
     */
    public void handACanvas(int assaultPartyID){
        try {
            controlCollectionSiteInter.handACanvas(ID, assaultPartyID);
        } catch (RemoteException e) {
            System.out.println("Remote exception: " + e.getMessage());
            System.exit(1);
        }
    }

}
