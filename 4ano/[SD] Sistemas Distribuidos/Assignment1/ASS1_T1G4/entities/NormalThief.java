package entities;

import sharedRegions.*;

public class NormalThief extends Thread{

    /**
    * 
    */
    private GeneralRepo repo;

    /**
    * 
    */
    private ConcentrationSite concentrationSite;

    /**
    * 
    */
    private AssaultParty[] assaultParties;

    /**
    * 
    */
    private ControlCollectionSite controlCollectionSite;

    /**
    * 
    */
    private Museum museum;

    /**
    * Thief ID
    */
    private int ID;

    /**
    * crawling
    */
    private int crawling = 0;
    
    /**
    * Thief state
    */
    private int thiefState;

    /**
    * Thief assault group ID
    */
    private int assaultPartyID;

    /**
    * Thief target room ID
    */
    private int targetRoomID;

    /**
    * Thief maximum displacement between other thieves
    */
    private int agility;

    /**
    * If the thief as a canvas
    */
    private boolean hasCanvas;

    /**
    * @param new state of the thief
    */ 
    public void setThiefState(int thiefState) {
        this.thiefState = thiefState;
        repo.putThiefState(thiefState, ID);
    }

    /**
    * @return thief state
    */
    public int getThiefState() {
        return thiefState;
    }

    /**
    * @return agliity
    */
    public int getAgility() {
        return agility;
    }

    /**
    * @return thief ID
    */
    public int getThiefId() {
        return ID;
    }

    /**
     * @return crawling
     */
    public int getCrawling() {
        return crawling;
    }

    /**
     * @return get crawling
     */
    public void setCrawling(int v){
        this.crawling = v;
    }

    /**
    * @return thief assault group ID
    */ 
    public int getAssaultPartyID() {
        return assaultPartyID;
    }

    public void setAssaultPartyID(int assaultPartyID) {
        this.assaultPartyID = assaultPartyID;
    }

    public int getTargetRoomID(){
        return targetRoomID;
    }

    public void setTargetRoomID(int targetRoomID){
        this.targetRoomID = targetRoomID;
    }

    public void setHasCanvas(boolean hasCanvas) {
        this.hasCanvas = hasCanvas;
    }

    public boolean getHasCanvas() {
        return hasCanvas;
    }

    /**
    * Thief instantiation
    * @param ID
    * @param agility
    */
    public NormalThief(int ID, int agility, ControlCollectionSite CCS, ConcentrationSite CS, AssaultParty[] assaultParties, GeneralRepo repo, Museum museum) {
        super("Thief_" + ID);
        this.ID = ID;
        this.agility = agility;
        this.thiefState = NormalThiefStates.CONCENTRATION_SITE;

        this.hasCanvas = false;
        this.assaultPartyID = -1;
        this.targetRoomID = -1;
        this.crawling = 0;

        this.controlCollectionSite = CCS;
        this.concentrationSite = CS;
        this.assaultParties = assaultParties;
        this.repo = repo;
        this.museum = museum;
    }

    @Override
    public void run() {
        while ( concentrationSite.amINeeded() != false ) { 
            
            this.assaultPartyID = concentrationSite.prepareExcursion();

            assaultParties[assaultPartyID].crawlIn();

            this.hasCanvas = museum.rollACanvas(this.assaultPartyID);
            
            assaultParties[assaultPartyID].reverseDirection();
            assaultParties[assaultPartyID].crawlOut();
            
            controlCollectionSite.handACanvas(assaultPartyID);            
        }
    }

}