public class Variable extends Expression {
    private char name;

    public Variable(char name) {
        this.name = name;
    }

    public double evaluate() {
        return 0;
    }

    public String toString() {
        return name;
    }
}
