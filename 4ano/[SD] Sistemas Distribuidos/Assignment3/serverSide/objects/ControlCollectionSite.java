package serverSide.objects;

import java.rmi.RemoteException;

import serverSide.main.*;
import clientSide.entities.*;
import interfaces.*;
import commInfra.*;

/**
 *  ControlCollectionSite (shared region)
 *  This class implements the control collection site
 *  Public methods executed in mutual exclusion
 *  Implementation of a client-server model of type 2 (server replication).
 *  Communication is based on Java RMI.
 */
public class ControlCollectionSite implements ControlCollectionSiteInterface{

   /**
   * Data structure to store the information of the thieves waiting for the master thief to collect canvas
   */
   private class Data{
      private boolean canvas;
      private int roomID;
      private int thiefID;
      private int assaultPartyID;

      /**
      * Data structure instantiation
      * @param assaultPartyID id of the assault party
      * @param thiefID id of the thief
      * @param roomID id of the room
      * @param canvas if the thief has a canvas or not
      */ 
      public Data(int assaultPartyID, int thiefID, int roomID, boolean canvas){
         this.assaultPartyID = assaultPartyID;
         this.thiefID = thiefID;
         this.roomID = roomID;
         this.canvas = canvas;
      }

      /**
      * Function to get the room id
      * @return room id
      */ 
      public int getRoomID(){
         return roomID;
      }

      /**
      * Function to get if the thief has a canvas or not
      * @return if the thief has a canvas or not
      */ 
      public boolean getCanvas(){
         return canvas;
      }

      /**
      * Function to get the thief id
      * @return thief id
      */ 
      public int getThiefID(){
         return thiefID;
      }

      /**
      * Function to get the assault party id
      * @return assault party id
      */
      public int getAssaultPartyID(){
         return assaultPartyID;
      }
   }
   
   /**
   * Reference to the general repository
   */
   private GeneralRepoInterface repo;

   /** 
   * Reference to the assault parties 
   */
   private AssaultPartyInterface[] assaultParties;

   /**
   * Waiting thiefs with canvas to hand over to the master thief
   */
   private MemFIFO<Data> waitingCanvas;

   /**
   * Contains a boolean for each thief, if toCollect[thiefID] == true the thief has to wait for master thief to collect canvas, false thief can continue
   */
   private boolean[] toCollect;

   /**
   * Rooms with or without canvas
   * each room id indicates the array position which points to a boolean value
   * true - room with canvas
   * false - room without canvas
   */
   private boolean[] rooms;

   /**
   * Integer array with the room id, if the roomIsTarget[i] == 0 the room is not a target else the room is a target
   */
   private int [] roomIsTarget;

   /**
   * Reference to the parties in operation
   * if ==0 the assaultParty is not in op
   * if !=0 the assaultParty is in op 
   */ 
   private int[] assaultPartyInOperation;

   /**
   * Number of stolen paintings
   */
   private int collectedCanvas;

   /**
   * Number of shutdowns received
   */
   private int shutdowns;
   
   /**
   * Collection Site instantiation
   * @param repo reference to the general repository
   * @param assaultParties array with the assault parties
   */
   public ControlCollectionSite (GeneralRepoInterface repo, AssaultPartyInterface[] assaultParties) {

      this.repo = repo;
      this.assaultParties = assaultParties;

      rooms = new boolean[SimulPar.N];
      roomIsTarget = new int[SimulPar.N];
      for (int i = 0; i < SimulPar.N; i++) {
         this.rooms[i] = true;
         this.roomIsTarget[i] = 0;
      }

      assaultPartyInOperation = new int[SimulPar.N_PARTIES];
      for (int i = 0; i < SimulPar.N_PARTIES; i++) {
         this.assaultPartyInOperation[i] = 0;
      }

      this.collectedCanvas = 0;
      shutdowns = 0;
      
      try {
         this.waitingCanvas = new MemFIFO<>(new Data [SimulPar.M-1]);
      } catch (MemException e) {
         System.err.println("Error creating the waitingCanvas FIFO");
         e.printStackTrace();
         System.exit(1);
      }

      this.toCollect = new boolean[SimulPar.M-1];
      for (int i = 0; i < SimulPar.M-1; i++) {
         this.toCollect[i] = false;
      }
   }

