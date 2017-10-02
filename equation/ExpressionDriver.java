public class ExpressionDriver {
    public static void main(String[] args) {
        Expression ee = new Multiply(new Number(-3), new Power( new Number(2.5), new Number(4) ) ); 
        ee = new Divide(new Add(ee, new Power(new Number(10), new Subtract(new Number(10), new Number(9)))), new Number(10));
        ee = new Root(new Number(2), new Subtract(new Number(0), ee));
        System.out.println(ee.evaluate());
        System.out.println(ee);
        ee = new Add(new Log(new Number(10), new Multiply(new Power(new Number(2), new Number(5)), new Power(new Number(5), new Number(5)))), new Root(new Number(2), new Number(4)));
        System.out.println(ee.evaluate());
        System.out.println(ee);
    }
}
