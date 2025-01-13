use std::time::Duration;
use tokio::time::sleep;

// An example demonstrating async/await in Rust

// An asynchronous function that simulates some work by sleeping for a given duration
async fn do_work(id: u32, duration: Duration) {
    println!("Task {} started", id);
    sleep(duration).await;
    println!("Task {} completed", id);
}

#[tokio::main]
async fn main() {
    // Create a vector of async tasks
    let tasks = vec![
        tokio::spawn(do_work(1, Duration::from_secs(2))),
        tokio::spawn(do_work(2, Duration::from_secs(1))),
        tokio::spawn(do_work(3, Duration::from_secs(3))),
    ];

    // Wait for all tasks to complete
    for task in tasks {
        task.await.unwrap();
    }

    println!("All tasks completed");
}
