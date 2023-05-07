package LFA.guiao01.exercicio;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.HashMap;
import java.util.*;

public class ex04 {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        HashMap<String,String> map = new HashMap<>();
        try{
            FileReader arq = new FileReader("../Bloco1/bloco1/numbers.txt");
            BufferedReader ler = new BufferedReader(arq);
            String linha = ler.readLine();
            while(linha != null){
                String[] token = linha.split(" - ");
                map.put(token[1],token[0]);
                linha = ler.readLine();
            }      
        }catch(Exception e){
            e.printStackTrace();
        }

        while(true){
            String total = "";
            String phrase = sc.nextLine().toLowerCase();
            String[] word = phrase.split(" ");
            for(String s : word){
                if(map.containsKey(s)){
                    total+=map.get(s)+" ";
                }else{
                    total+=s+" ";
                }
            }
            System.out.print("Frase traduzida: "+total+"\n");
        }
    }
}
