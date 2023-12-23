package commInfra;

import java.io.Serializable;

/**
 * Internal structure of a message exchanged between the client and the server.
 * It is used to implement the client-server model of type 2 (server replication).
 * Communication is based on a communication channel under the TCP protocol.
 */
public class Message implements Serializable{
    /**
     * Serial version UID
     */
    private static final long serialVersionUID = 1001L;


    /**
     *  Message type
     */
    private int msgType = -1;

    /**
     * Master Thief State
     */
    private int masterThiefState = -1;

    /**
     * Master Thief Decision
     */
    private char decisionChar = ' ';

    /**
     * Normal Thief State
     */
    private int normalThiefState = -1;

    /**
     * Normal Thief ID
     */
    private int normalThiefID = -1;

    /**
     * Normal Thief Agility
     */
    private int normalThiefAgility = -1;

    /**
     * Assault Party ID
     */
    private int assaultPartyID = -1;

    /**
     * Target Room ID
     */
    private int roomID = -1;

    /**
     * Distance to Target Room
     */
    private int roomDistance = -1;

    /**
     * Current thief position on crawl in/out
     */
    private int thiefPosition = -1;

    /**
     * Thief has a canavs
     */
    private boolean thiefHasCanvas = false;

    /**
     * Total number of stolen canvas
     */
    private int totalNumberOfStolenCanvas = -1;

    /**
     * Thief is nedded
     */
    private boolean thiefIsNeeded = false;

    private int elementID = -1;

    /**
     * Array of ints 
     */
    private int[] intArray = null;

    /**
     * Returns the message type
     * @return message type
     */
    public int getMsgType(){
        return msgType;
    }

    /**
     * Returns the Master Thief State
     * @return Master Thief State
     */
    public int getMasterThiefState(){
        return masterThiefState;
    }

    /**
     * Returns the Master Thief Decision
     * @return Master Thief Decision
     */
    public char getDecision(){
        return decisionChar;
    }

    /**
     * Returns the Normal Thief State
     * @return Normal Thief State
     */
    public int getNormalThiefState(){
        return normalThiefState;
    }

    /**
     * Returns the element ID
     * @return element ID
     */
    public int getElementID(){
        return elementID;
    }

    /**
     * Returns the Normal Thief ID
     * @return Normal Thief ID
     */
    public int getNormalThiefID(){
        return normalThiefID;
    }

    /**
     * Returns the Normal Thief Agility
     * @return Normal Thief Agility
     */
    public int getNormalThiefAgility(){
        return normalThiefAgility;
    }

    /**
     * Returns the Assault Party ID
     * @return Assault Party ID
     */
    public int getAssaultPartyID(){
        return assaultPartyID;
    }

    /**
     * Returns the Target Room ID
     * @return Target Room ID
     */
    public int getRoomID(){
        return roomID;
    }


    /**
     * Returns the Distance to Target Room
     * @return Distance to Target Room
     */
    public int getRoomDistance(){
        return roomDistance;
    }

    /**
     * Returns the Current thief position on crawl in/out
     * @return Current thief position on crawl in/out
     */
    public int getThiefPosition(){
        return thiefPosition;
    }

    /**
     * Returns the Thief has a canavs
     * @return Thief has a canavs
     */
    public boolean getThiefHasCanvas(){
        return thiefHasCanvas;
    }

    /**
     * Returns the Total number of stolen canvas
     * @return Total number of stolen canvas
     */
    public int getTotalNumberOfStolenCanvas(){
        return totalNumberOfStolenCanvas;
    }

    /**
     * Returns true if thief is nedded and false otherwise
     * @return Thief is nedded
     */
    public boolean getThiefIsNeeded(){
        return thiefIsNeeded;
    }

    /**
     * Returns the arrays of ints
     * @return the array of ints
     */
    public int[] getIntArray(){
        return intArray;
    }

