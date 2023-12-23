package serverSide.objects;

import java.rmi.RemoteException;

import serverSide.main.*;
import clientSide.entities.*;
import interfaces.*;

/**
 *  Assault Party (shared region)
 *  This class implements the Assault Party
 *  Public methods executed in mutual exclusion
 *  Implementation of a client-server model of type 2 (server replication).
 *  Communication is based on Java RMI.
 */
public class AssaultParty implements AssaultPartyInterface{

    /**
    * AssaultParty ID
    */
    private int assaultID;

    /**
    * Distance to the room
    */
    private int roomDistance;

    /**
    * Maximum distance between thieves
    */
    private int maxThievesDistance = 3;
    
    /**
    * Target room
    */
    private int targetRoom;
    
    /**
    * Number of thieves in the party
    */
    private int thievesAtParty;

    /**
    * Reference to the thieves in the party
    */ 
    private int[] thieves;

    /**
    * Array with the thieves position
    */
    private int[] thievesPosition;
    
    /**
    * Room direction, true if going to the room, false if going back
    */
    private boolean roomDirection;

    /**
    * Reference to the General Repository
    */
    private GeneralRepoInterface repoInter;

    /**
    * Array with the thieves crawl ( 0 or 1)
    */
    private int[] thiefCrawl;

    /**
     * Array with HasCanvas
    */
    private boolean[] canvas;

    /**
     * Number of shutdowns received
     */
    private int shutdowns = 0;
    
    /**
     * AssaultParty instantiation
     * @param assaultID of the assault party
     * @param repo reference to the general repository
     */
    public AssaultParty(int assaultID,GeneralRepoInterface repo) {
        this.assaultID = assaultID;
        this.maxThievesDistance = 3;
        this.thievesAtParty = 0;
        this.thieves = new int[SimulPar.K];
        this.thievesPosition = new int[SimulPar.K];
        // init all with -1 
        for (int i = 0; i < SimulPar.K; i++) {
            this.thieves[i] = -1;
        }
        this.roomDirection = true;
        repoInter = repo;
        this.thiefCrawl = new int[SimulPar.K];
        this.canvas = new boolean[6];
    }

    /**
     * Returns the canvas of an thief
     * @return if he have a canvas
    */
    @Override
    public boolean getHasCanvas(int id) throws RemoteException{
        return this.canvas[id];
    }

    /**
     * Set if an thief have a canvas
     */
    @Override
    public synchronized void setHasCanvas(int id, boolean value) throws RemoteException{
        this.canvas[id] = value;
    }

    /**
     * Returns the room distance
     * @return room distance
     */
    @Override
    public int getRoomDistance() throws RemoteException{
        return roomDistance;
    }

    /**
     * Returns the target room
     * @return target room
     */
    @Override
    public int getTargetRoom() throws RemoteException{
        return targetRoom;
    }

    /**
    * Set the assault party ID
    * @param assaultID of the assault party
    */
    @Override
    public synchronized void setAssaultID(int assaultID) throws RemoteException{
        this.assaultID = assaultID;
    }

    /**
    * Set the target room
    * @param targetRoom of the assault party
    */
    @Override
    public synchronized void setTargetRoom(int targetRoom) throws RemoteException{
        this.targetRoom = targetRoom;
    }

    /**
    * Set the room distance
    * @param roomDistance of the assault party
    */
    @Override
    public synchronized void setRoomDistance(int roomDistance) throws RemoteException{
        this.roomDistance = roomDistance;
    }

    /** 
    * Add thief to the assault party 
    */
    @Override
    public synchronized void addThief(int thiefID) throws RemoteException{
        for (int i = 0; i < SimulPar.K; i++) {
            if(this.thieves[i] == -1){
                this.thieves[i] = thiefID;
                thievesAtParty++;
                notifyAll();
                repoInter.setThiefsInAssault(assaultID, thiefID);
                break;
            }
        }
    }
    
    /**
    * Thiefs reverse direction
    */
    @Override
    public synchronized int reverseDirection(int thiefID) throws RemoteException{
        repoInter.putThiefState(NormalThiefStates.CRAWLING_OUTWARDS, thiefID);
        roomDirection =false;
        // start crawling out
        thiefCrawl[0] = 1;
        return NormalThiefStates.CRAWLING_OUTWARDS;
    }

