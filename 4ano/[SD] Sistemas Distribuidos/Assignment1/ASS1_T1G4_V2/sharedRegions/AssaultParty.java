package sharedRegions;

import entities.*;
import main.SimulPar;

/** 
* AssaultParty (shared region) 
*/
public class AssaultParty {

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
    private NormalThief[] thieves;

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
    private GeneralRepo repo;

    /**
    * Array with the thieves crawl ( 0 or 1)
    */
    private int[] thiefCrawl;

    /**
     * Array with HasCanvas
    */
    private boolean[] canvas;
    
    /**
     * AssaultParty instantiation
     * @param assaultID of the assault party
     * @param repo reference to the general repository
     */
    public AssaultParty(int assaultID,GeneralRepo repo) {
        this.assaultID = assaultID;
        this.maxThievesDistance = 3;
        this.thievesAtParty = 0;
        this.thieves = new NormalThief[SimulPar.K];
        this.thievesPosition = new int[SimulPar.K];
        this.roomDirection = true;
        this.repo = repo;
        this.thiefCrawl = new int[SimulPar.K];
        this.canvas = new boolean[6];
    }

    // /**
    //  * Returns the assault party ID
    //  * @return assault party ID
    //  */
    // public int getAssaultID() {
    //     return assaultID;
    // }

    /**
     * Returns the canvas of an thief
     * @return if he have a canvas
    */
    public boolean getHasCanvas(int id){
        return this.canvas[id];
    }

    /**
     * Set if an thief have a canvas
     */
    public synchronized void setHasCanvas(int id, boolean value){
        this.canvas[id] = value;
    }

    /**
     * Returns the room distance
     * @return room distance
     */
    public int getRoomDistance() {
        return roomDistance;
    }

    /**
     * Returns the target room
     * @return target room
     */
    public int getTargetRoom() {
        return targetRoom;
    }

    /**
    * Set the assault party ID
    * @param assaultID of the assault party
    */
    public synchronized void setAssaultID(int assaultID) {
        this.assaultID = assaultID;
    }

    /**
    * Set the target room
    * @param targetRoom of the assault party
    */
    public synchronized void setTargetRoom(int targetRoom) {
        this.targetRoom = targetRoom;
    }

    /**
    * Set the room distance
    * @param roomDistance of the assault party
    */
    public synchronized void setRoomDistance(int roomDistance) {
        this.roomDistance = roomDistance;
    }

    /** 
    * Add thief to the assault party 
    */
    public synchronized void addThief(){
        for (int i = 0; i < SimulPar.K; i++) {
            if(this.thieves[i] == null){
                this.thieves[i] = (NormalThief) Thread.currentThread();
                thievesAtParty++;
                notifyAll();
                repo.setThiefsInAssault(assaultID,((NormalThief) Thread.currentThread()).getThiefId());
                break;
            }
        }
    }
    
    /**
    * Thiefs reverse direction
    */
    public synchronized void reverseDirection(){
        ((NormalThief) Thread.currentThread()).setThiefState(NormalThiefStates.CRAWLING_OUTWARDS);
        repo.putThiefState(NormalThiefStates.CRAWLING_OUTWARDS, ((NormalThief) Thread.currentThread()).getThiefId());
        roomDirection =false;
        // start crawling out
        thiefCrawl[0] = 1;
        
    }

    /**
    * Thiefs crawl in to the room
    */
    public synchronized void crawlIn(){
        int walk = -1;
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        while(true){
            // wait until crawlin == 1

            while(thiefCrawl[id] == 0){
                try{
                    wait();
                }catch(Exception e){
                    System.err.println(e);
                }
            }
            
            while(canImove(walk)){
                walk = moveTheMostICan();
                id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
                thievesPosition[id] += walk;

                int printthives = thievesPosition[id];
                if (thievesPosition[id] > roomDistance){
                    printthives = roomDistance;
                }
                if(walk != 0){
                    repo.changeposition(tranformID(((NormalThief) Thread.currentThread()).getThiefId()),assaultID,printthives);
                }
            }

            // wake up the thief above me
            wakeThief();
            goToSleep();
            notifyAll();
            walk = -1;
            if (finish()){
                thievesPosition[tranformID(((NormalThief) Thread.currentThread()).getThiefId())] =  this.roomDistance;
                thieves[tranformID(((NormalThief) Thread.currentThread()).getThiefId())] = ((NormalThief) Thread.currentThread());
                break;
            }
        }
        ((NormalThief) Thread.currentThread()).setThiefState(NormalThiefStates.AT_A_ROOM);
        repo.putThiefState(NormalThiefStates.AT_A_ROOM, ((NormalThief) Thread.currentThread()).getThiefId());
        tryToWakeAll();
    }

