package serverSide.main;

/**
* Simulation parameters
*/
public class SimulPar {
    /**
    * Number of thieves
    */ 
    public static final int M = 7;

    /** 
    * Number of party members 
    */
    public static final int K = 3;

    /** 
    * Number of rooms in the museum 
    */
    public static final int N = 5;

    /**
    * Number of parties
    */ 
    public static final int N_PARTIES = 2; 

    /**
     * Number of entities that request the shutdown of the general repository (normal thief)
     */
    public static final int REPO_SHUTDOWN = 1;

    /**
     * Number of entities that request the shutdown of the AssaultParty (master thief + normal thief)
     */
    public static final int ASSAULTPARTY_SHUTDOWN = 2;

    /**
     * Number of entities that request the shutdown of the ConcentrationSite (master thief + normal thief)
     */
    public static final int CONCENTRATIONSITE_SHUTDOWN = 2;

    /**
     * Number of entities that request the shutdown of the ControlCollectionSite (master thief + normal thief)
     */
    public static final int CONTROL_COLLECTION_SITE_SHUTDOWN = 2;

    /**
     * Number of entities that request the shutdown of the Museum (normal thief)
     */
    public static final int MUSEUM_SHUTDOWN = 1;

    /**
    * Can't be instantiated
    */ 
    private SimulPar() {}
}
