package entities;

import sharedRegions.*;

/**
* Master Thief (entity)
*  It is responsible to control the operation of the heist
*/
public class MasterThief extends Thread{
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
    *  Master Thief state
    */
    private int state;

    /**
    * Master Thief instantiation
    * @param CCS reference to the Control Collection Site
    * @param CS reference to the Concentration Site
    * @param assaultParties array with the assault parties
    * @param repo reference to the general repository
    */
    public MasterThief(ControlCollectionSite CCS, ConcentrationSite CS, AssaultParty[] assaultParties) {
        super("Master_Thief");
        this.state = MasterThiefStates.PLANNING_THE_HEIST;

        this.controlCollectionSite = CCS;
        this.concentrationSite = CS;
        this.assaultParties = assaultParties;
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
        controlCollectionSite.startOfOperation();
        while( (oper=controlCollectionSite.appraiseSit()) != 'E'){
            switch(oper){
                case 'P':
                    int assaultPartyID = controlCollectionSite.getAssaultPartyID();
                    concentrationSite.prepareAssaultParty(assaultPartyID, controlCollectionSite.getRoomWithCanvasID());
                    assaultParties[assaultPartyID].sendAssaultParty();
                    break;
                    
                case 'R':
                    controlCollectionSite.takeARest();
                    controlCollectionSite.collectACanvas();
                    break;
            }
        }
        concentrationSite.sumUpResults(controlCollectionSite.getCollectedCanvas());

    }
    
}
