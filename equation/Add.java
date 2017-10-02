public class Add extends Expression {
    private Expression a, b;

    // a + b
    public Add(Expression a, Expression b) {
        this.a = a;
        this.b = b;
    }

    public double evaluate() {
        return a.evaluate() + b.evaluate();
    }

    public String toString() {
        return "(" + a + " + " + b + ")";
    }
}
