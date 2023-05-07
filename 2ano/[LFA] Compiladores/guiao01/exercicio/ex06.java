import java.io.BufferedReader;
import java.io.FileReader;
import java.util.*;
public class ex06{
    public static void main(String[] args) {
        String path = "../Bloco1/bloco1/";
        Scanner sc = new Scanner(System.in);
        ArrayList<HashMap<String,String>> ficheiros = new ArrayList<HashMap<String,String>>();
        try{
            for(String file : args){
                if(file.contains("dic"))ficheiros.add(getDictMap(path+file));
                else if(file.contains("board")) ficheiros.add(colletctBoard(path+file));
            }
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("Erro 400");
        }
        String[] mudado = changewithdic(ficheiros);
        for(String in : mudado){
            System.out.printf(" %s",in);
        }


    }
    public static HashMap<String,String> getDictMap(String file){
        HashMap<String,String> mapa = new HashMap<>();
        try{
            FileReader arq = new FileReader(file);
            BufferedReader ler = new BufferedReader(arq);
            String linha = ler.readLine();
            while(linha != null){
                String[] token = linha.split(" ");
                mapa.put(token[0],token[1]);
                linha = ler.readLine();
            }
            ler.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return mapa;
    }
    public static String[] changewithdic(String[] inputs,ArrayList<HashMap<String,String>> ficheiros){
        for(HashMap<String,String> mapa : ficheiros){
            for(int i=0;i<inputs.length;i++){
                if(mapa.containsKey(inputs[i])){
                    inputs[i] = mapa.get(inputs[i]);
                }
            }
        }
        return inputs;

    }
    public static HashMap<String,String> colletctBoard(String file){
        HashMap<String,String> mapa = new HashMap<>();
        try{
            FileReader arq = new FileReader(file);
            BufferedReader ler = new BufferedReader(arq);
            String linha = ler.readLine();
            while(linha != null){
                String[] token = linha.split(" ");
                for(String x : token) mapa.put(x,null);
                linha = ler.readLine();
            }
            ler.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return mapa;
    }
}