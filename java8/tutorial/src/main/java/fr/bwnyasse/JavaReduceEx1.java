package fr.bwnyasse;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

/**
 * JavaStream
 */
public class JavaReduceEx1 {

  public static class Car {

    private final String name;
    private final int price;

    public Car(String name, int price) {

      this.name = name;
      this.price = price;
    }

    public int getPrice() {
      return price;
    }

    @Override
    public String toString() {
      StringBuilder builder = new StringBuilder();
      builder.append("Car{name=").append(name).append(", price=").append(price).append("}");

      return builder.toString();
    }
  }

  public static void main(String[] args) {
    List<Car> persons = Arrays.asList(new Car("Skoda", 18544), new Car("Volvo", 22344), new Car("Fiat", 23650),
        new Car("Renault", 19700));

    Optional<Car> car = persons.stream().reduce((c1, c2) -> c1.getPrice() > c2.getPrice() ? c1 : c2);

    car.ifPresent(System.out::println);
  }

}
