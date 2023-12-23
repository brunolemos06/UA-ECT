package serverSide.sharedRegions;
import clientSide.entities.MasterThiefStates;
import clientSide.entities.NormalThiefStates;
import commInfra.*;
import serverSide.entities.ConcentrationSiteClientProxy;

/**
 *  Interface to the ConcentrationSite shared region.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    General Repository and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

 public class ConcentrationSiteInterface{
    /**
   *  Reference to the ConcentrationSite shared region.
   */

   private final ConcentrationSite concentrationSite;

   /**
    *  Instantiation of the interface to the ConcentrationSite shared region.
    *   @param concentrationSite reference to the ConcentrationSite shared region
    */
 
    public ConcentrationSiteInterface (ConcentrationSite concentrationSite)
    {
       this.concentrationSite = concentrationSite;
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
        switch(inMessage.getMsgType()){
            case MessageType.REQ_PREPARE_ASSAULT_PARTY:
                //assaultparty id 0 or 1
                if (inMessage.getAssaultPartyID() < 0 || inMessage.getAssaultPartyID() > 1){
                    throw new MessageException("Invalid assault party id!", inMessage);
                }
                break;
            case MessageType.REQ_PREPARE_EXCURSION:
                //getNormalThiefID
                if (inMessage.getNormalThiefID() < 0 || inMessage.getNormalThiefID() > 5){
                    throw new MessageException("Invalid thief id!", inMessage);
                }
            case MessageType.REQ_AM_I_NEEDED:
                //getNormalThiefID
                if (inMessage.getNormalThiefID() < 0 || inMessage.getNormalThiefID() > 5){
                    throw new MessageException("Invalid thief id!", inMessage);
                }
                break;
            case MessageType.REQ_SUM_UP_RESULTS:
            case MessageType.REQ_SHUTDOWN_CONCENTRATION_SITE:
                break;
            default:
                throw new MessageException("Invalid message type!", inMessage);
        }

        /* message processing */
        switch(inMessage.getMsgType()){
            case MessageType.REQ_PREPARE_ASSAULT_PARTY:
                // put master thief in ASSEMBLING_GROUP state
                ((ConcentrationSiteClientProxy) Thread.currentThread()).setMasterThiefState(inMessage.getMasterThiefState());
                concentrationSite.prepareAssaultParty(inMessage.getAssaultPartyID(), inMessage.getRoomID());
                outMessage = new Message(MessageType.REP_PREPARE_ASSAULT_PARTY, inMessage.getAssaultPartyID(), MasterThiefStates.ASSEMBLING_GROUP);
                break;
            case MessageType.REQ_PREPARE_EXCURSION:
                ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                // ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefAgility(inMessage.getNormalThiefAgility());
                ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
                int assaultPartyID = concentrationSite.prepareExcursion();
                outMessage = new Message(MessageType.REP_PREPARE_EXCURSION, inMessage.getNormalThiefID(), NormalThiefStates.CRAWLING_INWARDS, assaultPartyID);
                break;
            case MessageType.REQ_AM_I_NEEDED:
                ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                // ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefAgility(inMessage.getNormalThiefAgility());
                ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefState(inMessage.getNormalThiefState());
                boolean needed = concentrationSite.amINeeded();
                outMessage = new Message(MessageType.REP_AM_I_NEEDED, inMessage.getNormalThiefID(), NormalThiefStates.CONCENTRATION_SITE, needed);
                break;
            case MessageType.REQ_SUM_UP_RESULTS:
                ((ConcentrationSiteClientProxy) Thread.currentThread()).setMasterThiefState(MasterThiefStates.PRESENTING_THE_REPORT);
                concentrationSite.sumUpResults(inMessage.getTotalNumberOfStolenCanvas());
                outMessage = new Message(MessageType.REP_SUM_UP_RESULTS, ((ConcentrationSiteClientProxy) Thread.currentThread()).getMasterThiefState());
                break;
            case MessageType.REQ_SHUTDOWN_CONCENTRATION_SITE:
                concentrationSite.shutdown();
                outMessage = new Message(MessageType.REP_SHUTDOWN_CONCENTRATION_SITE);
                break;
            default :
                throw new MessageException("Invalid message type!", inMessage);
        }
        return (outMessage);
      }


 }