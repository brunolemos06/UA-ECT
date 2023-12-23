package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type AssaultParty.
 *
 *      It provides the functionality to access the AssaultParty.
 */
public interface AssaultPartyInterface extends Remote {
    
    /**
     * Operation get thief canvas
     * 
     * Returns a boolean depending on whether the thief is carrying a canvas or not
     * @param thiefID thief id
     * @return if the thief is carrying a canvas or not
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public boolean getHasCanvas(int thiefID) throws RemoteException;

    /**
     * Operation set thief canvas
     * 
     * Sets the thief canvas to true or false
     * @param thiefID thief id
     * @param value value to set the canvas to
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void setHasCanvas(int thiefID, boolean value) throws RemoteException;

    /**
     * Operation get distance to room
     * 
     * Returns the distance to the room
     * @return distance to room
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int getRoomDistance() throws RemoteException;

    /**
     * Operation get target room
     * 
     * Returns the room ID
     * @return room number ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int getTargetRoom() throws RemoteException;

    /**
     * Operation set target room
     * 
     * Sets the target room
     * @param targetRoom target room ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void setTargetRoom(int targetRoom) throws RemoteException;

    /**
     * Operation set room distance
     * 
     * Sets the distance to the target room
     * @param roomDistance distance to room
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void setRoomDistance(int roomDistance) throws RemoteException;

    /**
     * Operation set assault ID
     * 
     * Sets the assault party ID
     * @param assaultID assault party ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void setAssaultID(int assaultID) throws RemoteException;

    /**
     * Operation add thief to assault party
     * 
     * Adds the calling thief to the assault party
     * @param thiefID thief ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void addThief(int thiefID) throws RemoteException;

    /**
     * Operation reverse direction
     * 
     * Reverses the direction of the assault party
     * @param thiefID thief ID
     * @return state of the normal thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int reverseDirection(int thiefID) throws RemoteException;

    /**
     * Operation crawl in
     * 
     * The thiefs crawl in to the museum
     * @param thiefID thief ID
     * @param agility thief agility
     * @return state of the normal thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int crawlIn(int thiefID, int agility) throws RemoteException;

    /**
     * Operation crawl out
     * 
     * The thiefs crawl out of the museum
     * @param thiefID thief ID
     * @param agility thief agility
     * @return state of the normal thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int crawlOut(int thiefID, int agility) throws RemoteException;

    /**
     * Operation send assault party to the museum
     * 
     * The master thief sends the assault party to the museum
     * @return state of the master thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int sendAssaultParty() throws RemoteException;

    /**
     * Operation wait for assault party
     * 
     * The master thief waits until the thieves of the assault party are ready
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void waitForThivesToBeReady() throws RemoteException;

    /**
	 * Operation assault party server shutdown
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
	 */
	public void shutdown() throws RemoteException;
}
