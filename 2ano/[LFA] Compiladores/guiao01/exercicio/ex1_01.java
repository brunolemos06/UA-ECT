package LFA.guiao01.exercicio;

import java.util.Scanner;
public class ex1_01 {
    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        while(true){
            System.out.print("Introduzir conta matemática: ");
            String linha = sc.nextLine();
            String[] sep = linha.split(" ");
            try{
                double op1 = Double.parseDouble(sep[0]);
                double op2 = Double.parseDouble(sep[2]);
                String result = getresult(sep[1],op1,op2);
                if(result == null) throw new Exception();
                System.out.printf("%f %s %f = %s\n",op1,sep[1],op2,result);
                break;
            }
            catch(Exception e){
                System.out.println("Sintaxe inválida !");
            }
        }
    }
    public static String getresult(String op,double op1,double op2){
        Double result= 0.0;
        switch (op) {
            case "+":
                result = op1 + op2;
                break;
            case "-":
                result = op1 - op2;
                break;
            case "*":
                result = op1 * op2;
                break;
            case "/":
                result = op1 / op2;
                break;
            default:
                return null;
        }
        return Double.toString(result);
    }
}