    /**
     * Message instantiation (form 1)
     * ?¿ - msgType:REQ_GET_ROOM_DISTANCE
     * master thief - msgType:REQ_WAIT_FOR_THIEVES_TO_BE_READY
     * master thief - msgType:REQ_GET_ASSEMBLING_ASSAULT_PARTY_ID
     * master thief - msgType:REQ_GET_ROOM_WITH_CANVAS
     * master thief - msgType:REQ_GET_TOTAL_COLLECTED_CANVAS
     * REPO - msgType:REQ_HEADER
     * SHUTDOWN - msgType:REQ_SHUTDOWN_*
     * --------------------------------------------------------------
     * master thief - msgType:REP_SET_ASSAULT_PARTY_ID
     * master thief - msgType:REP_SET_TARGET_ROOM_ID
     * master thief - msgType:REP_SET_TARGET_ROOM_DISTANCE
     * master thief - msgType:REP_WAIT_FOR_THIEVES_TO_BE_READY
     * Repo - msgType: REP_FOOTER
     * Repo - msgType: REP_LOG_TARGET_ROOM
     * Repo - msgType: REP_LOG_MASTER_THIEF_STATE
     * Repo - msgType: REP_SET_AGILITY
     * Repo - msgType: REQ_SET_ROOMS_DISTANCE
     * Repo - msgType: REQ_SET_PAINTINGS
     * @param msgType message type
     */
    public Message(int msgType){
        this.msgType = msgType;
    }

    /**
     * Message instantiation (form 2)
     * normal thief - msgType:REQ_GET_HAS_CANVAS , thiefID
     * normal thief - msgType:REQ_GET_TARGET_ROOM_ID, thiefID
     * master thief - msgType:REQ_SET_ASSAULT_PARTY_ID , assaultPartyID
     * master thief - msgType:REQ_SET_TARGET_ROOM_ID , targetRoomID
     * master thief - msgType:REQ_SET_TARGET_ROOM_DISTANCE , roomDistance
     * normal thief - msgType:REQ_ADD_THIEF_TO_ASSAULT_PARTY , thiefID
     * master thief - msgType:REQ_SEND_ASSAULT_PARTY , state
     * master thief - msgType:REQ_TAKE_A_REST , state
     * master thief - msgType:REQ_COLLECT_CANVAS , state
     * master thief - msgType:REQ_START_OPERATION, masterThiefState
     * master thief - msgType:REQ_APPRAISE_SIT, masterThiefState
     * normal thief - msgType:REQ_LOG_THIEF_WAITING , thiefID
     * normal thief - msgType:REQ_LOG_THIEF_IN_PARTY , thiefID
     * master thief - msgType:REQ_LOG_MASTER_THIEF_STATE , state
     * Repo - msgType:REQ_FOOTER , canvasStolen
     * -------------------------------------------------------------------------------------
     * normal thief - msgType: REP_SET_HAS_CANVAS , thiefID
     * normal thief - msgType: REP_ADD_THIEF_TO_ASSAULT_PARTY, thiefID
     * master thief - msgType: REP_SEND_ASSAULT_PARTY , state
     * master thief - msgType: REP_SUM_UP_RESULTS , state
     * master thief - msgType: REP_GET_ASSEMBLING_ASSAULT_PARTY_ID, assaultPartyID
     * master thief - msgType: REP_START_OPERATION, masterThiefState
     * master thief - msgType: REP_GET_ROOM_WITH_CANVAS, roomID
     * master thief - msgType: REP_GET_TOTAL_COLLECTED_CANVAS, totalNumberOfStolenCanvas
     * master thief - msgType: REP_APPRAISE_SIT, decisionChar
     * master thief - msgType: REP_TAKE_A_REST, state
     * master thief - msgType: REP_COLLECT_CANVAS, state
     * normal thief - msgType: REP_HAND_CANVAS , thiefID
     * REPO - msgType: REP_LOG_ADDED_THIEVES , thiefID
     * REPO - msgType: REP_LOG_THIEF_POSITION , thiefID
     * REPO - msgType: REP_LOG_THIEF_CANVAS , thiefID
     * REPO - msgType: REP_LOG_THIEF_WAITING , thiefID
     * REPO - msgType: REP_LOG_THIEF_IN_PARTY , thiefID
     * REPO - msgType: REP_LOG_THIEF_STATE , thiefID
     * 
     * @param msgType message type
     * @param val1 int value
     */
    public Message(int msgType, int val1){
        this.msgType = msgType;

        int ent = getEntitieFromMessage(msgType);

        if(ent == 1){   //normal thief
            normalThiefID = val1;
        }else if(ent == 2){  //master thief
            if(msgType == MessageType.REQ_SET_ASSAULT_PARTY_ID ||
               msgType == MessageType.REP_GET_ASSEMBLING_ASSAULT_PARTY_ID){
                assaultPartyID = val1;
            }
            else if(msgType == MessageType.REQ_SET_TARGET_ROOM_ID ||
                    msgType == MessageType.REP_GET_ROOM_WITH_CANVAS){
                roomID = val1;
            }
            else if(msgType == MessageType.REQ_SET_TARGET_ROOM_DISTANCE){
                roomDistance = val1;
            }
            else if(msgType == MessageType.REQ_SEND_ASSAULT_PARTY || 
                    msgType == MessageType.REQ_TAKE_A_REST || 
                    msgType == MessageType.REQ_COLLECT_CANVAS ||
                    msgType == MessageType.REQ_LOG_MASTER_THIEF_STATE ||
                    msgType == MessageType.REQ_START_OPERATION ||
                    msgType == MessageType.REP_SEND_ASSAULT_PARTY ||
                    msgType == MessageType.REP_TAKE_A_REST || 
                    msgType == MessageType.REP_SUM_UP_RESULTS ||
                    msgType == MessageType.REP_START_OPERATION ||
                    msgType == MessageType.REQ_APPRAISE_SIT ||
                    msgType == MessageType.REP_COLLECT_CANVAS){
                masterThiefState = val1;
            }else if (msgType == MessageType.REP_GET_TOTAL_COLLECTED_CANVAS){
                totalNumberOfStolenCanvas = val1;
            }else if (msgType == MessageType.REP_APPRAISE_SIT){
                decisionChar = (char) val1;
            }
        }
        else if(ent == 3){  //repo
            if(msgType == MessageType.REQ_FOOTER){
                totalNumberOfStolenCanvas = val1;
            }
            else if(msgType == MessageType.REP_LOG_ADDED_THIEVES || 
                    msgType == MessageType.REP_LOG_THIEF_POSITION ||
                    msgType == MessageType.REP_LOG_THIEF_CANVAS ||
                    msgType == MessageType.REP_LOG_THIEF_WAITING ||
                    msgType == MessageType.REP_LOG_THIEF_IN_PARTY ||
                    msgType == MessageType.REP_LOG_THIEF_STATE){
                normalThiefID = val1;
            }
        }
        else{
            System.out.println("Message instantiation (form 2) - Invalid message type");
        }
    }