    /**
    * Thiefs crawl in to the room
    */
    @Override
    public synchronized int crawlIn(int thiefID, int agility) throws RemoteException{
        int walk = -1;
        int id = tranformID(thiefID);
        while(true){
            // wait until crawlin == 1
            while(thiefCrawl[id] == 0){
                try{
                    wait();
                }catch(Exception e){
                    System.err.println(e);
                }
            }
            while(canImove(thiefID, walk)){

                walk = moveTheMostICan(thiefID, agility);
                id = tranformID(thiefID);
                thievesPosition[id] += walk;

                int printthives = thievesPosition[id];
                if (thievesPosition[id] > roomDistance){
                    printthives = roomDistance;
                }
                if(walk != 0){
                    repoInter.changeposition(tranformID(thiefID), assaultID, printthives);
                }
            }
            
            // wake up the thief above me
            wakeThief(thiefID);
            goToSleep(thiefID);
            notifyAll();
            walk = -1;
            if (finish(thiefID)){
                thievesPosition[tranformID(thiefID)] =  this.roomDistance;
                thieves[tranformID(thiefID)] = thiefID;
                break;
            }
        }

        repoInter.putThiefState(NormalThiefStates.AT_A_ROOM, thiefID);
        tryToWakeAll(thiefID);
        return NormalThiefStates.AT_A_ROOM;
    }

    /**
    * Thiefs crawl out of the room
    */
    @Override
    public synchronized int crawlOut(int thiefID, int agility) throws RemoteException{
        int walk = -1;
        int id = tranformID(thiefID);
        while(true){
            // wait until crawlin == 1
            while(thiefCrawl[id] == 0){
                try{
                    wait();
                }catch(Exception e){
                    System.err.println(e);
                }
            }
            
            while(canImove(thiefID, walk)){
                walk = moveTheMostICan(thiefID, agility);
                id = tranformID(thiefID);
                thievesPosition[id] += walk;

                int printthives = thievesPosition[id];
                if (thievesPosition[id] > roomDistance){
                    printthives = roomDistance;
                }
                printthives = roomDistance - printthives;
                if(walk != 0){
                    repoInter.changeposition(tranformID(thiefID),assaultID,printthives);
                }
            }

            // wake up the thief above me
            wakeThief(thiefID);
            goToSleep(thiefID);
            notifyAll();
            walk = -1;
            if (finish(thiefID)){
                thievesPosition[tranformID(thiefID)] =  this.roomDistance;
                thieves[tranformID(thiefID)] = thiefID;
                break;
            }
        }
        tryToWakeAll(thiefID);
        repoInter.putThiefState(NormalThiefStates.COLLECTION_SITE, thiefID);
        return NormalThiefStates.COLLECTION_SITE;
    }

    /**
    * Master thief send the assault party
    */
    @Override
    public synchronized int sendAssaultParty() throws RemoteException{
        for(int i = 0; i < 6 ; i++){
            this.canvas[i] = false;
        }

        repoInter.putMasterState(MasterThiefStates.DECIDING_WHAT_TO_DO);
        
        this.roomDirection = true;
        thiefCrawl[0] = 1;
        notifyAll();
        return MasterThiefStates.DECIDING_WHAT_TO_DO;
    }

    /**
    * Master thief wait for the thieves of the assembling assault party to be ready
    */ 
    @Override
    public synchronized void waitForThivesToBeReady() throws RemoteException{
        while(thievesAtParty < SimulPar.K){
            try{
                wait();
            }catch(Exception e){
                System.err.println(e);
            }
        }
    }


    // internal methods
    
    /**
    * CurrentThread go to sleep
    */
    private void goToSleep(int thiefID){
        int id = tranformID(thiefID);
        thiefCrawl[id] = 0;
    }

    /**
    * wake CurrentThread Thief
    */
    private void wakeThief(int thiefID){
        int max = max(thievesPosition);
        int min = min(thievesPosition);
        int midle = midle(thievesPosition);
        int id = tranformID(thiefID);

        if(thievesPosition[0]>=roomDistance && thievesPosition[1]>=roomDistance && thievesPosition[2]>=roomDistance){
            midle = roomDistance;
        }else{
            if(max >= this.roomDistance && midle >=roomDistance && min>= roomDistance){
                // no code
            }
            else if (max >= this.roomDistance && midle >= this.roomDistance){
                int above = findIndexValue(thievesPosition, min);
                thiefCrawl[above] = 1;
            }
            else{
                if(thievesPosition[id] == max){
                    // wake up the thief above me
                    int above = findIndexValue(thievesPosition, midle);
                    if(midle < 0){ }
                    thiefCrawl[above] = 1;
                }
                else if(thievesPosition[id] == min){
                    // wake up the thief above me
                    int above;
                    if (max >= this.roomDistance){
                        above = findIndexValue(thievesPosition, midle);
                    }
                    else{
                        above = findIndexValue(thievesPosition, max);
                    }
                    
                    thiefCrawl[above] = 1;
                }
                else if(thievesPosition[id] == midle){
                    // wake up the thief above me
                    int above = findIndexValue(thievesPosition, min);
                    thiefCrawl[above] = 1;
                }else{
                    System.err.println("ERROR");
                }
            }
        }



    }

