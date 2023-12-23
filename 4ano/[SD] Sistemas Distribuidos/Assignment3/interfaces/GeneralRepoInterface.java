package interfaces;

import java.rmi.*;

/**
 *   Operational interface of a remote object of type GeneralRepo.
 *
 *      It provides the functionality to access the GeneralRepo.
 */
public interface GeneralRepoInterface extends Remote{

    /**
     * Operation print footer
     * 
     * Prints the footer to log file
     * @param totalcanvas total number of stolen canvas
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void finish(int totalcanvas) throws RemoteException;

    /**
     * Operation update info
     * 
     * Updates the info on the log file
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void updateInfo() throws RemoteException;

    /**
     * Operation set thiefs in assault party
     * 
     * Sets the info of the thieves on the assault party on the log file
     * @param assaultID assault party ID
     * @param thiefID thief ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void setThiefsInAssault(int assaultID, int thiefID) throws RemoteException;

    /**
     * Operation change thief position
     * 
     * Changes the position of the thief on the log file
     * @param elementID thief 'id' on the assault party
     * @param AssaultPartyID assault party ID
     * @param thiefposition position of the thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void changeposition(int elementID, int AssaultPartyID, int thiefposition) throws RemoteException;

    /**
     * Operation set target room
     * 
     * Sets the target room on the log file
     * @param assID assault party ID
     * @param targetRoom target room ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void settargetRoom(int assID, int targetRoom) throws RemoteException;

    /**
     * Operation change has a canvas
     * 
     * Changes if the thief has a canvas on the log file
     * @param thiefID thief ID
     * @param hasCanvas 1 if the thief has a canvas, 0 otherwise
     * @param roomid room ID
     * @param assID assault party ID
     * throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void changehasacanvas(int thiefID, int hasCanvas, int roomid, int assID) throws RemoteException;

    /**
     * Operation set thief state to waiting
     * 
     * Sets the thief state to waiting on the log file
     * @param thiefid thief ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void thiefStateW(int thiefid) throws RemoteException;

    /**
     * Operation set thief state to in party
     * 
     * Sets the thief state to in party on the log file
     * @param thiefid thief ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void thiefStateP(int thiefid) throws RemoteException;

    /**
     * Operation change master thief state
     * 
     * Changes the master thief state on the log file
     * @param state state of the master thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void putMasterState(int state) throws RemoteException;

    /**
     * Operation change thief state
     * 
     * Changes the thief state on the log file
     * @param state state of the thief
     * @param thiefid thief ID
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void putThiefState(int state, int thiefid) throws RemoteException;

    /**
     * Operation set agility
     * 
     * Sets the agility of the thieves on the log file
     * @param agility int [number of thieves] agility(2 to 6) of the thief
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void setAgility(int[] agility) throws RemoteException;

    /**
     * Operation set rooms distance
     * 
     * Sets the distance of the rooms on the log file
     * @param distance int [number of rooms] distance(15 to 30) of the room
     */
    public void setRoomsDistance(int[] distance) throws RemoteException;

    /**
     * Operation set painting per room
     * 
     * Sets the number of paintings per room on the log file
     * @param paintings int [number of rooms] number of paintings(8 to 16) per room
     */
    public void setPaintings(int[] paintings) throws RemoteException;

    /**
     * Operation GeneralRepo server shutdown
     * 
     * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
     */
    public void shutdown() throws RemoteException;   
}