   /**
   * Returns the assembling assault party ID 
   * @return assaultPartyID, -1 if no assault party is available
   */
   @Override
   public int getAssaultPartyID() {
      for (int i = 0; i < assaultPartyInOperation.length; i++) {
         //check for a party that is not in operation
         if (assaultPartyInOperation[i] == 0) {
            //set the status of the assaultParty to be in operation
            assaultPartyInOperation[i] = SimulPar.K;
            return i;
         }
      }
      return -1;
   }

   /**
   * Check for a room with canvas (room id) and if no assaultParty is already assigned to that room
   * if there is no room available returns -1
   * @return roomID
   */
   @Override
   public int getRoomWithCanvasID() throws RemoteException {
      for (int i = 0; i < rooms.length; i++) {
         if(rooms[i] && roomIsTarget[i]==0){
            //set the room as a target
            roomIsTarget[i] = 3;
            return i;
         }
      }
      return -1;
   }

   /** 
   * Checks if there are rooms with canvas and that aren't targets of an assault party
   * @return true if there are rooms with canvas and that aren't targets of an assault party
   */
   private boolean canvasLeft() {
      for (int i = 0; i < rooms.length; i++) {
         if(rooms[i] && roomIsTarget[i]==0){
            return true;
         }
      }
      return false;
   }

   /**
   * Returns the number of stolen paintings
   * @return collectedCanvas
   */
   @Override
   public int getCollectedCanvas() throws RemoteException{
      return collectedCanvas;
   }

   /**
   * The operation starts
   */
   @Override
   public synchronized int startOfOperation() throws RemoteException {
      repo.putMasterState(MasterThiefStates.DECIDING_WHAT_TO_DO);
      return MasterThiefStates.DECIDING_WHAT_TO_DO;
   }

   /**
   * Master thief assesses the situation
   * @return 'E' if the operation has ended, 'P' if the master thief must prepare a new assault party, 'R' to wait for the arrival of the assault party
   */
   @Override
   public synchronized char appraiseSit() throws RemoteException{
      //1º case: assault has come to an end (empty rooms, all thiefs must be on the concentratio site)
      // var[] de bools com ref ao grupos de assaulto ass[ass_id]=yes op/no op
      // var boll iniciada a false
      // inOP = false, inOP = inOP OR ass[ass_id]
      // COND: empty && !inOp

      boolean inOp = false;
      for (int i = 0; i < assaultPartyInOperation.length; i++) {
         inOp = inOp || !(assaultPartyInOperation[i]==0);
      }

      if ( !canvasLeft() && !inOp) {
         return 'E';
      }
      
      //2º case: wait arrival
      // n op = numero de grupos em operação
      // n op ==  (M-1)/K sem grupos de assalto disponiveis -> apanhar quadros
      // n op < (M-1)/K é possivel lançar grupos de assaulto se ainda houver salas com quadros e essas SALAS AINDA NAO TENHAM ASSAULT GROUPS ASSOCIADOS 
      // COND: n op == (M-1)/K || ( (n op==1) && nRoomEmpty==(N-1) ) &&  (roomNotEMptyID == addGroup[inOpID].roomID])
      int n_op = 0;
      for (int i = 0; i < assaultPartyInOperation.length; i++) {
         if (assaultPartyInOperation[i] != 0) { n_op++; }
      }

      if (n_op == (SimulPar.M-1)/SimulPar.K) {
         return 'R';
      }
      else if(n_op < (SimulPar.M-1)/SimulPar.K){
         //if there are rooms with canvas and that aren't targets of an assault party assemble a new party
         if(canvasLeft()){
            return 'P';
         }
         //else wait for the thieves to arrive with the canvas
         else{
            return 'R';
         }
      }

      System.err.println("AppraiseSit couldn't take a decision");
      System.exit(1);
      return 'F';
   }

