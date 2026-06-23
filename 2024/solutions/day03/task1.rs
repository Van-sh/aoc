use std::{fs, time::Instant};

use regex::Regex;

const PATH: &str = "inputs/day03/input.txt";

fn task1() {
    let mut result = 0;

    let pattern = Regex::new(r#"mul\((\d{1,3}),(\d{1,3})\)"#).unwrap();
    let input = fs::read_to_string(PATH).expect("Couldn't read file");

    for (_, [num1, num2]) in pattern.captures_iter(&input).map(|c| c.extract()) {
        result += num1
            .parse::<i32>()
            .unwrap_or_else(|_| panic!("Couldn't parse {num1}"))
            * num2
                .parse::<i32>()
                .unwrap_or_else(|_| panic!("Couldn't parse {num2}"));
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
