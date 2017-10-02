public class Log extends Expression {
    private Expression a, b;

    // log(b)/log(a)
    public Log(Expression a, Expression b) {
        this.a = a;
        this.b = b;
    }

    public double evaluate() {
        return Math.log(b.evaluate()) / Math.log(a.evaluate());
    }

    public String toString() {
        if (a instanceof Number) {
            if (b instanceof Number) {
                return "log" + a + "(" + b + ")";
            } else {
                return "log" + a + b;
            }
        } else {
            if (b instanceof Number) {
                return "(log" + b + " / log" + a + ")";
            } else {
                return "(log" + b + " / log(" + a + "))";
            }    
        }
    }
}
