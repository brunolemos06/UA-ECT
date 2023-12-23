package entities;

import sharedRegions.*;

/**
* Normal Thief (entity)
* It is responsible to simulate the thief's life cycle
*/
public class NormalThief extends Thread{
    /**
    * Reference to the Concentration Site
    */
    private ConcentrationSite concentrationSite;

    /**
    * Reference to the Assault Parties
    */
    private AssaultParty[] assaultParties;

    /**
    * Reference to the Control Collection Site
    */
    private ControlCollectionSite controlCollectionSite;

    /**
    * Reference to the Museum
    */
    private Museum museum;

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
    public NormalThief(int ID, int agility, ControlCollectionSite CCS, ConcentrationSite CS, AssaultParty[] assaultParties, Museum museum) {
        super("Thief_" + ID);
        this.ID = ID;
        this.agility = agility;
        thiefState = NormalThiefStates.CONCENTRATION_SITE;

        controlCollectionSite = CCS;
        concentrationSite = CS;
        this.assaultParties = assaultParties;
        this.museum = museum;
    }

    /**
    * Thief life cycle
    */
    @Override
    public void run() {
        while ( concentrationSite.amINeeded() != false ) { 
            
            int assaultPartyID = concentrationSite.prepareExcursion();

            assaultParties[assaultPartyID].crawlIn();

            museum.rollACanvas(assaultPartyID);
            
            assaultParties[assaultPartyID].reverseDirection();
            assaultParties[assaultPartyID].crawlOut();
            
            controlCollectionSite.handACanvas(assaultPartyID);            
        }
    }

}
