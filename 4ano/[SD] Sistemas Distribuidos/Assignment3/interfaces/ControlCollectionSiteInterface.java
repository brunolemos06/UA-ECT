package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type ControlCollectionSite.
 *
 *      It provides the functionality to access the ControlCollectionSite.
 */
public interface ControlCollectionSiteInterface extends Remote {
    
    /**
     * Operation get available assault party ID
     * 
     * Master thief gets the available assault party ID
     * @return assault party ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int getAssaultPartyID() throws RemoteException;

    /**
     * Operation get possible room with canvas
     * 
     * Master thief gets the possible room ID with canvas
     * @return room ID with canvas
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int getRoomWithCanvasID() throws RemoteException;

    /**
     * Operation get collected canvas
     * 
     * Master thief gets the number of collected canvas
     * @return number of collected canvas
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int getCollectedCanvas() throws RemoteException;

    /**
     * Operation start heist
     * 
     * Master thief starts the heist
     * @return state of the master thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int startOfOperation() throws RemoteException;

    /**
     * Operation appraise situation
     * 
     * Master thief appraises the situation
     * @return character of the next operation
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public char appraiseSit() throws RemoteException;

    /**
     * Operation take a rest
     * 
     * Master thief takes a rest
     * @return state of the master thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int takeARest() throws RemoteException;

    /**
     * Operation collect a canvas
     * 
     * Master thief collects the canvas from thief
     * @return state of the master thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int collectACanvas() throws RemoteException;

    /**
     * Operation hand a canvas
     * 
     * Normal thief hands a canvas to the master thief
     * @param thiefID thief ID
     * @param assaultPartyID assault party ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void handACanvas(int thiefID, int assaultPartyID) throws RemoteException;

    /**
     * Operation concentration site server shutdown
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void shutdown() throws RemoteException;
}
