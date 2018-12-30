package fr.bwnyasse;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;

class Java8ForEach {

    public static void main(String[] args) {

        example1();
        System.out.println("----------------");
        example2();
        System.out.println("----------------");
        example3();
    }

    /**
     * Java program to iterate over all elements of a stream and perform an action.
     * In this example, we are printing all even numbers.
     */
    public static void example1() {
        ArrayList<Integer> numberList = new ArrayList<>(Arrays.asList(1, 2, 3, 4, 5));

        numberList.stream().filter(n -> n % 2 == 0).forEach(System.out::println);
    }

    /**
     * Java program to iterate over all entries of a HashMap and perform an action.
     * We can also iterate over map keys and values and perform any action on all
     * elements.
     * 
     */
    public static void example2() {
        HashMap<String, Integer> map = new HashMap<>();

        map.put("A", 1);
        map.put("B", 2);
        map.put("C", 3);

        // 1. Map entries
        Consumer<Map.Entry<String, Integer>> action = System.out::println;

        map.entrySet().forEach(action);

        // 2. Map keys
        Consumer<String> actionOnKeys = System.out::println;

        map.keySet().forEach(actionOnKeys);

        // 3. Map values
        Consumer<Integer> actionOnValues = System.out::println;

        map.values().forEach(actionOnValues);

    }

    /**
     * Create custom consumer action
     */
    public static void example3() {
        HashMap<String, Integer> map = new HashMap<>();

        map.put("A", 1);
        map.put("B", 2);
        map.put("C", 3);

        Consumer<Map.Entry<String, Integer>> displayEntry = entry -> {
            System.out.println("key:" + entry.getKey());
            System.out.println("value:" + entry.getValue());
        };

        map.entrySet().forEach(displayEntry);
    }
}