    /**
     * Message instantiation (form 3)
     * normal thief - msgType:REQ_SET_HAS_CANVAS , id, hasCanvas
     * ---------------------------------------------------------
     * normal thief - msgType:REP_GET_HAS_CANVAS , id, hasCanvas
     * normal thief - msgType:REP_ROLL_A_CANVAS , id, hasCanvas
     * @param msgType message type
     * @param val1 
     * @param val2
     */
    public Message(int msgType, int val1, Boolean val2){
        this.msgType = msgType;
        
        int ent = getEntitieFromMessage(msgType);

        if(ent == 1){   //normal thief
            normalThiefID = val1;
            thiefHasCanvas = val2;
        }
        else{
            System.out.println("Message instantiation (form 3) - Invalid message type");
        }
    }

    /**
     * Message instantiation (form 4)
     * normal thief - msgType:REQ_HAND_CANVAS , thiefID, assaultPartyID
     * normal thief - msgType:REQ_REVERSE_DIRECTION , thiefID, state
     * normal thief - msgType:REQ_PREPARE_EXCURSION , thiefID, state
     * normal thief - msgType:REQ_AM_I_NEEDED , thiefID, state
     * master thief - msgType: REP_PREPARE_ASSAULT_PARTY , assaultPartyID, state
     * master thief - msgType:REQ_SUM_UP_RESULTS, collectedCanvas, state
     * normal thief - msgType:REQ_ROLL_A_CANVAS , thiefID, assaultPartyID
     * normal thief - msgType:REQ_LOG_ADDED_THIEVES , thiefID, assaultPartyID
     * master thief - msgType:REQ_LOG_TARGET_ROOM, targetRoomID, assaultPartyID
     * normal thief - msgType:REQ_LOG_THIEF_STATE , thiefID, state
     * ---------------------------------------------------------------------------
     * normal thief - msgType:REP_GET_ROOM_DISTANCE , thiefID, roomDistance
     * normal thief - msgType:REP_GET_TARGET_ROOM_ID , thiefID, targetRoomID
     * normal thief - msgType:REP_REVERSE_DIRECTION , thiefID, state
     * normal thief - msgType:REP_CRAWL_IN , thiefID, state
     * normal thief - msgType:REP_CRAWL_OUT , thiefID, state
     * @param msgType message type
     * @param val1 thief id
     * @param val2 int value
     */
    public Message(int msgType, int val1, int val2){
        this.msgType = msgType;

        int ent = getEntitieFromMessage(msgType);

        if(ent == 1){
            normalThiefID = val1;
            if(msgType == MessageType.REQ_HAND_CANVAS ||
               msgType == MessageType.REQ_ROLL_A_CANVAS ||
               msgType == MessageType.REQ_LOG_ADDED_THIEVES || 
               msgType == MessageType.REQ_LOG_THIEF_IN_PARTY){
                assaultPartyID = val2;
            }
            else if(msgType == MessageType.REQ_REVERSE_DIRECTION ||
                    msgType == MessageType.REQ_PREPARE_EXCURSION ||
                    msgType == MessageType.REQ_AM_I_NEEDED ||
                    msgType == MessageType.REQ_LOG_THIEF_STATE ||
                    msgType == MessageType.REP_REVERSE_DIRECTION ||
                    msgType == MessageType.REP_CRAWL_IN ||
                    msgType == MessageType.REP_CRAWL_OUT){
                normalThiefState = val2;
            }else if(msgType == MessageType.REP_GET_TARGET_ROOM_ID){
                roomID = val2;
            }
            else if(msgType == MessageType.REP_GET_ROOM_DISTANCE){
                roomDistance = val2;
            }
        }
        else if(ent == 2){
            if(msgType == MessageType.REQ_SUM_UP_RESULTS){
                totalNumberOfStolenCanvas = val1;
                masterThiefState = val2;
            }
            else if(msgType == MessageType.REQ_LOG_TARGET_ROOM){
                roomID = val1;
                assaultPartyID = val2;
            }
            else if(msgType == MessageType.REP_PREPARE_ASSAULT_PARTY){
                assaultPartyID = val1;
                masterThiefState = val2;
            }
        }
        else{
            System.out.println("Message instantiation (form 4) - Invalid message type");
        }
        
    }

