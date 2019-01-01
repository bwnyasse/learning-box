package fr.bwnyasse;

import java.util.stream.IntStream;

/**
 * JavaReduceEx2
 */
public class JavaReduceEx2 {

  static class MyUtil {

    public static int add2Ints(int num1, int num2) {
      return num1 + num2;
    }
  }

  public static void main(String[] args) {
    IntStream.range(1, 10).reduce((x, y) -> x + y).ifPresent(s -> System.out.println(s));
    IntStream.range(1, 10).reduce(Integer::sum).ifPresent(s -> System.out.println(s));
    IntStream.range(1, 10).reduce(MyUtil::add2Ints).ifPresent(s -> System.out.println(s));
  }
}