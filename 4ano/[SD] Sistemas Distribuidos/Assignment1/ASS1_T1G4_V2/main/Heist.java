package main;

import entities.*;
import sharedRegions.*;

import java.util.Scanner;   // to read from the keyboard
import java.io.File;        // to check if a file exists
import java.util.Random;    // to generate random numbers

/**
* Heist to the Museum (main program)
*/
public class Heist {

    /**
    * Main program.
    */
    public static void main(String[] args) {
        MasterThief masterThief;
        NormalThief[] thieves = new NormalThief[SimulPar.M-1];
    
        ControlCollectionSite controlCollectionSite;
        ConcentrationSite concentrationSite;
        AssaultParty[] assaultParty = new AssaultParty[SimulPar.N_PARTIES];
        Museum museum;
        GeneralRepo repo;

        Random rand = new Random();
    
        String fileName;                                     // logging file name
        char opt;                                            // selected option
        boolean success=false;                               // end of operation flag



        System.out.println("Heist to the Museum");

        Scanner sc = new Scanner(System.in);
        do{
            System.out.print("Logging file name: ");
            fileName = sc.nextLine();
            File file = new File(fileName);
            if (file.exists()){
                do{
                    System.out.println("File already exists!\n");
                    System.out.println("Do you want to overwrite it? (y/n): ");
                    String input = sc.nextLine();
                    try{
                        opt = input.charAt(0);
                    }catch (StringIndexOutOfBoundsException e){
                        opt = 'y';
                    }
                } while (opt != 'y' && opt != 'n');

                if (opt == 'n')
                    success = false;
                else
                    success = true;
            }else{
                success = true;
            }
        } while (!success);

        sc.close();



        int [] roomDistance = new int[SimulPar.N];
        int [] paintings = new int[SimulPar.N];
        int [] agilities = new int[SimulPar.M-1];
        for (int i = 0; i < SimulPar.M-1; i++) {
            int agility = rand.nextInt(6-2+1)+2;
            agilities[i] = agility;
        }
        for (int i = 0; i < roomDistance.length; i++) {
            roomDistance[i] = rand.nextInt(30-15+1) + 15;
            paintings[i] = rand.nextInt(16-8+1) + 8;
        }

        repo = new GeneralRepo(fileName,agilities,roomDistance,paintings);
        repo.header();

        for (int i = 0; i < SimulPar.N_PARTIES; i++) {
            assaultParty[i] = new AssaultParty(i,repo);
        }
        controlCollectionSite = new ControlCollectionSite(repo, assaultParty);

        concentrationSite = new ConcentrationSite(assaultParty, roomDistance, repo);
        museum = new Museum(repo, assaultParty, paintings);

        for (int i = 0; i < SimulPar.M-1; i++) {
            thieves[i] = new NormalThief(i, agilities[i],controlCollectionSite, concentrationSite, assaultParty, museum);
        }

        masterThief = new MasterThief(controlCollectionSite, concentrationSite, assaultParty);

        /* start of the simulation */
        for (int i = 0; i < SimulPar.M-1; i++)
            thieves[i].start ();
        
        masterThief.start ();

        /* wait for the end of the simulation */
        for(int i = 0; i < SimulPar.M-1; i++){
            try{
                thieves[i].join ();
            }catch (InterruptedException e){
                System.out.println("The thief " + i + " was interrupted!");
            }
            System.out.println("The thief " + i + " has terminated!");
        }

        try{
            masterThief.join ();
        }catch (InterruptedException e){
            System.out.println("The master thief was interrupted!");
        }
        System.out.println("The master thief has terminated!");
    }
}
