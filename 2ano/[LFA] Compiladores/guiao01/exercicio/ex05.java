package LFA.guiao01.exercicio;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Scanner;
import java.util.Stack;

public class ex05 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Stack<Integer> stack = new Stack<Integer>();
        HashMap<String,Integer> mapa = new HashMap<>();
        try{
            FileReader arq = new FileReader("../Bloco1/bloco1/numbers.txt");
            BufferedReader ler = new BufferedReader(arq);
            String linha = ler.readLine();
            while(linha != null){
                String[] token = linha.split(" - ");
                mapa.put(token[1],Integer.parseInt(token[0]));
                linha = ler.readLine();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        
        while(true){
            String phrase = sc.nextLine().toLowerCase();
            String[] word = phrase.split(" |\\-");
            Collections.reverse(Arrays.asList(word));
            try{
                for(String s : word){
                    if(mapa.containsKey(s))stack.add(mapa.get(s));
                    else if(!s.equals("and")){
                        throw new Exception();
                    }
                }
            }catch(Exception e){
                System.out.print("Sintaxe errada");
                break;
            }
            int num1 = stack.pop();
            int aux = 0;
            int total =0;
            while(stack.size() >= 1){
                aux = num1;
                while(num1 < stack.peek()){
                    num1 = stack.pop();
                    aux*= num1;
                }
                num1 = stack.pop();
                total+=aux;
                if(stack.isEmpty())total+=num1;
            }
            System.out.print(phrase+"-> "+total+"\n");
            stack.clear();
        }
    }
}
