public class Root extends Expression {
    private Expression a, b;

    // b^(1/a)
    public Root(Expression a, Expression b) {
        this.a = a;
        this.b = b;
    }

    public double evaluate() {
        return Math.pow(b.evaluate(), 1/a.evaluate());
    }

    public String toString() {
        return "(" + b + " ^ (1/" + a + "))";
    }
}
