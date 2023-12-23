package entities;

import sharedRegions.*;

public class MasterThief extends Thread{
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
    *  Master Thief state
    */
    private int state;

    /**
    * Master Thief instantiation
    */
    public MasterThief(ControlCollectionSite CCS, ConcentrationSite CS, AssaultParty[] assaultParties, GeneralRepo repo) {
        super("Master_Thief");
        this.state = MasterThiefStates.PLANNING_THE_HEIST;

        this.controlCollectionSite = CCS;
        this.concentrationSite = CS;
        this.assaultParties = assaultParties;
        this.repo = repo;
    }

    /**
    * @param new state of the thief
    */ 
    public void setThiefState(int state) {
        this.state = state;
        repo.putMasterState(state);
    }

    /**
    * @return thief state
    */
    public int getThiefState() {
        return state;
    }

    @Override
    public void run(){
        char oper;
        controlCollectionSite.startOfOperation();
        while( (oper=controlCollectionSite.appraiseSit()) != 'E'){
            switch(oper){
                case 'P':
                    //(master -> bloqueia no site ou bloq no grupo de assalto especifico)
                    //(esta ops vai ter uma sub-op onde a master bloqueia o grupo de assalto)
                    //assParty[assPartyID].waitForOtherThievesToBeReady();
                    //assParty invoca fora do monitor (não é synchronized na assinatura mas no body sim)
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
