package fr.bwnyasse;

import javax.sound.sampled.SourceDataLine;

/**
 * JavaDefaultMethod
 */
public class JavaDefaultMethod {

  public interface Moveable {
    default void move() {
      System.out.println(this.getClass().getSimpleName() + " : I am moving");
    }
  }

  public interface AnotherMoveable {
    default void move() {
      System.out.println("Great move");
    }
  }

  public static class Car implements Moveable {
  }

  public static class Animal implements Moveable {
    @Override
    public void move() {
      System.out.println(this.getClass().getSimpleName() + ": I am running");
    }
  }

  public static class Athele implements Moveable, AnotherMoveable {

    @Override
    public void move() {
      AnotherMoveable.super.move();
    }
  }

  public static void main(String[] args) {

    Car car = new Car();
    car.move();

    Animal animal = new Animal();
    animal.move();

    Athele athele = new Athele();
    athele.move();
  }

}