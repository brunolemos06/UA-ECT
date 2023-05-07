package LFA.guiao01.exercicio;
import java.io.IOException;
import java.util.*;


class ex1_2{
    static Scanner sc = new Scanner(System.in);
    static HashMap<String, Double> vars = new HashMap<String, Double>();
    public static void main(String[] args) {
        System.out.println("Introduza uma operacao\n");
        while(sc.hasNextLine()){   
            Double val1 = 0.0, val2 = 0.0, result = 0.0;
            while(true){
                String line = sc.nextLine();
                try{
                    String[] tokens = line.split(" ");
                    if(tokens.length < 3){
                        System.err.println("Uso errado, exemplo : 15 * 3");
                    }else{
                        char op = tokens[1].charAt(0);
                        if (op == '='){
                            //E atribuicao
                            if(Character.isLetter(tokens[0].charAt(0))){
                                try{
                                    vars.put(tokens[0], expressao(Arrays.copyOfRange(tokens, 2, tokens.length)));
                                } catch (Exception e){

                                }
                                
                            } else {
                                System.err.println("O nome da variavel e invalido!");
                            }
                        } else {
                            //E operacao
                            System.out.println(expressao(tokens));

                        }
                    }
                } catch (Exception e){
                    System.err.println(("Operador desconhecido"));
                }
            }
        }
    }
    static double expressao(String[] tokens) throws IOException{
        double result = 0.0;
        if (tokens.length != 1 && tokens.length!=3){
            System.err.println("Operacao invalida!");
            throw new IOException("Invalid operation");
        } else if(tokens.length == 3){
            double val1 = valor(tokens[0]);
            double val2 = valor(tokens[2]);
            switch(tokens[1].charAt(0)){
                case '+':
                    result = val1 + val2;
                    break;
                case '-':
                    result = val1 - val2;
                    break;
                case '*':
                    result = val1 * val2;
                    break;
                case '/':
                    result = val1 / val2;
                    break;
                default:
                    System.err.printf("Operador desconhecido!\n");
                    throw new IOException("Operador desconhecido");
            }
        } else {
            result = valor(tokens[0]);
        }
        return result;
    }

    static double valor(String str) throws IOException{
        double res;
        if (Character.isLetter(str.charAt(0))) {
            if(vars.containsKey(str)){
                res = vars.get(str);
            }else{
                System.err.println(("Variable doesnt exist!"));
                throw new IOException("Variable doesnt exist!");
            }
        } else {
            res = Double.parseDouble(str);
        }
        return res;
    }
}