    /**
     * Message instantiation (form 5)
     * normal thief - msgType:REQ_CRAWL_IN , thiefID, state, agility
     * normal thief - msgType:REQ_CRAWL_OUT , thiefID, state, agility
     * master thief - msgType:REQ_PREPARE_ASSAULT_PARTY , assaultPartyID, state, roomID
     * normal thief - msgType:REQ_LOG_THIEF_POSITION , elemID, AssaultParty, thiefposition
     * ------------------------------------------------------------------------------------
     * normal thief - msgType:REP_PREPARE_EXCURSION , thiefID, state, assaultPartyID
     * @param msgType
     * @param val1
     * @param val2
     * @param val3
     */
    public Message(int msgType, int val1, int val2, int val3){
        this.msgType = msgType;
        
        int ent = getEntitieFromMessage(msgType);

        if(ent == 1){
            normalThiefID = val1;
            if(msgType == MessageType.REQ_CRAWL_IN ||
               msgType == MessageType.REQ_CRAWL_OUT){
                normalThiefState = val2;
                normalThiefAgility = val3;
            }
            else if(msgType == MessageType.REQ_LOG_THIEF_POSITION){
                elementID = val1;
                assaultPartyID = val2;
                thiefPosition = val3;
            }
            else if(msgType == MessageType.REP_PREPARE_EXCURSION){
                normalThiefState = val2;
                assaultPartyID = val3;
            }
        }
        else if(ent == 2){
            if(msgType == MessageType.REQ_PREPARE_ASSAULT_PARTY){
                assaultPartyID = val1;
                masterThiefState = val2;
                roomID = val3;
            }
        }
        else{
            System.out.println("Message instantiation (form 5) - Invalid message type");
        }
    }

