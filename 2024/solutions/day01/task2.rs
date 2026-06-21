use std::{
    collections::HashMap,
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day01/input.txt";

fn task1() {
    let mut result = 0;

    let file = File::open(PATH).expect("Unable to read file");
    let lines = io::BufReader::new(file)
        .lines()
        .map(|line| {
            let values = line
                .unwrap()
                .split_whitespace()
                .map(|num| num.parse::<u32>().expect("Couldn't parse a number"))
                .collect::<Vec<_>>();

            (values[0], values[1])
        })
        .collect::<Vec<_>>();

    let mut left_values = Vec::new();
    let mut right_counts = HashMap::new();

    for line in &lines {
        left_values.push(line.0);
        *right_counts.entry(line.1).or_insert(0) += 1
    }

    for left in &left_values {
        result += left * right_counts.get(left).unwrap_or(&0);
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
