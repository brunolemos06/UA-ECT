package clientSide.entities;

import clientSide.stub.*;

/**
* Normal Thief (entity)
* It is responsible to simulate the thief's life cycle
*/
public class NormalThief extends Thread{
    /**
    * Reference to the Concentration Site
    */
    private ConcentrationSiteStub concentrationSiteStub;

    /**
    * Reference to the Assault Parties
    */
    private AssaultPartyStub[] assaultPartiesStub;

    /**
    * Reference to the Control Collection Site
    */
    private ControlCollectionSiteStub controlCollectionSiteStub;

    /**
    * Reference to the Museum
    */
    private MuseumStub museumStub;

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
    public NormalThief(int ID, int agility, ControlCollectionSiteStub CCS, ConcentrationSiteStub CS, AssaultPartyStub[] assaultParties, MuseumStub museum) {
        super("Thief_" + ID);
        this.ID = ID;
        this.agility = agility;
        thiefState = NormalThiefStates.CONCENTRATION_SITE;

        controlCollectionSiteStub = CCS;
        concentrationSiteStub = CS;
        assaultPartiesStub = assaultParties;
        museumStub = museum;
    }

    /**
    * Thief life cycle
    */
    @Override
    public void run() {
        System.out.println("Thief_" + ID + " started!");
        while ( concentrationSiteStub.amINeeded() != false ) { 
            int assaultPartyID = concentrationSiteStub.prepareExcursion();
            System.out.println("Thief_" + ID + " is going to assaultParty_" + assaultPartyID + "!");

            assaultPartiesStub[assaultPartyID].crawlIn();
            System.out.println("Thief_" + ID + " is crawling in assaultParty_" + assaultPartyID + "!");

            museumStub.rollACanvas(assaultPartyID);
            System.out.println("Thief_" + ID + " is rolling a canvas in assaultParty_" + assaultPartyID + "!");
            
            assaultPartiesStub[assaultPartyID].reverseDirection();
            System.out.println("Thief_" + ID + " is reversing direction in assaultParty_" + assaultPartyID + "!");
            assaultPartiesStub[assaultPartyID].crawlOut();
            System.out.println("Thief_" + ID + " is crawling out in assaultParty_" + assaultPartyID + "!");
            
            controlCollectionSiteStub.handACanvas(assaultPartyID);          
            System.out.println("Thief_" + ID + " is handing a canvas in assaultParty_" + assaultPartyID + "!");  
        }
        System.out.println("Thief_" + ID + " is going home!");
    }

}
