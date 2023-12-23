package serverSide.sharedRegions;

import serverSide.main.*;
import serverSide.entities.*;

import clientSide.stub.GeneralRepoStub;
import clientSide.stub.AssaultPartyStub;
import clientSide.entities.MasterThiefStates;
import clientSide.entities.NormalThiefStates;
import commInfra.*;

/**
 *  ConcentrationSite (shared region)
 *  This class implements the concentration site
 *  All public methods are executed in mutual exclusion.
 */

public class ConcentrationSite{
  /**
  * Reference to the general repository
  */
  private GeneralRepoStub repo;

  /**
  * Reference to the assault parties
  */
  private AssaultPartyStub[] assaultPartiesStub; 

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
  public ConcentrationSite(AssaultPartyStub[] assaultPartiesStub, int[] roomDistances, GeneralRepoStub repo) {

    this.repo = repo;
    this.assaultPartiesStub = assaultPartiesStub;
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
  * Master Thief awakes the thieves (one by one) so that they can join the assault party
  * @param assaultPartyID
  *
  */
  public void prepareAssaultParty(int assaultPartyID, int RoomID) {
    System.out.println("Master thief is preparing the assault party "+ assaultPartyID + " to room " + RoomID);
    synchronized(this){
      
      if (RoomID == -1 || assaultPartyID == -1){
        System.err.println("WRONG DECISION:       RoomID: " + RoomID + " AssaultPartyID: " + assaultPartyID);
        System.exit(1);
      }
  
      ((ConcentrationSiteClientProxy) Thread.currentThread()).setMasterThiefState(MasterThiefStates.ASSEMBLING_GROUP);
      repo.putMasterState(MasterThiefStates.ASSEMBLING_GROUP);
  
      //master thief sets the correct assault party, room and distance
      currentAssaultPartyID = assaultPartyID;
      assaultPartiesStub[assaultPartyID].setRoomDistance(roomDistance[RoomID]);
      assaultPartiesStub[assaultPartyID].setTargetRoom(RoomID);
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
    assaultPartiesStub[assaultPartyID].waitForThivesToBeReady();    
  }

  /**
  * The thief join the assault party 
  * @return assaultPartyID
  */
  public synchronized int prepareExcursion() {
    //change thief state
    int thiefID = ((ConcentrationSiteClientProxy) Thread.currentThread()).getThiefId();
    ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefState(NormalThiefStates.CRAWLING_INWARDS);
    repo.putThiefState(NormalThiefStates.CRAWLING_INWARDS, thiefID);
    //add the thief to the assault party
    assaultPartiesStub[currentAssaultPartyID].addThief();
    return currentAssaultPartyID;
  }

  /**
  * Thieves wait for the master thief to need them
  * @return true if the thief is needed, false if the operation is over
  */
  public synchronized boolean amINeeded() {
    int thiefID = ((ConcentrationSiteClientProxy) Thread.currentThread()).getThiefId();
    System.out.println("Thief " + thiefID + " is waiting on concentration site");
    ((ConcentrationSiteClientProxy) Thread.currentThread()).setThiefState(NormalThiefStates.CONCENTRATION_SITE);
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
      return false;
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

    return true;
  }

  /**
  * Master thief waits for ALL the thieves and then present results
  * @param collectedCanvas
  */
  public synchronized void sumUpResults(int collectedCanvas) {
    //set the master thief state
    ((ConcentrationSiteClientProxy) Thread.currentThread()).setMasterThiefState(MasterThiefStates.PRESENTING_THE_REPORT);
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
  }

  /**
	 * Operation General Repo server shutdown
	 */
	public synchronized void shutdown()
	{
		shutdowns += 1;
		if(shutdowns >= SimulPar.CONCENTRATIONSITE_SHUTDOWN) {
			ServerConcentrationSite.waitConnection = false;
		}
		notifyAll ();
	}

}