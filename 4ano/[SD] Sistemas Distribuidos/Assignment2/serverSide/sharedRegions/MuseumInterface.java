package serverSide.sharedRegions;

import commInfra.*;
import serverSide.main.ServerMuseum;
import serverSide.main.SimulPar;
import serverSide.entities.MuseumClientProxy;

/**
 *  Interface to the Museum.
 *
 *    It is responsible to validate and process the incoming message, execute the corresponding method on the
 *    Museum and generate the outgoing message.
 *    Implementation of a client-server model of type 2 (server replication).
 *    Communication is based on a communication channel under the TCP protocol.
 */

public class MuseumInterface{

    /**
     * Reference to the Museum.
     */
     private final Museum museum;

    /**
     * Instantiation of an interface to the Museum.
     * @param museum reference to the Museum
     */
    public MuseumInterface (Museum museum)
    {
        this.museum = museum;
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
        Message outMessage = null;									// mensagem de resposta

        /* validation of the incoming message */

        switch (inMessage.getMsgType ())
        {
            case MessageType.REQ_ROLL_A_CANVAS:
                if ((inMessage.getNormalThiefID() < 0) || (inMessage.getNormalThiefID() >= SimulPar.M - 1))
                    throw new MessageException ("Thief ID is not valid!", inMessage);
                break;
            case MessageType.REQ_SHUTDOWN_MUSEUM :
                break;

        }

        /* message processing */

        switch (inMessage.getMsgType ())
        {
            case MessageType.REQ_ROLL_A_CANVAS:
                ((MuseumClientProxy) Thread.currentThread()).setThiefId(inMessage.getNormalThiefID());
                outMessage = new Message(MessageType.REP_ROLL_A_CANVAS, ((MuseumClientProxy) Thread.currentThread()).getThiefId(), museum.rollACanvas(inMessage.getAssaultPartyID()));
                break;
            case MessageType.REQ_SHUTDOWN_MUSEUM :
                museum.shutdown();
                outMessage = new Message(MessageType.REP_SHUTDOWN_MUSEUM);
                break;

        }

        return (outMessage);
    }
}