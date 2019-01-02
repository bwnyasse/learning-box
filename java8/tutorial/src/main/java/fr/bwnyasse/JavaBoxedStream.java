package fr.bwnyasse;

import java.util.stream.Collectors;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

/**
 * JavaBoxedStream
 */
public class JavaBoxedStream {

  /**
   * In Java 8, if you want to convert stream of objects to collection, then you
   * can use one of the static methods in the Collectors class
   * 
   * 
   * The same process doesn’t work on streams of primitives, however.
   * 
   * @param args
   */
  public static void main(String[] args) {

    IntStream stream = IntStream.of(1, 2, 3, 4, 5);
    stream.boxed().collect(Collectors.toList()).forEach(System.out::println);

    System.out.println("---------------------------------");

    LongStream.of(1l, 2l, 3l, 4l, 5l).boxed().collect(Collectors.toList()).forEach(System.out::println);
    System.out.println("---------------------------------");

    DoubleStream.of(1d, 2d, 3d, 4d, 5d).boxed().collect(Collectors.toList()).forEach(System.out::println);
  }

}
