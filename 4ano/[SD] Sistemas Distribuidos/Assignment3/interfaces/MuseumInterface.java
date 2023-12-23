package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type GeneralRepo.
 *
 *      It provides the functionality to access the GeneralRepo.
 */
public interface MuseumInterface extends Remote {

    /**
     * Operation roll a canvas
     * 
     * A canvas is stolen from a room
     * @param thiefID thief id
     * @param assaultPartyID assault party id
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void rollACanvas(int thiefID, int assaultPartyID) throws RemoteException;

    /**
     * Operation museum server shutdown
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void shutdown() throws RemoteException;
    
}
