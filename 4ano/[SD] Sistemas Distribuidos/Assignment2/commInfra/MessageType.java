package commInfra;

/**
 *   Type of the exchanged messages.
 *   Implementation of a client-server model of type 2 (server replication).
 *   Communication is based on a communication channel under the TCP protocol.
 */
public class MessageType {

    /* CONTROL/COLLECTION INPUT/OUTPUT MESSAGES */

    /**
     *   Master Thief - Operation get assembling assault party id  (REQUEST)
     */
    public static final int REQ_GET_ASSEMBLING_ASSAULT_PARTY_ID = 1;

    /**
     *   Master Thief - Operation get assembling assault party id  (REPLY)
     */
    public static final int REP_GET_ASSEMBLING_ASSAULT_PARTY_ID = 2;

    /**
     *   Master Thief - Operation get room with canvas  (REQUEST)
     */
    public static final int REQ_GET_ROOM_WITH_CANVAS = 3;

    /**
     *   Master Thief - Operation get room with canvas  (REPLY)
     */
    public static final int REP_GET_ROOM_WITH_CANVAS = 4;

    /**
     *   Master Thief - Operation get total number of collected canvas  (REQUEST)
     */
    public static final int REQ_GET_TOTAL_COLLECTED_CANVAS = 5;

    /**
     *   Master Thief - Operation get total number of collected canvas  (REPLY)
     */
    public static final int REP_GET_TOTAL_COLLECTED_CANVAS = 6;

    /**
     *   Master Thief - Operation start operation  (REQUEST)
     */
    public static final int REQ_START_OPERATION = 7;

    /**
     *   Master Thief - Operation start operation  (REPLY)
     */
    public static final int REP_START_OPERATION = 8;

    /**
     *   Master Thief - Operation appraise sit  (REQUEST)
     */
    public static final int REQ_APPRAISE_SIT = 9;

    /**
     *   Master Thief - Operation appraise sit  (REPLY)
     */
    public static final int REP_APPRAISE_SIT = 10;

    /**
     *   Master Thief - Operation waits for thieves to arrive from museum  (REQUEST)
     */
    public static final int REQ_TAKE_A_REST = 11;

    /**
     *   Master Thief - Operation waits for thieves to arrive from museum  (REPLY)
     */
    public static final int REP_TAKE_A_REST = 12;

    /**
     *   Master Thief - Operation collect a canvas  (REQUEST)
     */
    public static final int REQ_COLLECT_CANVAS = 13;

    /**
     *   Master Thief - Operation collect a canvas  (REPLY)
     */
    public static final int REP_COLLECT_CANVAS = 14;

    /**
     *  Normal Thief - Operation hand a canvas  (REQUEST)
     */
    public static final int REQ_HAND_CANVAS = 15;

    /**
     *  Normal Thief - Operation hand a canvas  (REPLY)
     */
    public static final int REP_HAND_CANVAS = 16;



    /* CONCENTRATION INPUT/OUTPUT MESSAGES */

    /**
     * Maser Thief - Operation prepare assault party  (REQUEST)
     */
    public static final int REQ_PREPARE_ASSAULT_PARTY = 17;

    /**
     * Maser Thief - Operation prepare assault party  (REPLY)
     */
    public static final int REP_PREPARE_ASSAULT_PARTY = 18;

    /**
     * Normal Thief - Operation prepare excursion  (REQUEST)
     */
    public static final int REQ_PREPARE_EXCURSION = 45;

    /**
     * Normal Thief - Operation prepare excursion  (REPLY)
     */
    public static final int REP_PREPARE_EXCURSION = 46;

    /**
     * Normal Thief . Operation am i needed  (REQUEST)
     */
    public static final int REQ_AM_I_NEEDED = 47;

    /**
     * Normal Thief . Operation am i needed  (REPLY)
     */
    public static final int REP_AM_I_NEEDED = 48;

    /**
     * Master Thief - Operation sum up results  (REQUEST)
     */
    public static final int REQ_SUM_UP_RESULTS = 49;

    /**
     * Master Thief - Operation sum up results  (REPLY)
     */
    public static final int REP_SUM_UP_RESULTS = 50;



    /* ASSAULT PARTY INPUT/OUTPUT MESSAGES */

    /**
     * Normal Thief - Operation get canvas  (REQUEST)
     */
    public static final int REQ_GET_HAS_CANVAS = 19;

    /**
     * Normal Thief - Operation get canvas  (REPLY)
     */
    public static final int REP_GET_HAS_CANVAS = 20;

    /**
     * Normal Thief - Operation set canvas  (REQUEST)
     */
    public static final int REQ_SET_HAS_CANVAS = 21;