    /**
    * find index in array with element equals to value
    * @param array int
    * @param value int
    * @return index of the array
    */
    private int findIndexValue(int[] array, int value){
        for (int i = 0; i < SimulPar.K; i++) {
            if(array[i] == value){
                return i;
            }
        }
        System.err.print("findIndexValue ERROR");
        return -1;
    }

    /**
     * Move the Most I can
     * @return the value that an thief can walk
     */
    private int moveTheMostICan(int thiefID, int agility){
        int walk = agility;
        while(walk!=0){
            if(valitateWalk(thiefID, walk)){
                return walk;
            }else{
                walk-=1;
            }
        }
        return 0;
    }

    /**
     * Valite walk
     * @param walk int
     * @return return if the value walk is a valid position
     */
    private boolean valitateWalk(int thiefID, int walk){
        // i cant move if one of the Thieves is in the same position as me
        int id = tranformID(thiefID);
        int pos = thievesPosition[id];
        for (int i = 0; i < SimulPar.K; i++) {
            if(i != id || pos + walk != roomDistance - 1 ){
                if(thievesPosition[i] == pos + walk){
                    return false;
                }
            }
        }
        int[] newpos = new int[SimulPar.K];
        newpos[0] = thievesPosition[0];
        newpos[1] = thievesPosition[1];
        newpos[2] = thievesPosition[2];
        newpos[id] = pos + walk;

        // se a distancia entre o max e o secound max for maior que a distancia maxima ou se a distancia entre o min e o secound min for maior que a distancia maxima return false
        int max = max(newpos);
        int min = min(newpos);
        int midle = midle(newpos);
        if(max - midle > maxThievesDistance || midle - min > maxThievesDistance){
            return false;
        }
        return true;

    }

    /**
     * Max value in array
     * @param array int[]
     * @return the max value in array
     */
    private int max(int[] array){
        int max = 0;
        for (int i = 0; i < SimulPar.K; i++) {
            if(array[i] > max){
                max = array[i];
            }
        }
        return max;
    }

    /**
     * Min value in array
     * @param array int[]
     * @return the min value in array
     */
    private int min(int[] array){
        // find the min value in the array
        int min = array[0];
        for (int i = 0; i < SimulPar.K; i++) {
            if(array[i] < min){
                min = array[i];
            }
        }
        return min;
    }

    /**
     * Midle value in array
     * @param array int[]
     * @return the midle value in array
     */
    private int midle(int[] array){
        int max = max(array);
        int secoundmax = 0;
        for (int i = 0; i < SimulPar.K; i++) {
            if(array[i] > secoundmax && array[i] < max){
                secoundmax = array[i];
            }
        } 
        return secoundmax;
    }

    /**
     * Check if the thief has finished is crawl
     * @return true if the thief has finished is crawl, false if not
     */
    private boolean finish(int thiefID){
        // finish when position of this Thieves is the same as the target room -1
        int id = tranformID(thiefID);
        int pos = thievesPosition[id];
        return pos >= roomDistance;
    }

    /**
     * Check if the thief can move
     * @param walk int
     * @return true if the thief can move, false if not
     */
    private boolean canImove(int thiefID, int walk){
        // if walk == 0 return false
        if (walk == 0) {
            return false;
        }
        if (finish(thiefID)) {
            return false;
        }
        return true;
    }

    /**
     * Transform the thief id to the index in the array, 0 to 5 transform to 0 to 2 (3 thiefs)
     * @param ThiefID
     * @return the index in the array else -1
     */
    private int tranformID(int ThiefID){
        for(int i = 0; i < SimulPar.K; i++){
            if(thieves[i] != -1){
                if(thieves[i] == ThiefID){
                    return i;
                }
            }
        }
        return -1;
    }
    
    /** 
     * Verify if there is 3 thiefs in this assaultParty that finish
     */ 
    private void tryToWakeAll(int thiefID){
        int num_thieves = 0;
        for(int i = 0; i < SimulPar.K;i++){
            if( thievesPosition[i] >= roomDistance){
                num_thieves+=1;
            }
        }
        if(num_thieves == 3){
            if (roomDirection){
                num_thieves = 0;
                this.roomDirection = false;
            }else{
                this.roomDirection = true;
                thieves[0] = -1;
                thieves[1] = -1;
                thieves[2] = -1;
                num_thieves = 0;
                thievesAtParty = 0;
            }
            for(int i = 0; i < SimulPar.K;i++){
                thievesPosition[i] = 0;
            }
        }
    }

    /**
	 * Operation Assault Party server shutdown
	 */
	public synchronized void shutdown() throws RemoteException{
		shutdowns += 1;
		if(shutdowns >= SimulPar.ASSAULTPARTY_SHUTDOWN) {
			ServerAssaultParty.shutdown();
		}
	}

}