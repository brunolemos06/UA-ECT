package serverSide.sharedRegions;

import commInfra.*;

/**
 *  Interface to the General Repository of Information.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    General Repository and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class GeneralRepoInterface
{
    /**
   *  Reference to the general repository.
   */

   private final GeneralRepo repo;

   /**
    *  Instantiation of an interface to the general repository.
    *
    *    @param repo reference to the general repository
    */
 
    public GeneralRepoInterface (GeneralRepo repo)
    {
       this.repo = repo;
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
            case MessageType.REQ_SET_AGILITY:
            case MessageType.REQ_SET_ROOMS_DISTANCE:
            case MessageType.REQ_SET_PAINTINGS:
            case MessageType.REQ_HEADER :
            case MessageType.REQ_FOOTER :
            case MessageType.REQ_LOG_ADDED_THIEVES:
            case MessageType.REQ_LOG_THIEF_POSITION:
            case MessageType.REQ_LOG_TARGET_ROOM:
            case MessageType.REQ_LOG_THIEF_CANVAS:
            case MessageType.REQ_LOG_THIEF_WAITING:
            case MessageType.REQ_LOG_THIEF_IN_PARTY:
            case MessageType.REQ_LOG_MASTER_THIEF_STATE:
            case MessageType.REQ_LOG_THIEF_STATE:
            case MessageType.REQ_SHUTDOWN_LOGGER:
                break;
            default:
			    throw new MessageException ("Invalid message type!", inMessage);
        }

        /* processing */

        switch (inMessage.getMsgType ())
        {
            case MessageType.REQ_SET_AGILITY:
                repo.setAgility(inMessage.getIntArray());
                outMessage = new Message(MessageType.REP_SET_AGILITY);
                break;
            case MessageType.REQ_SET_ROOMS_DISTANCE:
                repo.setRoomsDistance(inMessage.getIntArray());
                outMessage = new Message(MessageType.REP_SET_ROOMS_DISTANCE);
                break;
            case MessageType.REQ_SET_PAINTINGS:
                repo.setPaintings(inMessage.getIntArray());
                outMessage = new Message(MessageType.REP_SET_PAINTINGS);
                break;
            case MessageType.REQ_HEADER :
                //repo.header();
                outMessage = new Message(MessageType.REP_HEADER);
                break;
            case MessageType.REQ_FOOTER:
                repo.finish(inMessage.getTotalNumberOfStolenCanvas());
                outMessage = new Message(MessageType.REP_FOOTER);
                break;
            case MessageType.REQ_LOG_ADDED_THIEVES:
                repo.setThiefsInAssault(inMessage.getAssaultPartyID(), inMessage.getNormalThiefID());
                outMessage = new Message(MessageType.REP_LOG_ADDED_THIEVES, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_LOG_THIEF_POSITION:
                repo.changeposition(inMessage.getElementID() , inMessage.getAssaultPartyID(), inMessage.getThiefPosition());
                outMessage = new Message(MessageType.REP_LOG_THIEF_POSITION, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_LOG_TARGET_ROOM:
                repo.settargetRoom(inMessage.getAssaultPartyID(), inMessage.getRoomID());
                outMessage = new Message(MessageType.REP_LOG_TARGET_ROOM);
                break;
            case MessageType.REQ_LOG_THIEF_CANVAS:
                int hasacanvas = 0;
                if (inMessage.getThiefHasCanvas() == true) {
                    hasacanvas = 1;
                } 
                repo.changehasacanvas(inMessage.getNormalThiefID(),hasacanvas,inMessage.getRoomID(),inMessage.getAssaultPartyID());
                outMessage = new Message(MessageType.REP_LOG_THIEF_CANVAS, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_LOG_THIEF_WAITING:
                repo.thiefStateW(inMessage.getNormalThiefID());
                outMessage = new Message(MessageType.REP_LOG_THIEF_WAITING, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_LOG_THIEF_IN_PARTY:
                repo.thiefStateP(inMessage.getNormalThiefID());
                outMessage = new Message(MessageType.REP_LOG_THIEF_IN_PARTY, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_LOG_MASTER_THIEF_STATE:
                repo.putMasterState(inMessage.getMasterThiefState());
                outMessage = new Message(MessageType.REP_LOG_MASTER_THIEF_STATE);
                break;
            case MessageType.REQ_LOG_THIEF_STATE:
                repo.putThiefState(inMessage.getNormalThiefState(),inMessage.getNormalThiefID());
                outMessage = new Message(MessageType.REP_LOG_THIEF_STATE, inMessage.getNormalThiefID());
                break;
            case MessageType.REQ_SHUTDOWN_LOGGER:
                repo.shutdown();
                outMessage = new Message(MessageType.REP_SHUTDOWN_LOGGER);
                break;
        }

        return (outMessage);
    }
}