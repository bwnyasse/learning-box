package fr.bwnyasse;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * /** /** JavaStream
 */
public class JavaStream {

  private static List<String> memberNames = Arrays.asList("Amitabh", "Shekhar", "Aman", "Rahul", "Shahrukh", "Salman",
      "Yana", "Lokesh");

  public static void main(String[] args) {
    terminalOperations();
  }

  // Stream.of(val1, val2, val3….)
  private static void example1() {
    Stream<Integer> stream = Stream.of(1, 2, 3, 4, 5, 6, 7, 8, 9);
    stream.forEach(p -> System.out.println(p));
  }

  // Stream.of(arrayOfElements)
  private static void example2() {
    Stream<Integer> stream = Stream.of(new Integer[] { 1, 2, 3, 4, 5, 6, 7, 8, 9 });
    stream.forEach(p -> System.out.println(p));
  }

  // List.stream()
  private static void example3() {
    List<Integer> list = new ArrayList<Integer>();

    for (int i = 1; i < 10; i++) {
      list.add(i);
    }
    Stream<Integer> stream = list.stream();
    stream.forEach(p -> System.out.println(p));
  }

  // Stream.generate() or Stream.iterate()
  private static void example4() {
    // Stream<Date> stream = Stream.generate(() -> {
    // return new Date();
    // });
    // stream.forEach(p -> System.out.println(p));

    Stream<Integer> stream = Stream.iterate(2, n -> n * 2);
    stream.forEach(p -> {
      if (p == Math.pow(2, 10))
        throw new RuntimeException();
      System.out.println(p);
    });
  }

  // Stream.collect( Collectors.toList() )
  private static void example5() {
    Stream<Integer> stream = Stream.of(new Integer[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 });
    List<Integer> evenNumbersList = stream.filter(i -> i % 2 == 0).collect(Collectors.toList());
    System.out.print(evenNumbersList);
  }

  // Stream.toArray( EntryType[]::new )
  private static void example6() {
    Stream<Integer> stream = Stream.of(new Integer[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 });
    Integer[] evenNumbersArr = stream.filter(i -> i % 2 == 0).toArray(Integer[]::new);
    System.out.print(evenNumbersArr);
  }

  /**
   * Intermediate operations return the stream itself so you can chain multiple
   * method calls in a row. Let’s learn important ones.
   */
  private static void intermediateOperations() {
    // filter
    memberNames.stream().filter((s) -> s.startsWith("A")).forEach(System.out::println);

    // map
    memberNames.stream().filter((s) -> s.startsWith("A")).map(String::toUpperCase).forEach(System.out::println);

    // sorted
    memberNames.stream().sorted().filter((s) -> s.startsWith("A")).map(String::toUpperCase)
        .forEach(System.out::println);
  }

  /**
   * Terminal operations return a result of a certain type instead of again a
   * Stream.
   */
  private static void terminalOperations() {

    // collect
    List<String> memNamesInUppercase = memberNames.stream().sorted().map(String::toUpperCase)
        .collect(Collectors.toList());
    System.out.println(memNamesInUppercase);

    // match
    boolean matchedResult = memberNames.stream().anyMatch((s) -> s.startsWith("A"));

    System.out.println(matchedResult);

    matchedResult = memberNames.stream().allMatch((s) -> s.startsWith("A"));

    System.out.println(matchedResult);

    matchedResult = memberNames.stream().noneMatch((s) -> s.startsWith("A"));

    System.out.println(matchedResult);

    // count
    long countStartWithA = memberNames.stream() //
        .filter((s) -> s.startsWith("A")) //
        .count();
    System.out.println(countStartWithA);

    // reduce
    Optional<String> reduced = memberNames.stream() //
        .reduce((s1, s2) -> s1 + "#" + s2);
    System.out.println(reduced);
  }

  private static void reduceExample() {
    int vals[] = { 2, 4, 6, 8, 10, 12, 14, 16 };

    // Predefined reduce example
    int sum = Arrays.stream(vals).sum();
    System.out.printf("The sum of values: %d%n", sum);

    long n = Arrays.stream(vals).count();
    System.out.printf("The number of values: %d%n", n);

  }

}
