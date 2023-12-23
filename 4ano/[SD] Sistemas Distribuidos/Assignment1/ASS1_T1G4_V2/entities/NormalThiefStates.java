package entities;

/**
* Normal Thief States
*/
public class NormalThiefStates {
    /**
    * blocking state while thief isn't needed
    */
    public static final int CONCENTRATION_SITE = 0;

    /**
    * transition state while thief is crawling in
    */
    public static final int CRAWLING_INWARDS = 1;

    /**
    * transition state while thief is at the room
    */
    public static final int AT_A_ROOM = 2; 

    /**
    * transition state while thief is crawling out
    */ 
    public static final int CRAWLING_OUTWARDS = 3;

    /**
    * blocking state while thief is waiting for the master thief to collect the canvas
    */
    public static final int COLLECTION_SITE  = 4;
    

    /**
    * It cannot be instantiated
    */
    private NormalThiefStates() {}
    

}   