    /**
     * Normal Thief - Operation set canvas  (REPLY)
     */
    public static final int REP_SET_HAS_CANVAS = 22;

    /**
     * Normal Thief - Operation get room distance  (REQUEST)
     */
    public static final int REQ_GET_ROOM_DISTANCE = 23;

    /**
     * Normal Thief - Operation get room distance  (REPLY)
     */
    public static final int REP_GET_ROOM_DISTANCE = 24;

    /**
     * Normal Thief - Operation get target room ID  (REQUEST)
     */
    public static final int REQ_GET_TARGET_ROOM_ID = 25;

    /**
     * Normal Thief - Operation get target room ID  (REPLY)
     */
    public static final int REP_GET_TARGET_ROOM_ID = 26;

    /**
     * Master Thief - Operation set assault party ID  (REQUEST)
     */
    public static final int REQ_SET_ASSAULT_PARTY_ID = 27;

    /**
     * Master Thief - Operation set assault party ID  (REPLY)
     */
    public static final int REP_SET_ASSAULT_PARTY_ID = 28;

    /**
     * Master Thief - Operation set target room ID  (REQUEST)
     */
    public static final int REQ_SET_TARGET_ROOM_ID = 29;

    /**
     * Master Thief - Operation set target room ID  (REPLY)
     */
    public static final int REP_SET_TARGET_ROOM_ID = 30;

    /**
     * Master Thief - Operation set room distance  (REQUEST)
     */
    public static final int REQ_SET_TARGET_ROOM_DISTANCE = 31;

    /**
     * Master Thief - Operation set room distance  (REPLY)
     */
    public static final int REP_SET_TARGET_ROOM_DISTANCE = 32;

    /**
     * Normal Thief - Operation add thief to assault party  (REQUEST)
     */
    public static final int REQ_ADD_THIEF_TO_ASSAULT_PARTY = 33;

    /**
     * Normal Thief - Operation add thief to assault party  (REPLY)
     */
    public static final int REP_ADD_THIEF_TO_ASSAULT_PARTY = 34;

    /**
     * Normal Thief - Operation to reverse direction  (REQUEST)
     */
    public static final int REQ_REVERSE_DIRECTION = 35;

    /**
     * Normal Thief - Operation to reverse direction  (REPLY)
     */
    public static final int REP_REVERSE_DIRECTION = 36;

    /**
     * Normal Thief - Operation to crawl in  (REQUEST)
     */
    public static final int REQ_CRAWL_IN = 37;

    /**
     * Normal Thief - Operation to crawl in  (REPLY)
     */
    public static final int REP_CRAWL_IN = 38;

    /**
     * Normal Thief - Operation to crawl out  (REQUEST)
     */
    public static final int REQ_CRAWL_OUT = 39;

    /**
     * Normal Thief - Operation to crawl out  (REPLY)
     */
    public static final int REP_CRAWL_OUT = 40;

    /**
     * Master Thief - Operation send assault party  (REQUEST)
     */
    public static final int REQ_SEND_ASSAULT_PARTY = 41;

    /**
     * Master Thief - Operation send assault party  (REPLY)
     */
    public static final int REP_SEND_ASSAULT_PARTY = 42;

    /**
     * Master Thief - Operation wait for thieves to be ready  (REQUEST)
     */
    public static final int REQ_WAIT_FOR_THIEVES_TO_BE_READY = 43;

    /**
     * Master Thief - Operation wait for thieves to be ready  (REPLY)
     */
    public static final int REP_WAIT_FOR_THIEVES_TO_BE_READY = 44;



    /* MUSEUM INPUT/OUTPUT MESSAGES */

    /**
     * Normal Thief - Operation roll a canvas  (REQUEST)
     */
    public static final int REQ_ROLL_A_CANVAS = 51;

    /**
     * Normal Thief - Operation roll a canvas  (REPLY)
     */
    public static final int REP_ROLL_A_CANVAS = 52;



    /* GENERAL REPO INPUT/OUTPUT MESSAGES */

    /**
     * General Repository - Operation write header to log  (REQUEST)
     */
    public static final int REQ_HEADER = 53;

    /**
     * General Repository - Operation write header to log  (REPLY)
     */
    public static final int REP_HEADER = 54;

    /**
     * General Repository - Operation write footer to log  (REQUEST)
     */
    public static final int REQ_FOOTER = 55;

    /**
     * General Repository - Operation write footer to log  (REPLY)
     */
    public static final int REP_FOOTER = 56;

    /**
     * Normal Thief - Operation log thief added to the assault party (REQUEST)
     */
    public static final int REQ_LOG_ADDED_THIEVES = 57;

    /**
     * Normal Thief - Operation log thief added to the assault party (REPLY)
     */
    public static final int REP_LOG_ADDED_THIEVES = 58;

