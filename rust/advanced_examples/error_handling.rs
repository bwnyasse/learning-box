fn main() {
    // Example of error handling in Rust using Result and Option types

    // Function that returns a Result type
    fn divide(dividend: f64, divisor: f64) -> Result<f64, String> {
        if divisor == 0.0 {
            Err(String::from("Cannot divide by zero"))
        } else {
            Ok(dividend / divisor)
        }
    }

    // Function that returns an Option type
    fn get_element(vec: &Vec<i32>, index: usize) -> Option<i32> {
        if index < vec.len() {
            Some(vec[index])
        } else {
            None
        }
    }

    // Using the divide function
    match divide(10.0, 2.0) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }

    match divide(10.0, 0.0) {
        Ok(result) => println!("Result: {}", result),
        Err(e) => println!("Error: {}", e),
    }

    // Using the get_element function
    let vec = vec![1, 2, 3, 4, 5];
    match get_element(&vec, 2) {
        Some(value) => println!("Element: {}", value),
        None => println!("Element not found"),
    }

    match get_element(&vec, 10) {
        Some(value) => println!("Element: {}", value),
        None => println!("Element not found"),
    }
}
