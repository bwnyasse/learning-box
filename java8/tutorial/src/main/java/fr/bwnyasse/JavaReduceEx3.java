package fr.bwnyasse;

import java.time.LocalDate;
import java.time.chrono.IsoChronology;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * JavaReduceEx3
 */
public class JavaReduceEx3 {

  static class User {

    private String name;
    private LocalDate dateOfBirth;

    public User(String name, LocalDate dateOfBirth) {
      this.name = name;
      this.dateOfBirth = dateOfBirth;
    }

    public String getName() {
      return name;
    }

    public void setName(String name) {
      this.name = name;
    }

    public LocalDate getDateOfBirth() {
      return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
      this.dateOfBirth = dateOfBirth;
    }

    public int getAge() {
      return dateOfBirth.until(IsoChronology.INSTANCE.dateNow()).getYears();
    }

    @Override
    public String toString() {

      StringBuilder builder = new StringBuilder();
      builder.append("User{name=").append(name).append(", dateOfBirth=").append(dateOfBirth).append("}");

      return builder.toString();
    }
  }

  private static List<User> users() {
    List<User> users = new ArrayList<>();
    users.add(new User("Frank", LocalDate.of(1979, 11, 23)));
    users.add(new User("Peter", LocalDate.of(1985, 1, 18)));
    users.add(new User("Lucy", LocalDate.of(2002, 5, 14)));
    users.add(new User("Albert", LocalDate.of(1996, 8, 30)));
    users.add(new User("Frank", LocalDate.of(1967, 10, 6)));
    return users;
  }

  public static void main(String[] args) {

    int maxAge = users().stream().mapToInt(User::getAge).reduce(0, (a1, a2) -> a1 > a2 ? a1 : a2);
    System.out.printf("The oldest user's age: %s%n", maxAge);

    Optional<User> oldMan = users().stream().reduce((a1, a2) -> a1.getAge() > a2.getAge() ? a1 : a2);
    oldMan.ifPresent(System.out::println);

  }
}