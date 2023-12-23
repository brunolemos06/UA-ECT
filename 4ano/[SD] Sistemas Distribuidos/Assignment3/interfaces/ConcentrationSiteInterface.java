package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type ConcentrationSite.
 *
 *      It provides the functionality to access the ConcentrationSite.
 */
public interface ConcentrationSiteInterface extends Remote{

    /**
     * Operation prepare assault party
     * 
     * Master Thief prepares the assault party
     * @param assaultPartyID assault party ID
     * @param RoomID target room ID
     * @return master thief state
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int prepareAssaultParty(int assaultPartyID, int RoomID) throws RemoteException;

    /**
     * Operation thief prepare excursion
     * 
     * Thief prepares the excursion
     * @param thiefID thief ID
     * @return assault party ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public ReturnInt prepareExcursion(int thiefID) throws RemoteException;

    /**
     * Operation amINeeded
     * 
     * Normal Thief checks if the thief is needed
     * @param thiefID thief ID
     * @return true if the thief is needed, false otherwise
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public ReturnBoolean amINeeded(int thiefID) throws RemoteException;

    /**
     * Operation sumUpResults
     * 
     * Master thief sums up the results
     * @param collectedCanvas number of collected canvas
     * @return state of the master thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public int sumUpResults(int collectedCanvas) throws RemoteException;

    /**
	 * Operation concentration site server shutdown
	 * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
	 */
	public void shutdown() throws RemoteException;
}
