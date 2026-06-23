use std::{fs, time::Instant};

use regex::Regex;

const PATH: &str = "inputs/day03/input.txt";

fn task2() {
    let mut result = 0;

    let pattern = Regex::new(r#"do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)"#).unwrap();
    let input = fs::read_to_string(PATH).expect("Couldn't read file");

    let mut enabled = true;
    for capture in pattern.captures_iter(&input) {
        let string = capture.get_match().as_str();
        if string == "do()" {
            enabled = true;
        } else if string == "don't()" {
            enabled = false;
        } else if enabled {
            let num1 = capture
                .get(1)
                .expect("Didn't find first match in mul")
                .as_str();
            let num2 = capture
                .get(2)
                .expect("Didn't find second match in mul")
                .as_str();

            result += num1
                .parse::<i32>()
                .unwrap_or_else(|_| panic!("Couldn't parse {num1}"))
                * num2
                    .parse::<i32>()
                    .unwrap_or_else(|_| panic!("Couldn't parse {num2}"));
        }
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
