package serverSide.sharedRegions;

import serverSide.main.*;
import serverSide.entities.AssaultPartyClientProxy;

import clientSide.entities.*;
import commInfra.*;

/**
 *  Interface to the AssaultParty shared region.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    General Repository and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

 public class AssaultPartyInterface{
    /**
   *  Reference to the AssaultParty shared region.
   */

   private final AssaultParty assaultParty;

   /**
    *  Instantiation of the interface to the AssaultParty shared region.
    *
    *    @param assaultParty reference to the AssaultParty shared region
    */
 
    public AssaultPartyInterface (AssaultParty assaultParty)
    {
       this.assaultParty = assaultParty;
    }
    
        /**
      *  Processing of the incoming messages.
      *
      *  Validation, execution of the corresponding method and generation of the outgoing message.
      *
      *    @param inMessage service request
      *    @return service reply
      *    @throws MessageException if the incoming message is not valid
      */

    public Message processAndReply (Message inMessage) throws MessageException
    {
        Message outMessage = null;                                     // mensagem de resposta

        /* validation of the incoming message */

        switch (inMessage.getMsgType ())
        {
            case MessageType.REQ_GET_HAS_CANVAS:
            case MessageType.REQ_SET_HAS_CANVAS:
                // validate if message is valid
                if ((inMessage.getNormalThiefID() < 0) || (inMessage.getNormalThiefID() >= SimulPar.M))
                    throw new MessageException ("Invalid thief ID!", inMessage);
                break;
            case MessageType.REQ_GET_ROOM_DISTANCE:
                break;
            case MessageType.REQ_GET_TARGET_ROOM_ID:
                break;
            case MessageType.REQ_SET_ASSAULT_PARTY_ID:
                // validate if message is valid
                // valid if assaultPartyID is 0 or 1
                if ((inMessage.getAssaultPartyID() != 0) && (inMessage.getAssaultPartyID() != 1))
                    throw new MessageException ("Invalid assault party ID!", inMessage);
                break;
            case MessageType.REQ_SET_TARGET_ROOM_ID:
                // validate if message is valid
                if ((inMessage.getRoomID() < 0) || (inMessage.getRoomID() >= SimulPar.N))
                    throw new MessageException ("Invalid target room ID!", inMessage);
                break;
            case MessageType.REQ_SET_TARGET_ROOM_DISTANCE:
                // validate if message is valid
                if (inMessage.getRoomDistance() < 0)
                    throw new MessageException ("Invalid target room distance!", inMessage);    
                break;
            case MessageType.REQ_ADD_THIEF_TO_ASSAULT_PARTY:
            case MessageType.REQ_REVERSE_DIRECTION:
            case MessageType.REQ_CRAWL_IN:
            case MessageType.REQ_CRAWL_OUT:
            case MessageType.REQ_SEND_ASSAULT_PARTY:
            case MessageType.REQ_WAIT_FOR_THIEVES_TO_BE_READY:
                break;
            case MessageType.REQ_SHUTDOWN_ASSAULT_PARTY:
                break;
            default:
                throw new MessageException ("Invalid message type!", inMessage);
        }

        /* processing */
        switch (inMessage.getMsgType ())
        {
            case MessageType.REQ_GET_HAS_CANVAS:
                //assaultpartyproxyclient
                ((AssaultPartyClientProxy) Thread.currentThread()).setHasCanvas(assaultParty.getHasCanvas(inMessage.getNormalThiefID()));
                outMessage = new Message(MessageType.REP_GET_HAS_CANVAS, inMessage.getNormalThiefID(), assaultParty.getHasCanvas(inMessage.getNormalThiefID()));
                break;
            case MessageType.REQ_SET_HAS_CANVAS:
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                assaultParty.setHasCanvas(inMessage.getNormalThiefID(), inMessage.getThiefHasCanvas());
                outMessage = new Message(MessageType.REP_SET_HAS_CANVAS, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_GET_ROOM_DISTANCE:
                //assaultpartyproxyclient
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                ((AssaultPartyClientProxy) Thread.currentThread()).setRoomDistance(assaultParty.getRoomDistance());
                int roomDistance = ((AssaultPartyClientProxy) Thread.currentThread()).getRoomDistance();
                outMessage = new Message(MessageType.REP_GET_ROOM_DISTANCE, inMessage.getNormalThiefID(), roomDistance);
                break;
            case MessageType.REQ_GET_TARGET_ROOM_ID:
                //assaultpartyproxyclient
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                ((AssaultPartyClientProxy) Thread.currentThread()).setTargetRoomID(assaultParty.getTargetRoom());
                int targetRoom = ((AssaultPartyClientProxy) Thread.currentThread()).getTargetRoomID();
                outMessage = new Message(MessageType.REP_GET_TARGET_ROOM_ID, inMessage.getNormalThiefID(), targetRoom);
                break;
            case MessageType.REQ_SET_ASSAULT_PARTY_ID:
                assaultParty.setAssaultID(inMessage.getAssaultPartyID());
                outMessage = new Message(MessageType.REP_SET_ASSAULT_PARTY_ID);
                break;
            case MessageType.REQ_SET_TARGET_ROOM_ID:
                assaultParty.setTargetRoom(inMessage.getRoomID());
                outMessage = new Message(MessageType.REP_SET_TARGET_ROOM_ID);
                break;
            case MessageType.REQ_SET_TARGET_ROOM_DISTANCE:
                assaultParty.setRoomDistance(inMessage.getRoomDistance());
                outMessage = new Message(MessageType.REP_SET_TARGET_ROOM_DISTANCE);
                break;
            case MessageType.REQ_ADD_THIEF_TO_ASSAULT_PARTY:
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                assaultParty.addThief();
                outMessage = new Message(MessageType.REP_ADD_THIEF_TO_ASSAULT_PARTY, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_REVERSE_DIRECTION:
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
                assaultParty.reverseDirection();
                outMessage = new Message(MessageType.REP_REVERSE_DIRECTION, inMessage.getNormalThiefID(), ((AssaultPartyClientProxy) Thread.currentThread()).getThiefState());
                break;
            case MessageType.REQ_CRAWL_IN:
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefAgility(inMessage.getNormalThiefAgility());
                assaultParty.crawlIn();
                outMessage = new Message(MessageType.REP_CRAWL_IN, inMessage.getNormalThiefID(), ((AssaultPartyClientProxy) Thread.currentThread()).getThiefState());
                break;
            case MessageType.REQ_CRAWL_OUT:
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
                ((AssaultPartyClientProxy) Thread.currentThread()).setThiefAgility(inMessage.getNormalThiefAgility());
                assaultParty.crawlOut();
                outMessage = new Message(MessageType.REP_CRAWL_OUT, inMessage.getNormalThiefID(), ((AssaultPartyClientProxy) Thread.currentThread()).getThiefState());
                break;
            case MessageType.REQ_SEND_ASSAULT_PARTY:
                ((AssaultPartyClientProxy) Thread.currentThread()).setMasterThiefState(inMessage.getMasterThiefState());
                assaultParty.sendAssaultParty();
                outMessage = new Message(MessageType.REP_SEND_ASSAULT_PARTY, ((AssaultPartyClientProxy) Thread.currentThread()).getMasterThiefState());
                break;
            case MessageType.REQ_WAIT_FOR_THIEVES_TO_BE_READY:
                assaultParty.waitForThivesToBeReady();
                outMessage = new Message(MessageType.REP_WAIT_FOR_THIEVES_TO_BE_READY);
                break;
            case MessageType.REQ_SHUTDOWN_ASSAULT_PARTY:
                assaultParty.shutdown();
                outMessage = new Message(MessageType.REP_SHUTDOWN_ASSAULT_PARTY);
                break;
            default:
                throw new MessageException ("Invalid message type!", inMessage);
        }
        return (outMessage);
    }
 }