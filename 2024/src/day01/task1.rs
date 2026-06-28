use std::{
    cmp::Reverse,
    collections::BinaryHeap,
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

    let mut left_values = BinaryHeap::new();
    let mut right_values = BinaryHeap::new();

    for line in &lines {
        left_values.push(Reverse(line.0));
        right_values.push(Reverse(line.0));
    }

    while let Some(Reverse(left)) = left_values.pop() {
        let Some(Reverse(right)) = right_values.pop() else {
            panic!("found extra elements in left: {left} {left_values:?}")
        };

        result += left.abs_diff(right)
    }
    if let Some(Reverse(right)) = right_values.pop() {
        panic!("Found extra elements in right {right} {right_values:?}")
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