    /**
    * Thiefs crawl out of the room
    */
    public synchronized void crawlOut(){
        int walk = -1;
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        while(true){
            // wait until crawlin == 1

            while(thiefCrawl[id] == 0){
                try{
                    wait();
                }catch(Exception e){
                    System.err.println(e);
                }
            }
            
            while(canImove(walk)){
                walk = moveTheMostICan();
                id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
                thievesPosition[id] += walk;

                int printthives = thievesPosition[id];
                if (thievesPosition[id] > roomDistance){
                    printthives = roomDistance;
                }
                printthives = roomDistance - printthives;
                if(walk != 0){
                    repo.changeposition(tranformID(((NormalThief) Thread.currentThread()).getThiefId()),assaultID,printthives);
                }
            }

            // wake up the thief above me
            wakeThief();
            goToSleep();
            notifyAll();
            walk = -1;
            if (finish()){
                thievesPosition[tranformID(((NormalThief) Thread.currentThread()).getThiefId())] =  this.roomDistance;
                thieves[tranformID(((NormalThief) Thread.currentThread()).getThiefId())] = ((NormalThief) Thread.currentThread());
                break;
            }
        }
        tryToWakeAll();
    }

    /**
    * Master thief send the assault party
    */
    public synchronized void sendAssaultParty(){
        for(int i = 0; i < 6 ; i++){
            this.canvas[i] = false;
        }
        ((MasterThief) (Thread.currentThread())).setThiefState(MasterThiefStates.DECIDING_WHAT_TO_DO);
        repo.putMasterState(MasterThiefStates.DECIDING_WHAT_TO_DO);
        
        this.roomDirection = true;
        thiefCrawl[0] = 1;
        notifyAll();
    }

    /**
    * Master thief wait for the thieves of the assembling assault party to be ready
    */ 
    public synchronized void waitForThivesToBeReady(){
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
    private void goToSleep(){
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        thiefCrawl[id] = 0;
    }

    /**
    * wake CurrentThread Thief
    */
    private void wakeThief(){
        int max = max(thievesPosition);
        int min = min(thievesPosition);
        int midle = midle(thievesPosition);
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());

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
    private int moveTheMostICan(){
        int walk = ((NormalThief) Thread.currentThread()).getAgility();
        while(walk!=0){
            if(valitateWalk(walk)){
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
    private boolean valitateWalk(int walk){
        // i cant move if one of the Thieves is in the same position as me
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        int pos = thievesPosition[id];
        for (int i = 0; i < SimulPar.K; i++) {
            if(i != id || pos + walk != roomDistance - 1){
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
    private boolean finish(){
        // finish when position of this Thieves is the same as the target room -1
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        int pos = thievesPosition[id];
        return pos >= roomDistance;
    }

    /**
     * Check if the thief can move
     * @param walk int
     * @return true if the thief can move, false if not
     */
    private boolean canImove(int walk){
        // if walk == 0 return false
        if (walk == 0) {
            return false;
        }
        if (finish()) {
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
            if(thieves[i] != null){
                if(thieves[i].getThiefId() == ThiefID){
                    return i;
                }
            }
        }
        return -1;
    }
    
    /** 
     * Verify if there is 3 thiefs in this assaultParty that finish
     */ 
    private void tryToWakeAll(){
        int num_thieves = 0;
        //if not roomDirection then the thieves are in the CS (for crawl out), change the state of the thieves to collection site
        if(!roomDirection){
            ((NormalThief) Thread.currentThread()).setThiefState(NormalThiefStates.COLLECTION_SITE);
            repo.putThiefState(NormalThiefStates.COLLECTION_SITE, ((NormalThief) Thread.currentThread()).getThiefId());
        }
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
                thieves[0] = null;
                thieves[1] = null;
                thieves[2] = null;
                num_thieves = 0;
                thievesAtParty = 0;
            }
            for(int i = 0; i < SimulPar.K;i++){
                thievesPosition[i] = 0;
            }
        }
    }

}