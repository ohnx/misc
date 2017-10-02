public class Number extends Expression {
    private double a;

    // a
    public Number(double a) {
        this.a = a;
    }

    public double evaluate() {
        return a;
    }

    public String toString() {
        return Double.toString(a);
    }
}