    /**
     * Message instantiation (form 6)
     * normal thief - msgType:REQ_LOG_THIEF_CANVAS , thiefID, hasacanvas, roomID, assaultPartyID
     * @param msgType
     * @param val1
     * @param val2
     * @param val3
     * @param val4
     */
    public Message(int msgType, int val1, int val2, int val3, int val4){
        this.msgType = msgType;
        
        int ent = getEntitieFromMessage(msgType);

        if(ent == 1){
            if(msgType == MessageType.REQ_LOG_THIEF_CANVAS){
                normalThiefID = val1;
                thiefHasCanvas = (val2 == 1);
                roomID = val3;
                assaultPartyID = val4;
            }
        }
        else{
            System.out.println("Message instantiation (form 6) - Invalid message type");
        }
    }

    /**
     * Message instantiation (form 7)
     * normal thief - msgType:REP_AM_I_NEEDED , thiefID, state, thiefIsNeeded
     * @param msgType
     * @param val1
     * @param val2
     * @param val3
     */
    public Message(int msgType, int val1, int val2, boolean val3){
        this.msgType = msgType;
        
        int ent = getEntitieFromMessage(msgType);

        if(ent == 1){ // normal thief
            normalThiefID = val1;
            normalThiefState = val2;
            if(msgType == MessageType.REP_AM_I_NEEDED){
                thiefIsNeeded = val3;
            }
        }
        else{
            System.out.println("Message instantiation (form 8) - Invalid message type");
        }
    }

    /**
     * Message instantiation (form 8)
     * REPO - msgType:REQ_SET_AGILITY, agility[]
     * REPO - msgType:REQ_SET_ROOMS_DISTANCE, roomDistance[]
     * REPO - msgType:REQ_SET_PAINTINGS, paintings[]
     * @param msgType
     * @param intArray
     */
    public Message(int msgType, int[] intArray){
        this.msgType = msgType;
        this.intArray = intArray;
    }

