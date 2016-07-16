package fr.bwnyasse.lambdaexpressions;

/**
 * A lambda expression is characterized by the following syntax −
 * <p>
 * parameter -> expression body
 * </p>
 * 
 * Following are the important characteristics of a lambda expression − <br/>
 * 
 * <ul>
 * 
 * <li>Optional type declaration − No need to declare the type of a parameter.
 * The compiler can inference the same from the value of the parameter.</li>
 * <br/>
 * 
 * <li>Optional parenthesis around parameter − No need to declare a single
 * parameter in parenthesis. For multiple parameters, parentheses are required.
 * </li> <br/>
 * 
 * <li>Optional curly braces − No need to use curly braces in expression body if
 * the body contains a single statement.</li> <br/>
 * 
 * <li>Optional return keyword − The compiler automatically returns the value if
 * the body has a single expression to return the value. Curly braces are
 * required to indicate that expression returns a value.</li><br/>
 * 
 * </ul>
 * 
 * The important points to be considered in the above example.
 * <p>
 * 
 * <ul>
 * 
 * <li>Lambda expressions are used primarily to define inline implementation of
 * a functional interface, i.e., an interface with a single method only. In the
 * above example, we've used various types of lambda expressions to define the
 * operation method of MathOperation interface. Then we have defined the
 * implementation of sayMessage of GreetingService.</li>
 * 
 * <li>Lambda expression eliminates the need of anonymous class and gives a very
 * simple yet powerful functional programming capability to Java.</li>
 * 
 * <br/>
 * 
 * @author bwnyasse
 *
 */
public class UseCaseTester {
	public static void main(String args[]) {
		UseCaseTester tester = new UseCaseTester();

		// with type declaration
		MathOperation addition = (int a, int b) -> a + b;

		// with out type declaration
		MathOperation subtraction = (a, b) -> a - b;

		// with return statement along with curly braces
		MathOperation multiplication = (int a, int b) -> {
			return a * b;
		};

		// without return statement and without curly braces
		MathOperation division = (int a, int b) -> a / b;

		System.out.println("10 + 5 = " + tester.operate(10, 5, addition));
		System.out.println("10 - 5 = " + tester.operate(10, 5, subtraction));
		System.out.println("10 x 5 = " + tester.operate(10, 5, multiplication));
		System.out.println("10 / 5 = " + tester.operate(10, 5, division));

		// with parenthesis
		GreetingService greetService1 = message -> System.out.println("Hello " + message);

		// without parenthesis
		GreetingService greetService2 = (message) -> System.out.println("Hello " + message);

		greetService1.sayMessage("Mahesh");
		greetService2.sayMessage("Suresh");
	}

	interface MathOperation {
		int operation(int a, int b);
	}

	interface GreetingService {
		void sayMessage(String message);
	}

	private int operate(int a, int b, MathOperation mathOperation) {
		return mathOperation.operation(a, b);
	}
}