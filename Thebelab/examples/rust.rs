extern crate chrono;
use chrono::Local;

let date = Local::now();

println!("Hello World: {}", date.format("%Y-%m-%d %H:%M:%S"));
