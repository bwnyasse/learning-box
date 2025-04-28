use std::collections::HashMap;

fn main() {
    // Create a new HashMap to store the names and ages of people
    let mut people = HashMap::new();

    // Insert some data into the HashMap
    people.insert("Alice", 30);
    people.insert("Bob", 25);
    people.insert("Charlie", 35);

    // Print the names and ages of the people in the HashMap
    for (name, age) in &people {
        println!("{} is {} years old.", name, age);
    }

    // Calculate the average age of the people in the HashMap
    let total_age: i32 = people.values().sum();
    let average_age = total_age as f32 / people.len() as f32;
    println!("The average age is {:.2}.", average_age);
}
