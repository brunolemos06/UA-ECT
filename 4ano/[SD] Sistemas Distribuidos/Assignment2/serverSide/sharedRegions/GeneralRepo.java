package serverSide.sharedRegions;

import serverSide.main.*;

import clientSide.entities.MasterThiefStates;
import clientSide.entities.NormalThiefStates;

import java.io.FileWriter;
import java.io.IOException;

/**
 *  General Repository of Information
 *
 *    It is responsible for logging the internal state of the problem in a file.
 *
 *    It is a shared region.
 */
public class GeneralRepo {
    // javadoc
    /**
     *  General Repository of Information
     *
     *    It is responsible for logging the internal state of the problem in a file.
     *
     *    It is a shared region.
     */

    // private fields
    /**
     * Name of the file where the logging information is stored.
     */
    private String logFileName;

    /**
     * thieves agility
     * 
     */
    private int[] thievesAgility = new int[SimulPar.M-1];
    /**
     * assault party 0
     */
    private int[] assault0 = new int[3];
    /**
     * assault party 1
     */
    private int[] assault1 = new int[3];
    /**
     * room max distance
     */
    private int[] roomaxdist = new int[SimulPar.N];
    /**
     * thief position
     */
    private String[] thiefposition = new String[SimulPar.M-1];
    /**
     * target room 0
     */
    private int targetRoom0 = -1;
    /**
     * target room 1
     */
    private int targetRoom1 = -1;
    /**
     * finish
     */
    private boolean finish = false;

    /**
     * room paintings
     */
    private int[] roomPaintings = new int[SimulPar.N];
    /*
     *  thief has canvas
     */
    private String[] thiefhascanvas = new String[SimulPar.M-1];

    /*
     *  thief state [ P or W ]
     */
    private String[] thiefstateX = new String[SimulPar.M-1];

    /*
     *  master thief state
     */
    private int masterState = MasterThiefStates.PLANNING_THE_HEIST;
    /*
     * thief state
     */
    private int[] thiefState = new int[SimulPar.M-1];

    /*
     *  total canvas
     */
    private int totalcanvas = -1;

    /**
     * Number of shutdowns received
     */
    private int shutdowns = 0;
    