    public int getEntitieFromMessage(int msgType){
        switch (msgType) {
            //for normal thief entities
            case MessageType.REQ_GET_TARGET_ROOM_ID:            case MessageType.REP_GET_TARGET_ROOM_ID:
            case MessageType.REQ_ADD_THIEF_TO_ASSAULT_PARTY:    case MessageType.REP_ADD_THIEF_TO_ASSAULT_PARTY:
            case MessageType.REQ_AM_I_NEEDED:                   case MessageType.REP_AM_I_NEEDED:
            case MessageType.REQ_CRAWL_IN:                      case MessageType.REP_CRAWL_IN:
            case MessageType.REQ_CRAWL_OUT:                     case MessageType.REP_CRAWL_OUT:
            case MessageType.REQ_GET_HAS_CANVAS:                case MessageType.REP_GET_HAS_CANVAS:
            case MessageType.REQ_GET_ROOM_DISTANCE:             case MessageType.REP_GET_ROOM_DISTANCE:
            case MessageType.REQ_HAND_CANVAS:                   case MessageType.REP_HAND_CANVAS:
            case MessageType.REQ_LOG_ADDED_THIEVES:             case MessageType.REP_LOG_ADDED_THIEVES:
            case MessageType.REQ_LOG_THIEF_CANVAS:              case MessageType.REP_LOG_THIEF_CANVAS:
            case MessageType.REQ_LOG_THIEF_IN_PARTY:            case MessageType.REP_LOG_THIEF_IN_PARTY:
            case MessageType.REQ_LOG_THIEF_POSITION:            case MessageType.REP_LOG_THIEF_POSITION:
            case MessageType.REQ_LOG_THIEF_STATE:               case MessageType.REP_LOG_THIEF_STATE:
            case MessageType.REQ_LOG_THIEF_WAITING:             case MessageType.REP_LOG_THIEF_WAITING:
            case MessageType.REQ_PREPARE_EXCURSION:             case MessageType.REP_PREPARE_EXCURSION:
            case MessageType.REQ_REVERSE_DIRECTION:             case MessageType.REP_REVERSE_DIRECTION:
            case MessageType.REQ_ROLL_A_CANVAS:                 case MessageType.REP_ROLL_A_CANVAS:
            case MessageType.REQ_SET_HAS_CANVAS:                case MessageType.REP_SET_HAS_CANVAS:
                return 1;

            //all states with master thief - in comments
            case MessageType.REQ_WAIT_FOR_THIEVES_TO_BE_READY:      case MessageType.REP_WAIT_FOR_THIEVES_TO_BE_READY:
            case MessageType.REQ_GET_ASSEMBLING_ASSAULT_PARTY_ID:   case MessageType.REP_GET_ASSEMBLING_ASSAULT_PARTY_ID:
            case MessageType.REQ_GET_ROOM_WITH_CANVAS:              case MessageType.REP_GET_ROOM_WITH_CANVAS:
            case MessageType.REQ_GET_TOTAL_COLLECTED_CANVAS:        case MessageType.REP_GET_TOTAL_COLLECTED_CANVAS:
            case MessageType.REQ_START_OPERATION:                   case MessageType.REP_START_OPERATION:
            case MessageType.REQ_APPRAISE_SIT:                      case MessageType.REP_APPRAISE_SIT:
            case MessageType.REQ_SET_ASSAULT_PARTY_ID:              case MessageType.REP_SET_ASSAULT_PARTY_ID:
            case MessageType.REQ_SET_TARGET_ROOM_ID:                case MessageType.REP_SET_TARGET_ROOM_ID:
            case MessageType.REQ_SET_TARGET_ROOM_DISTANCE:          case MessageType.REP_SET_TARGET_ROOM_DISTANCE:
            case MessageType.REQ_SEND_ASSAULT_PARTY:                case MessageType.REP_SEND_ASSAULT_PARTY:
            case MessageType.REQ_TAKE_A_REST:                       case MessageType.REP_TAKE_A_REST:
            case MessageType.REQ_COLLECT_CANVAS:                    case MessageType.REP_COLLECT_CANVAS:
            case MessageType.REQ_LOG_MASTER_THIEF_STATE:            case MessageType.REP_LOG_MASTER_THIEF_STATE:
            case MessageType.REQ_SUM_UP_RESULTS:                    case MessageType.REP_SUM_UP_RESULTS:
            case MessageType.REQ_LOG_TARGET_ROOM:                   case MessageType.REP_LOG_TARGET_ROOM:
            case MessageType.REQ_PREPARE_ASSAULT_PARTY:             case MessageType.REP_PREPARE_ASSAULT_PARTY:
            return 2;

            //for general repository
            case MessageType.REQ_HEADER:            case MessageType.REP_HEADER:
            case MessageType.REQ_FOOTER:            case MessageType.REP_FOOTER:
            return 3;

            default: return -1;
            
        }
    }


    @Override
    public String toString(){
        return  "Message Type: " + msgType + "\n" +
                "Master Thief State: " + masterThiefState + "\n" +
                "Normal Thief State: " + normalThiefState + "\n" +
                "Normal Thief ID: " + normalThiefID + "\n" +
                "Normal Thief Agility: " + normalThiefAgility + "\n" +
                "Assault Party ID: " + assaultPartyID + "\n" +
                "Target Room ID: " + roomID + "\n" +
                "Distance to Target Room: " + roomDistance + "\n" +
                "Thief has a canavs: " + thiefHasCanvas + "\n" +
                "Total number of stolen canvas: " + totalNumberOfStolenCanvas + "\n";
    }

}
