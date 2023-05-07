public class Fraction {
    int numerador;
    int denominador; 
    public Fraction(int n,int d){
        this.numerador = n;
        this.denominador = d;
    }
    public Fraction Mul(Fraction b){
        return new Fraction(this.numerador*b.numerador, b.denominador*this.denominador);
    }
    public Fraction Div(Fraction b){
        return new Fraction(this.numerador*b.denominador, this.denominador*b.numerador);
    }
    public Fraction Add(Fraction b){
        return new Fraction(this.numerador*b.denominador+b.numerador*this.denominador,this.denominador*b.denominador);
    }
    public Fraction Sub(Fraction b){
        return new Fraction(this.numerador*b.denominador-b.numerador*this.denominador,this.denominador*b.denominador);
    }
    @Override
    public String toString(){
        if(this.denominador != 1)
            System.out.printf("%d/%d\n",this.numerador,this.denominador);
        else
            System.out.printf("%d\n",this.numerador);
        return "";
    }
}
