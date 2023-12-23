package serverSide.objects;

import java.rmi.RemoteException;

import serverSide.main.*;
import clientSide.entities.*;
import interfaces.*;
import commInfra.*;

/**
 *  ConcentrationSite (shared region)
 *  This class implements the concentration site
 *  Public methods executed in mutual exclusion
 *  Implementation of a client-server model of type 2 (server replication).
 *  Communication is based on Java RMI.
 */
public class ConcentrationSite implements ConcentrationSiteInterface{
  /**
  * Reference to the general repository
  */
  private GeneralRepoInterface repo;

  /**
  * Reference to the assault parties
  */
  private AssaultPartyInterface[] assaultParties; 

  /**
  * Fifo with the thieves that are waiting for the master thief (amINeeded)
  */
  private MemFIFO<Integer> waitingThieves;

  /** 
  * Array with the distance of each room roomDistance[roomID] = distance_to_room
  */
  private int[] roomDistance;

  /**
  * Assult party ID of the assembling group
  */
  private int currentAssaultPartyID;

  /**
  * Means that the thieves can wake up
  */
  private boolean canWakeUp;

  /**
  * When the variable is true the operation ends
  */
  private boolean endOP;

  /**
  * Number of shutdowns received
  */
  private int shutdowns = 0;

  /**
  * ConcentrationSite instantiation
  * @param assaultPartiesStub array with the assault parties
  * @param roomDistances array with the distance of each room, roomDistance[roomID] = distance_to_room
  * @param repo reference to the general repository
  */
  public ConcentrationSite(AssaultPartyInterface[] assaultParties, int[] roomDistances, GeneralRepoInterface repo) {

    this.repo = repo;
    this.assaultParties = assaultParties;
    this.roomDistance = roomDistances;

    try{
      waitingThieves = new MemFIFO<>(new Integer [SimulPar.M-1]);
      for(int i = 0; i < SimulPar.M-1; i++){
        waitingThieves.write(i);
      }
    }catch(MemException e){
      e.printStackTrace();
      waitingThieves = null;
      System.exit(1);
    }

    currentAssaultPartyID = -1;
    canWakeUp = false;
    endOP = false;

  }

  /**
   * Operation prepare assault party
   * 
   * Master Thief prepares the assault party
   *  Sets the assault party ID and target room
   * @param assaultPartyID assault party ID
   * @param RoomID  target room ID
   * @return master thief state
   * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
   */
  @Override
  public int prepareAssaultParty(int assaultPartyID, int RoomID) throws RemoteException{
    synchronized(this){
      
      if (RoomID == -1 || assaultPartyID == -1){
        System.err.println("WRONG DECISION:       RoomID: " + RoomID + " AssaultPartyID: " + assaultPartyID);
        System.exit(1);
      }
  
      repo.putMasterState(MasterThiefStates.ASSEMBLING_GROUP);
  
      //master thief sets the current assault party, its target room and distance
      currentAssaultPartyID = assaultPartyID;
      assaultParties[assaultPartyID].setRoomDistance(roomDistance[RoomID]);
      assaultParties[assaultPartyID].setTargetRoom(RoomID);
      repo.settargetRoom(assaultPartyID, RoomID);
      
      //master thief waits for the thieves to form a group
      while(!waitingThieves.enough(SimulPar.K)){
        try{
          wait();
        }catch (InterruptedException e) {
          System.err.println("Master thief was interrupted while waiting for the thieves to assemble the assault party: " + e.getMessage());
          System.exit(1);
        }
      }

      //master thief wakes up the thieves (one by one)
      for(int i = 0; i < SimulPar.K; i++){
        canWakeUp = true;
        notifyAll();
        while(canWakeUp && i<SimulPar.K){
          try{
            wait();
          }catch (InterruptedException e) {
            System.err.println("Master thief was interrupted while waiting for the thieves to assemble the assault party: " + e.getMessage());
            System.exit(1);
          }
        }
      }
    }

    //master thief waits for the thieves to be ready
    assaultParties[assaultPartyID].waitForThivesToBeReady();   
    
    return MasterThiefStates.ASSEMBLING_GROUP;
  }

