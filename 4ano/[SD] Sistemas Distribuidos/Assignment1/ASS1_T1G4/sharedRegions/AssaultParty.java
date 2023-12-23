package sharedRegions;

import entities.*;
import main.SimulPar;

public class AssaultParty {

    private static final int maxThieves = SimulPar.K;

    private int assaultID;
    private int roomDistance;
    private int maxThievesDistance = 3;
    private int targetRoom;
    private int thievesAtParty;
    private NormalThief[] thieves;
    private int[] thievesPosition;
    private boolean roomDirection;
    private GeneralRepo repo;
    
    // constructor
    public AssaultParty(int assaultID,GeneralRepo repo) {
        this.assaultID = assaultID;
        this.maxThievesDistance = 3;
        this.thievesAtParty = 0;
        this.thieves = new NormalThief[maxThieves];
        this.thievesPosition = new int[maxThieves];
        this.roomDirection = true;
        this.repo = repo;
    }



    // get methods
    public int getAssaultID() {
        return assaultID;
    }

    public int getRoomDistance() {
        return roomDistance;
    }

    public int getMaxThievesDistance() {
        return maxThievesDistance;
    }

    public int getTargetRoom() {
        return targetRoom;
    }

    public NormalThief[] getThieves() {
        return thieves;
    }



    // set methods
    public synchronized void setAssaultID(int assaultID) {
        this.assaultID = assaultID;
    }

    public synchronized void setTargetRoom(int targetRoom) {
        this.targetRoom = targetRoom;
    }

    public synchronized void addThief(){
        for (int i = 0; i < maxThieves; i++) {
            if(this.thieves[i] == null){
                this.thieves[i] = (NormalThief) Thread.currentThread();
                thievesAtParty++;
                notifyAll();
                repo.setThiefsInAssault(assaultID,((NormalThief) Thread.currentThread()).getThiefId());
                break;
            }
        }
    }

    public synchronized void setRoomDistance(int roomDistance) {
        this.roomDistance = roomDistance;
    }
    
    public synchronized void reverseDirection(){
        ((NormalThief) Thread.currentThread()).setThiefState(NormalThiefStates.CRAWLING_OUTWARDS);
        roomDirection =false;
        // start crawling out
        thieves[0].setCrawling(1);
        
    }

    // Usefull methods
    public synchronized void crawlIn(){
        int walk = -1;
        while(true){
            // wait until crawlin == 1
            while(((NormalThief) Thread.currentThread()).getCrawling() == 0){
                try{
                    wait();
                }catch(Exception e){
                    System.err.println(e);
                }
            }
            
            while(canImove(walk)){
                walk = moveTheMostICan();
                int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
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
        tryToWakeAll();
    }

    public synchronized void crawlOut(){
        int walk = -1;
        while(true){
            // wait until crawlin == 1
            while(((NormalThief) Thread.currentThread()).getCrawling() == 0){
                try{
                    wait();
                }catch(Exception e){
                    System.err.println(e);
                }
            }
            
            while(canImove(walk)){
                walk = moveTheMostICan();
                int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
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

    public synchronized void sendAssaultParty(){
        ((MasterThief) (Thread.currentThread())).setThiefState(MasterThiefStates.DECIDING_WHAT_TO_DO);
        
        this.roomDirection = true;
        thieves[0].setCrawling(1);
        notifyAll();
    }

    public synchronized void waitForThivesToBeReady(){
        while(thievesAtParty < maxThieves){
            try{
                wait();
            }catch(Exception e){
                System.err.println(e);
            }
        }
    }


    // internal methods
    private void goToSleep(){
        ((NormalThief) Thread.currentThread()).setCrawling(0);
    }

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
                int above = findTrueIndex(thievesPosition, min);
                thieves[above].setCrawling(1);
            }
            else{
                if(thievesPosition[id] == max){
                    // wake up the thief above me
                    int above = findTrueIndex(thievesPosition, midle);
                    if(midle < 0){ }
                    thieves[above].setCrawling(1);
                }
                else if(thievesPosition[id] == min){
                    // wake up the thief above me
                    int above;
                    if (max >= this.roomDistance){
                        above = findTrueIndex(thievesPosition, midle);
                    }
                    else{
                        above = findTrueIndex(thievesPosition, max);
                    }
                    
                    thieves[above].setCrawling(1);
                }
                else if(thievesPosition[id] == midle){
                    // wake up the thief above me
                    int above = findTrueIndex(thievesPosition, min);
                    thieves[above].setCrawling(1);
                }else{
                    System.err.println("ERROR");
                }
            }
        }



    }

    private int findTrueIndex(int[] array, int value){
        for (int i = 0; i < maxThieves; i++) {
            if(array[i] == value){
                return i;
            }
        }
        System.err.print("findTrueIndex ERROR");
        return -1;
    }

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

    private boolean valitateWalk(int walk){
        // i cant move if one of the Thieves is in the same position as me
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        int pos = thievesPosition[id];
        for (int i = 0; i < maxThieves; i++) {
            if(i != id || pos + walk != roomDistance - 1){
                if(thievesPosition[i] == pos + walk){
                    return false;
                }
            }
        }
        int[] newpos = new int[maxThieves];
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

    private int max(int[] array){
        int max = 0;
        for (int i = 0; i < maxThieves; i++) {
            if(array[i] > max){
                max = array[i];
            }
        }
        return max;
    }

    private int min(int[] array){
        // find the min value in the array
        int min = array[0];
        for (int i = 0; i < maxThieves; i++) {
            if(array[i] < min){
                min = array[i];
            }
        }
        return min;
    }

    private int midle(int[] array){
        int max = max(array);
        int secoundmax = 0;
        for (int i = 0; i < maxThieves; i++) {
            if(array[i] > secoundmax && array[i] < max){
                secoundmax = array[i];
            }
        } 
        return secoundmax;
    }

    private boolean finish(){
        // finish when position of this Thieves is the same as the target room -1
        int id = tranformID(((NormalThief) Thread.currentThread()).getThiefId());
        int pos = thievesPosition[id];
        return pos >= roomDistance;
    }

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

    private int tranformID(int ThiefID){
        for(int i = 0; i < maxThieves; i++){
            if(thieves[i] != null){
                if(thieves[i].getThiefId() == ThiefID){
                    return i;
                }
            }
        }
        System.exit(1);
        return -1;
    }
    
    private void tryToWakeAll(){
        int num_thieves = 0;
        //if not roomDirection then the thieves are in the CS (for crawl out), change the state of the thieves to collection site
        if(!roomDirection){
            ((NormalThief) Thread.currentThread()).setThiefState(NormalThiefStates.COLLECTION_SITE);
        }
        for(int i = 0; i < maxThieves;i++){
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
            for(int i = 0; i < maxThieves;i++){
                thievesPosition[i] = 0;
            }
        }
    }

}