package LFA.guiao01.exercicio;
import java.util.*;
public class ex03 {
    public static void main(String[] args) {
        Stack<Double> stack = new Stack<Double>();
        Scanner sc = new Scanner(System.in);
        while(true){
            String linha = sc.nextLine();
            String[] tokens = linha.split(" ");
            try{
                for(String s : tokens){
                    try{
                        stack.add(Double.parseDouble(s));
                        System.out.println(stack.toString());
                    }catch(Exception e){
                        char op = s.charAt(0);
                        boolean status = true;
                        if(stack.size()>=2){
                            double op1 = stack.pop();
                            double op2 = stack.pop();
                            switch (op) {
                                case '*':
                                    stack.add(op1*op2); 
                                    break;
                                case '+':
                                    stack.add(op1+op2); 
                                    break;
                                case '/':
                                    stack.add(op1/op2); 
                                    break;
                                case '-':
                                    stack.add(op1-op2); 
                                    break;
                                default:
                                    status = false;
                                    System.out.println("Erro de sintaxe");
                                    break;
                            }
                            if(status)System.out.println(stack.toString());
                            else break;
                        }else{
                            System.out.println("Erro de sintaxe");
                        }
                    }
                }
            }catch(Exception e){
                System.out.print("Erro de sintaxe");
            }
        }
    }
}
