package clientSide.entities;

import clientSide.stub.*;

/**
*  Master Thief (entity)
*  It simulates the master thief life cycle.
*  It is responsible to control the operation of the heist
*/
public class MasterThief extends Thread{
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
    *  Master Thief state
    */
    private int state;

    /**
    * Master Thief instantiation
    * @param CCS reference to the Control Collection Site
    * @param CS reference to the Concentration Site
    * @param assaultParties array with the assault parties
    */
    public MasterThief(ControlCollectionSiteStub CCS, ConcentrationSiteStub CS, AssaultPartyStub[] assaultParties) {
        super("Master_Thief");
        state = MasterThiefStates.PLANNING_THE_HEIST;

        controlCollectionSiteStub = CCS;
        concentrationSiteStub = CS;
        assaultPartiesStub = assaultParties;
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
        controlCollectionSiteStub.startOfOperation();
        while( (oper=controlCollectionSiteStub.appraiseSit()) != 'E'){
            switch(oper){
                case 'P':
                    System.out.println("Sending Assault Party");
                    int assaultPartyID = controlCollectionSiteStub.getAssaultPartyID();
                    int room = controlCollectionSiteStub.getRoomWithCanvasID();
                    concentrationSiteStub.prepareAssaultParty(assaultPartyID, room);
                    assaultPartiesStub[assaultPartyID].sendAssaultParty();
                    break;
                    
                case 'R':
                    System.out.println("Taking a rest");
                    controlCollectionSiteStub.takeARest();
                    controlCollectionSiteStub.collectACanvas();
                    break;
            }
        }
        System.out.println("Summing up results");
        concentrationSiteStub.sumUpResults(controlCollectionSiteStub.getCollectedCanvas());

    }
    
}