    /**
     * General Repository of Information
     * @param logFileName
     */
    public GeneralRepo(String logFileName) {
        if ((logFileName == null)){
            this.logFileName = "logger";
        }
        else{
            this.logFileName = logFileName;
        }
        // remove file named this.logFileName
        try {
            FileWriter writer = new FileWriter(this.logFileName, false);
            writer.write("");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        for(int i=0;i<3;i++){
            this.assault0[i] = -1;
            this.assault1[i] = -1;
        }
        for(int i=0;i<SimulPar.M-1;i++){
            thiefstateX[i] = "W";
        }

        // has a canvas
        for(int i=0;i<SimulPar.M-1;i++){
            thiefhascanvas[i] = "0";
        }

        // thiefs position
        for(int i=0;i<SimulPar.M-1;i++){
            thiefposition[i] = "00";
        }

        this.masterState = MasterThiefStates.PLANNING_THE_HEIST;
        //  thievs  state
        for (int i = 0; i < SimulPar.M-1; i++) {
            this.thiefState[i] = NormalThiefStates.CONCENTRATION_SITE;
        }

        header();
    }

    // print methods
    /**
     *  Print the header of the log file.
     */
    // public synchronized void header(){
    //     try {
    //         // remove file named this.logFileName
    //         FileWriter writer = new FileWriter(this.logFileName, true);
    //         writer.write("\t\t\t\t\t\tMuseum Heist - Description of the internal state of the problem\n");
    //         writer.write("MstT\tThief 1\t\tThief 2\t\tThief 3\t\tThief 4\t\tThief 5\t\tThief 6\n");
    //         writer.write("Stat\tStat  S  MD\tStat  S  MD\tStat  S  MD\tStat  S  MD\tStat  S  MD\tStat  S  MD\n");
    //         writer.write("\t\t\t\t\tAssault party 1\t\t\t\t\t\tAssault party 2\t\t\t\t\t\t\t\tMuseum\n");
    //         writer.write("\t\t Elem1\t\t Elem 2\t\t Elem 3\t\t\t  Elem1\t\t Elem 2\t\t Elem 3\t\tRoom 1\tRoom 2\tRoom 3\tRoom 4\tRoom 5\n");
    //         writer.write("\tRId\tId Pos Cv\tId Pos Cv\tId Pos Cv\tRId\t Id Pos Cv\tId Pos Cv\tId Pos Cv\t NP DT\t NP DT\t NP DT\t NP DT\t NP DT\n");
    //         // updateInfotemplate(writer);
    //         writer.close();
    //     } catch (IOException e) {
    //         e.printStackTrace();
    //     }
    // }

    private void header(){
        try {
            // remove file named this.logFileName
            FileWriter writer = new FileWriter(this.logFileName, true);
            writer.write("\t\t\t\t\t\tMuseum Heist - Description of the internal state of the problem\n");
            writer.write("MstT\tThief 1\t\tThief 2\t\tThief 3\t\tThief 4\t\tThief 5\t\tThief 6\n");
            writer.write("Stat\tStat  S  MD\tStat  S  MD\tStat  S  MD\tStat  S  MD\tStat  S  MD\tStat  S  MD\n");
            writer.write("\t\t\t\t\tAssault party 1\t\t\t\t\t\tAssault party 2\t\t\t\t\t\t\t\tMuseum\n");
            writer.write("\t\t Elem1\t\t Elem 2\t\t Elem 3\t\t\t  Elem1\t\t Elem 2\t\t Elem 3\t\tRoom 1\tRoom 2\tRoom 3\tRoom 4\tRoom 5\n");
            writer.write("\tRId\tId Pos Cv\tId Pos Cv\tId Pos Cv\tRId\t Id Pos Cv\tId Pos Cv\tId Pos Cv\t NP DT\t NP DT\t NP DT\t NP DT\t NP DT\n");
            // updateInfotemplate(writer);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     *  Print the footer of the log file.
     */
    public synchronized void finish(int totalcanvas){
        this.finish = false;
        // print total canvas in always 2 digits
        this.totalcanvas = totalcanvas;
        try {
            FileWriter writer = new FileWriter(this.logFileName, true);
            writer.write(String.format("My friends, tonight's effort produced %02d priceless paintings!\n\n", this.totalcanvas));
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     *  Update the information in the log file.
     */
    public synchronized void updateInfotemplate(FileWriter writer){
        String[] index = new String[6];
        String[] thiefhascanvas2 = new String[6];
        String[] thiefposition2 = new String[6];

        String[] thiefstateS = new String[6];
        String mststate = "";
        // master thief state
        switch(this.masterState){
            case MasterThiefStates.PLANNING_THE_HEIST:
                mststate = "PLAN";
                break;
            case MasterThiefStates.DECIDING_WHAT_TO_DO:
                mststate = "DWTD";
                break;
            case MasterThiefStates.ASSEMBLING_GROUP:
                mststate = "ASGR";
                break;
            case MasterThiefStates.WAITING_FOR_ARRIVAL:
                mststate = "WAIT";
                break;
            case MasterThiefStates.PRESENTING_THE_REPORT:
                mststate = "REPT";
                break;
        }

        // thief state
        for (int i = 0; i < SimulPar.M-1; i++) {
            switch(this.thiefState[i]){
                case NormalThiefStates.CONCENTRATION_SITE:
                    thiefstateS[i] = "CONS";
                    break;
                case NormalThiefStates.CRAWLING_INWARDS:
                    thiefstateS[i] = " CIN";
                    break;
                case NormalThiefStates.AT_A_ROOM:
                    thiefstateS[i] = "ROOM";
                    break;
                case NormalThiefStates.CRAWLING_OUTWARDS:
                    thiefstateS[i] = "COUT";
                    break;
                case NormalThiefStates.COLLECTION_SITE:
                    thiefstateS[i] = "COLS";
                    break;
            }
        }


        for(int i=0;i<3;i++){
            if (this.assault0[i] == -1){
                index[i] = "-";
                thiefposition2[i] = "-";
                thiefhascanvas2[i] = "-";

            }else{
                index[i] = Integer.toString(this.assault0[i]+1);
                thiefhascanvas2[i] = this.thiefhascanvas[i];
                thiefposition2[i] = this.thiefposition[i];
            }

            if (this.assault1[i] == -1){
                index[i+3] = "-";
                thiefposition2[i+3] = "-";
                thiefhascanvas2[i+3] = "-";
            }else{
                index[i+3] = Integer.toString(this.assault1[i]+1);
                thiefhascanvas2[i+3] = this.thiefhascanvas[i+3];
                thiefposition2[i+3] = this.thiefposition[i+3];
            }
        } 

        
        String[] roomid = new String[2];
        if( this.targetRoom0 == -1){
            roomid[0] = "-";
        }else{
            roomid[0] = Integer.toString(this.targetRoom0+1);
        }
        if( this.targetRoom1 == -1){
            roomid[1] = "-";
        }else{
            roomid[1] = Integer.toString(this.targetRoom1+1);
        }

        if( assault0[0] == -1 && assault0[1] == -1 && assault0[2] == -1){
            roomid[0] = "-";
        }
        
        if( assault1[0] == -1 && assault1[1] == -1 && assault1[2] == -1){
            roomid[1] = "-";
        }
        try {            
            writer.write(String.format("%4s\t%4s  %1s   %01d\t%4s  %1s   %01d\t%4s  %1s   %01d\t%4s  %1s   %01d\t%4s  %1s   %01d\t%4s  %1s   %01d\n",mststate,thiefstateS[0],this.thiefstateX[0],this.thievesAgility[0],thiefstateS[1],this.thiefstateX[1],this.thievesAgility[1],thiefstateS[2],this.thiefstateX[2],this.thievesAgility[2],thiefstateS[3],this.thiefstateX[3],this.thievesAgility[3],thiefstateS[4],this.thiefstateX[4],this.thievesAgility[4],thiefstateS[5],this.thiefstateX[5],this.thievesAgility[5]));
            writer.write(String.format("\t %1s\t %1s\t%2s\t%1s\t %1s\t%2s\t%1s\t %1s\t%2s\t%1s\t %1s\t  %1s\t%2s\t%1s\t %1s\t%2s\t%1s\t %1s\t%2s\t%1s\t %02d %2d\t %02d %02d\t %02d %02d\t %02d %02d\t %02d %02d\t",roomid[0],index[0],thiefposition2[0],thiefhascanvas2[0],index[1],thiefposition2[1],thiefhascanvas2[1],index[2],thiefposition2[2],thiefhascanvas2[2],roomid[1],index[3],thiefposition2[3],thiefhascanvas2[3],index[4],thiefposition2[4],thiefhascanvas2[4],index[5],thiefposition2[5],thiefhascanvas2[5],roomPaintings[0],roomaxdist[0],roomPaintings[1],roomaxdist[1],roomPaintings[2],roomaxdist[2],roomPaintings[3],roomaxdist[3],roomPaintings[4],roomaxdist[4]) + "\n");
        } catch (IOException e) {
        }
    }

    /**
     * Update the log file with the current state of the problem
     */
    public synchronized void updateInfo(){
        if (this.finish){
            return;
        }
        try {
            // remove file named this.logFileName
            FileWriter writer = new FileWriter(this.logFileName, true);
            updateInfotemplate(writer);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
            
    }

    /**
     * Set the thieves in the assault party
     * @param assaultID
     * @param thiefID
     */
    public synchronized void setThiefsInAssault(int assaultID, int thiefID){
        this.thiefStateP(thiefID);
        if (assaultID == 0){
            for (int i = 0; i < 3; i++){
                if (this.assault0[i] == -1){
                    this.assault0[i] = thiefID;
                    break;
                }
            }
        }else{
            for (int i = 0; i < 3; i++){
                if (this.assault1[i] == -1){
                    this.assault1[i] = thiefID;
                    break;
                }
            }
        }
    }

    /**
     * Thief change the position in crawl in and crawl out
     * @param elemid
     * @param AssaultParty
     * @param thiefposition
     */
    public synchronized void changeposition(int elemid,int AssaultParty, int thiefposition){
        if(AssaultParty == 0){
            // if thiefposition == 1 then string = "01"
            // if thiefposition == 10 then string = "10"
            if (thiefposition < 10){
                this.thiefposition[elemid] = "0" + Integer.toString(thiefposition);
            }else{
                this.thiefposition[elemid] = Integer.toString(thiefposition);
            }

        }else if(AssaultParty == 1){
            if (thiefposition < 10){
                this.thiefposition[elemid+3] = "0" + Integer.toString(thiefposition);
            }else{
                this.thiefposition[elemid+3] = Integer.toString(thiefposition);
            }
        }else{
            System.err.print("\n\n\nERROR IN FUNCTION GENERAL REPO changeposition");
            System.exit(1);
        }
        this.updateInfo();
    }

    /**
     * Set Target Room
     * @param assID
     * @param targetRoom
     */
    public synchronized void settargetRoom(int assID,int targetRoom){
        boolean flag = false;
        if(assID == 0){
            if(this.targetRoom0 == targetRoom){
                flag = true;
            }
            this.targetRoom0 = targetRoom;
        }else if(assID == 1){
            if(this.targetRoom1 == targetRoom){
                flag = true;
            }
            this.targetRoom1 = targetRoom;
        }else{
            System.err.print("\n\n\nERROR IN FUNCTION GENERAL REPO settargetRoom");
            System.exit(1);
        }
        if(flag) { this.updateInfo(); }
    }

    /**
     * Change the canvas of the thief in the room
     * @param thiefID
     * @param hasacanvas
     * @param roomid
     * @param assID
     */
    public synchronized void changehasacanvas(int thiefID,int hasacanvas,int roomid,int assID){
        int index = 0;
        // find index in array of thief assault0 and assault1
        if (hasacanvas == 1){
            this.roomPaintings[roomid] -= 1;
        }
        if (assID == 0){
            for(int i=0;i<3;i++){
                if(this.assault0[i] == thiefID){
                    index = i;
                    break;
                }
            }
        }else if(assID == 1){
            for(int i=0;i<3;i++){
                if(this.assault1[i] == thiefID){
                    index = i+3;
                    break;
                }
            }
        }else{
            System.err.print("\n\n\nERROR IN FUNCTION GENERAL REPO changehasacanvas");
            System.exit(1);
        }

        this.thiefhascanvas[index] = Integer.toString(hasacanvas);
        this.updateInfo();
    }
    
    /**
     * Change the state of the thief to W [Wait for Assault Party]
     * @param thiefid
     */
    public synchronized void thiefStateW(int thiefid){
        this.thiefstateX[thiefid] = "W";
        // find index in array of thief assault0 and assault1
        for(int i=0;i<3;i++){
            if(this.assault0[i] == thiefid){
                this.assault0[i] = -1;
                break;
            }

        }
        for(int i=0;i<3;i++){
            if(this.assault1[i] == thiefid){
                this.assault1[i] = -1;
                break;
            }
        }        
        this.updateInfo();
    }

    /**
     * Change the state of the thief to P [Wait for Assault Party]
     * @param thiefid
     */
    public synchronized void thiefStateP(int thiefid){
        this.thiefstateX[thiefid] = "P";
    }

    /**
     * Change the state of the Masterthief
     * @param state
     */
    public synchronized void putMasterState(int state){
        boolean printnow = true;
        if (state == this.masterState) {
            printnow = false;
        }
        this.masterState = state;
        if(printnow){
            this.updateInfo();
        }
    }

    /**
     * Change the state of the thief
     * @param thiefid
     * @param state
     */
    public synchronized void putThiefState(int state, int thiefid){
        boolean printnow = true;
        if (state == this.thiefState[thiefid]) {
            printnow = false;
        }
        this.thiefState[thiefid] = state;
        if(printnow){
            this.updateInfo();
        }
    }

    /**
     * Keeps the agility of the thieves
     */
    public synchronized void setAgility(int[] agility){
        thievesAgility = agility;
    }

    /**
     * Keeps the distance of the rooms
     */
    public synchronized void setRoomsDistance(int[] distance){
        roomaxdist = distance;
    }

    /**
     * Keeps the number of paintings in each room
     */
    public synchronized void setPaintings(int[] paintings){
        roomPaintings = paintings;
    }

    /**
	 * Operation General Repo server shutdown
	 */
	public synchronized void shutdown()
	{
		shutdowns += 1;
		if(shutdowns >= SimulPar.REPO_SHUTDOWN) {
			ServerGeneralRepo.waitConnection = false;
		}
		notifyAll ();
	}

}