  /**
   * Operation thief prepare excursion
   * 
   * Normal Thief prepares the excursion
   *  Thief is added to the assault party
   * @param thiefID thief ID
   * @return assault party ID
   * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
   */
  @Override
  public synchronized ReturnInt prepareExcursion(int thiefID) throws RemoteException{
    repo.putThiefState(NormalThiefStates.CRAWLING_INWARDS, thiefID);
    //add the thief to the assault party
    assaultParties[currentAssaultPartyID].addThief(thiefID);
    return new ReturnInt(currentAssaultPartyID, NormalThiefStates.CRAWLING_INWARDS);
  }

  /**
   * Operation am I needed
   * 
   * Normal Thief checks if he is needed
   *  Thief is added to the fifo and waits for the master thief to need him
   * @param thiefID thief ID
   * @return true if the thief is needed, false otherwise
   * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
   */
  @Override
  public synchronized ReturnBoolean amINeeded(int thiefID) throws RemoteException{
    repo.putThiefState(NormalThiefStates.CONCENTRATION_SITE, thiefID);

    //because we initialize the fifo with the thief IDs, we check if the thief is already in the fifo
    if(!waitingThieves.isIn(thiefID)){
      try{
        waitingThieves.write(thiefID);  
        notifyAll();
      }catch(MemException e){  
        System.err.println("Insertion of thief ID in wait fifo: " + e.getMessage());
        System.exit(1);
      }
    }

    // wait for the master thief to need them, when endOP is true the thieves can leave because the operation is over
    while( (waitingThieves.nextOut(thiefID) != true || !canWakeUp) && !endOP){
      try{
        wait();
      }catch (InterruptedException e) {
        System.err.println("Thief was interrupted while waiting in fifo at concentration site (not the first): " + e.getMessage());
        System.exit(1);
      }
    }

    //stop the other thieves from waking up
    canWakeUp = false;
    //notify the master thief that the thief is ready (to wake up the next thief if there is one else MT continues flow)
    notifyAll();

    //if the operation is over
    if(endOP){
      return new ReturnBoolean(false, NormalThiefStates.CONCENTRATION_SITE);
    }

    //thief removes its ID from the fifo
    try{
      if(waitingThieves.read() != thiefID){
        System.err.println("Thief ID is not the first in the fifo");
        System.exit(1);
      }
    }catch(MemException e){
      System.err.println("Reading of thief ID in wait fifo: " + e.getMessage());
      System.exit(1);
    }

    return new ReturnBoolean(true, NormalThiefStates.CONCENTRATION_SITE);
  }

  /**
   * Operation sum up results
   * 
   * Master Thief sums up the results
   *  Master Thief waits for the thieves to leave, then presents the report
   * @param collectedCanvas number of collected canvas
   * @return state of the master thief
   * @throws RemoteException if either the invocation of the remote method, or the communication with the registry service fails
   */
  @Override
  public synchronized int sumUpResults(int collectedCanvas) throws RemoteException {
    repo.putMasterState(MasterThiefStates.PRESENTING_THE_REPORT);
    //signal the thieves that the operation is over
    endOP = true;
    //notify the thieves
    notifyAll(); 
    // wait for the thieves to leave
    while(!waitingThieves.enough(SimulPar.M-1)){
      try{
        wait();
      }catch (InterruptedException e) {
        System.err.println("Master thief was interrupted while waiting for the thieves to leave the concentration site: " + e.getMessage());
        System.exit(1);
      }
    }
    repo.finish(collectedCanvas);
    return MasterThiefStates.PRESENTING_THE_REPORT;
  }

  /**
	 * Operation Concentration Site server shutdown
	 */
  @Override
	public synchronized void shutdown() throws RemoteException{
		shutdowns += 1;
		if(shutdowns >= SimulPar.CONCENTRATIONSITE_SHUTDOWN) {
			ServerConcentrationSite.shutdown();
		}
	}
}