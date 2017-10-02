public class Power extends Expression {
    private Expression a, b;

    // a^b
    public Power(Expression a, Expression b) {
        this.a = a;
        this.b = b;
    }

    public double evaluate() {
        return Math.pow(a.evaluate(), b.evaluate());
    }

    public String toString() {
        return "(" + a + " ^ "+ b + ")";
    }
}
