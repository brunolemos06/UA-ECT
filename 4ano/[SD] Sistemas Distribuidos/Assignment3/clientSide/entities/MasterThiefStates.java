package clientSide.entities;

/**
* Master Thief States
*/
public class MasterThiefStates {
    /**
    * Initial state 
    */
    public static final int PLANNING_THE_HEIST=0;

    /**
    * transitional state 
    */
    public static final int DECIDING_WHAT_TO_DO=1;

    /**
    * blocking state the master thiefs assembles a group 
    */
    public static final int ASSEMBLING_GROUP=2;

    /**
    * blocking state the master thief is waken up by the handACanvas 
    */
    public static final int WAITING_FOR_ARRIVAL=3;

    /**
    * final state the master thief presents the other thiefs the results
    */
    public static final int PRESENTING_THE_REPORT=4;

    /**
    * Can't be instanciated
    */
    private MasterThiefStates() {} 
}
