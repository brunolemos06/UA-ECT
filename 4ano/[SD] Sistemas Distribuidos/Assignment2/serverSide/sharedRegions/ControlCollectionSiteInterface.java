package serverSide.sharedRegions;

import clientSide.entities.*;
import commInfra.*;
import serverSide.entities.ControlCollectionSiteClientProxy;

/**
 *  Interface to the Kitchen
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    Kitchen and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */
public class ControlCollectionSiteInterface {
    /**
     * Reference to the ControlCollectionSite object
     */
    private ControlCollectionSite controlCollectionSite;

    /**
     * ControlCollectionSiteInterface constructor.
     * @param controlCollectionSite Reference to the ControlCollectionSite object
     */
    public ControlCollectionSiteInterface(ControlCollectionSite controlCollectionSite) {
        this.controlCollectionSite = controlCollectionSite;
    }

    /**
	 * Processing of the incoming messages
	 * Validation, execution of the corresponding method and generation of the outgoing message.
	 * 
	 * 	@param inMessage service request
	 * 	@return service reply
	 * 	@throws MessageException if incoming message was not valid
	 */
	public Message processAndReply (Message inMessage) throws MessageException
	{
        Message outMessage = null;                           // mensagem de resposta

        /* Validation */
        switch(inMessage.getMsgType())
        {
            case MessageType.REQ_GET_ASSEMBLING_ASSAULT_PARTY_ID:
            case MessageType.REQ_GET_ROOM_WITH_CANVAS:
            case MessageType.REQ_GET_TOTAL_COLLECTED_CANVAS:
            case MessageType.REQ_TAKE_A_REST:
            case MessageType.REQ_COLLECT_CANVAS:
            case MessageType.REQ_HAND_CANVAS:
            case MessageType.REQ_SHUTDOWN_CONTROL_COLLECTION_SITE:
            case MessageType.REQ_START_OPERATION:
            case MessageType.REQ_APPRAISE_SIT:
                break;
        }

        /* Processing */
        switch(inMessage.getMsgType()){
            case MessageType.REQ_GET_ASSEMBLING_ASSAULT_PARTY_ID:
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setAssaultPartyId(controlCollectionSite.getAssaultPartyID());
                outMessage = new Message(MessageType.REP_GET_ASSEMBLING_ASSAULT_PARTY_ID, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getAssaultPartyId());
                break;
            case MessageType.REQ_GET_ROOM_WITH_CANVAS:
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setRoomWithCanvasID(controlCollectionSite.getRoomWithCanvasID());
                outMessage = new Message(MessageType.REP_GET_ROOM_WITH_CANVAS, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getRoomWithCanvasID());
                break;
            case MessageType.REQ_GET_TOTAL_COLLECTED_CANVAS:
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setCollectedCanvas(controlCollectionSite.getCollectedCanvas());
                outMessage = new Message(MessageType.REP_GET_TOTAL_COLLECTED_CANVAS, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getCollectedCanvas());
                break;
            case MessageType.REQ_START_OPERATION:
                // change masterThief state to DECIDING_WHAT_TO_DO
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setMasterThiefState(MasterThiefStates.DECIDING_WHAT_TO_DO);
                controlCollectionSite.startOfOperation();
                outMessage = new Message(MessageType.REP_START_OPERATION, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getMasterThiefState());
                break;
            case MessageType.REQ_APPRAISE_SIT:
                char decision = controlCollectionSite.appraiseSit();
                outMessage = new Message(MessageType.REP_APPRAISE_SIT, decision);
                break;
            case MessageType.REQ_TAKE_A_REST:
                // change masterThief state to WAITING_FOR_GROUP_ARRIVAL
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setMasterThiefState(MasterThiefStates.WAITING_FOR_ARRIVAL);
                controlCollectionSite.takeARest();
                outMessage = new Message(MessageType.REP_TAKE_A_REST, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getMasterThiefState());
                break;
            case MessageType.REQ_COLLECT_CANVAS:
                // change masterThief state to DECIDING_WHAT_TO_DO
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setMasterThiefState(MasterThiefStates.DECIDING_WHAT_TO_DO);
                controlCollectionSite.collectACanvas();
                outMessage = new Message(MessageType.REP_COLLECT_CANVAS, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getMasterThiefState());
                break;
            case MessageType.REQ_HAND_CANVAS:
                // get assault party id
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                ((ControlCollectionSiteClientProxy) Thread.currentThread()).setAssaultPartyId(inMessage.getAssaultPartyID());
                controlCollectionSite.handACanvas(((ControlCollectionSiteClientProxy) Thread.currentThread()).getAssaultPartyId());
                outMessage = new Message(MessageType.REP_HAND_CANVAS, ((ControlCollectionSiteClientProxy) Thread.currentThread()).getThiefId());
                break;
            case MessageType.REQ_SHUTDOWN_CONTROL_COLLECTION_SITE:
                controlCollectionSite.shutdown();
                outMessage = new Message(MessageType.REP_SHUTDOWN_CONTROL_COLLECTION_SITE);
                break;
        }
        return outMessage;
    }



}