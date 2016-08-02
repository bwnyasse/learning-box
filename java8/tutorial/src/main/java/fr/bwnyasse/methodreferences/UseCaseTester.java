package fr.bwnyasse.methodreferences;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

public class UseCaseTester {
	public static void main(String args[]) {

		List<String> names = new ArrayList<>();

		names.add("Mahesh");
		names.add("Suresh");
		names.add("Ramesh");
		names.add("Naresh");
		names.add("Kalpesh");

		names.forEach(System.out::println);

		Function<Double, Double> square = Hey::square;
		double squareValue = square.apply(23d);
		System.out.println(squareValue);

		Hey hey = new Hey();
		Function<Double, Double> cube = hey::cube;
		double cubeVallue = cube.apply(23d);
		System.out.println(cubeVallue);
	}

}

class Hey {
	public static double square(double num) {
		return Math.pow(num, 2);
	}

	public double cube(double num) {
		return Math.pow(num, 3);
	}
}