    /**
     * Normal Thief - Operation log thief position (REQUEST)
     */
    public static final int REQ_LOG_THIEF_POSITION = 59;

    /**
     * Normal Thief - Operation log thief position (REPLY)
     */
    public static final int REP_LOG_THIEF_POSITION = 60;

    /**
     * Master Thief - Operation log target room (REQUEST)
     */
    public static final int REQ_LOG_TARGET_ROOM = 61;

    /**
     * Master Thief - Operation log target room (REPLY)
     */
    public static final int REP_LOG_TARGET_ROOM = 62;

    /**
     * Normal Thief - Operation log thief canvas (REQUEST)
     */
    public static final int REQ_LOG_THIEF_CANVAS = 63;

    /**
     * Normal Thief - Operation log thief canvas (REPLY)
     */
    public static final int REP_LOG_THIEF_CANVAS = 64;

    /**
     * Normal Thief - Operation log thief waiting (REQUEST)
     */
    public static final int REQ_LOG_THIEF_WAITING = 65;

    /**
     * Normal Thief - Operation log thief waiting (REPLY)
     */
    public static final int REP_LOG_THIEF_WAITING = 66;

    /**
     * Normal Thief - Operation log thief in party (REQUEST)
     */
    public static final int REQ_LOG_THIEF_IN_PARTY = 67;

    /**
     * Normal Thief - Operation log thief in party (REPLY)
     */
    public static final int REP_LOG_THIEF_IN_PARTY = 68;

    /**
     * Master Thief - Operation log master thief state (REQUEST)
     */
    public static final int REQ_LOG_MASTER_THIEF_STATE = 69;

    /**
     * Master Thief - Operation log master thief state (REPLY)
     */
    public static final int REP_LOG_MASTER_THIEF_STATE = 70;

    /**
     * Normal Thief - Operation log thief state (REQUEST)
     */
    public static final int REQ_LOG_THIEF_STATE = 71;

    /**
     * Normal Thief - Operation log thief state (REPLY)
     */
    public static final int REP_LOG_THIEF_STATE = 72;

    /**
     * Normal Thief Client - Sends thieves agility (REQUEST)
     */
    public static final int REQ_SET_AGILITY = 83;

    /**
     * Normal Thief Client - Sends thieves agility (REPLY)
     */
    public static final int REP_SET_AGILITY = 84;

    /**
     * Server Concentratio - Sends distance to rooms (REQUEST)
     */
    public static final int REQ_SET_ROOMS_DISTANCE = 85;

    /**
     * Server Concentratio - Sends distance to rooms (REPLY)
     */
    public static final int REP_SET_ROOMS_DISTANCE = 86;

    /**
     * Server Museum - Sends paintings in rooms (REQUEST)
     */
    public static final int REQ_SET_PAINTINGS = 87;

    /**
     * Server Museum - Sends paintings in rooms (REPLY)
     */
    public static final int REP_SET_PAINTINGS = 88;
    
    /* SHUTDOWN MESSAGES */

    /**
     * General Repository - Operation shutdown logger (REQUEST)
     */
    public static final int REQ_SHUTDOWN_LOGGER = 73;

    /**
     * General Repository - Operation shutdown logger (REPLY)
     */
    public static final int REP_SHUTDOWN_LOGGER = 74;

    /**
     * Concentration Site - Operation shutdown concentration site (REQUEST)
     */
    public static final int REQ_SHUTDOWN_CONCENTRATION_SITE = 75;

    /**
     * Concentration Site - Operation shutdown concentration site (REPLY)
     */
    public static final int REP_SHUTDOWN_CONCENTRATION_SITE = 76;

    /**
     * Control Collection Site - Operation shutdown control collection site (REQUEST)
     */
    public static final int REQ_SHUTDOWN_CONTROL_COLLECTION_SITE = 77;

    /**
     * Control Collection Site - Operation shutdown control collection site (REPLY)
     */
    public static final int REP_SHUTDOWN_CONTROL_COLLECTION_SITE = 78;

    /**
     * Assault Party - Operation shutdown assault party (REQUEST)
     */
    public static final int REQ_SHUTDOWN_ASSAULT_PARTY = 79;

    /**
     * Assault Party - Operation shutdown assault party (REPLY)
     */
    public static final int REP_SHUTDOWN_ASSAULT_PARTY = 80;

    /**
     * Museum - Operation shutdown museum (REQUEST)
     */
    public static final int REQ_SHUTDOWN_MUSEUM = 81;

    /**
     * Museum - Operation shutdown museum (REPLY)
     */
    public static final int REP_SHUTDOWN_MUSEUM = 82;

}