   /**
   * Master thief waits for the thieves to arrive
   * waits for the thieves to arrive with the canvas
   */
   @Override
   public synchronized int takeARest() throws RemoteException{
      repo.putMasterState(MasterThiefStates.WAITING_FOR_ARRIVAL);

      //master thief waits for the thieves to arrive to the collection site
      while(waitingCanvas.isEmpty()){
         try {
            wait();
         } catch (InterruptedException e) {
            System.err.println("Master thief was interrupted while waiting for the thieves to arrive with canvas: " + e.getMessage());
            System.exit(1);
         }
      }
      return MasterThiefStates.WAITING_FOR_ARRIVAL;
   }

   /**
   * Called by the master thief if the thieves have arrived
   */
   @Override
   public synchronized int collectACanvas() throws RemoteException{
      Data data = null;
      try{
         data = waitingCanvas.read();        //read thiefID, roomID, canvas and assaultPartyID
      
         if(data.getCanvas()){               //if there is a canvas
            collectedCanvas++;               //increment number of stolen paintings
         }else{
            rooms[data.getRoomID()] = false; //else mark room as without canvas
         }
      } catch (MemException e) {
         System.err.println("Read of thief ID in canvas fifo failed: " + e.getMessage());
         System.exit(1);
      }

      //decrement number of thieves active in assault party
      assaultPartyInOperation[data.getAssaultPartyID()]--;

      //decrement number of thieves with this room as target
      roomIsTarget[data.getRoomID()]--;

      //thief has finished handing over canvas
      toCollect[data.getThiefID()] = false;

      //notify thief that the canvas has been collected
      notifyAll();

      //change master thief state to deciding what to do
      repo.putMasterState(MasterThiefStates.DECIDING_WHAT_TO_DO);
      return MasterThiefStates.DECIDING_WHAT_TO_DO;
   }

   /**
   * Called by a thief to hand over the canvas to the master thief
   * @param assaultPartyID assault party id
   */
   @Override
   public synchronized void handACanvas(int thiefID, int assaultPartyID) throws RemoteException{
      try{
         //add info and wait for master thief to collect canvas
         waitingCanvas.write(new Data(assaultPartyID, thiefID, assaultParties[assaultPartyID].getTargetRoom(), assaultParties[assaultPartyID].getHasCanvas(thiefID))); //insert assaultPartyID, thiefID, roomID and canvas in fifo
      } catch (MemException e) {
         System.err.println("Insertion of thief ID in canvas fifo failed: " + e.getMessage());
         System.exit(1);
      }

      //set var to true to indicate that thief has a canvas to hand over
      toCollect[thiefID] = true;
      
      //notify master thief that there is a thief with a canvas to hand over
      notifyAll();

      while(toCollect[thiefID]){ //wait until master thief notifies that he has collected the canvas
         try {
            wait();
         } catch (InterruptedException e) {
            System.err.println("Thief was interrupted while waiting for the master thief to collect the canvas: " + e.getMessage());
            System.exit(1);
         }
      }

      //thief no longer has canvas
      assaultParties[assaultPartyID].setHasCanvas(thiefID,false); //set thief as not having canvas
      repo.changehasacanvas(thiefID, 0,-1,assaultPartyID);
      repo.thiefStateW(thiefID);
   }

   /**
	 * Operation Control Collection Site server shutdown
	 */
   @Override
	public synchronized void shutdown() throws RemoteException{
		shutdowns += 1;
		if(shutdowns >= SimulPar.CONTROL_COLLECTION_SITE_SHUTDOWN) {
			ServerControlCollectionSite.shutdown();
		}
	}
}