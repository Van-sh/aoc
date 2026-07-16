use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day06/input.txt";

fn task1() {
    let mut result = 0_u64;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file)
        .lines()
        .map(|line| line.unwrap())
        .collect::<Vec<_>>();

    let mut split_lines = Vec::new();
    for line in &lines {
        let line = line.split_whitespace().collect::<Vec<_>>();
        split_lines.push(line);
    }

    let operations = split_lines.pop().unwrap();

    for (i, &operation) in operations.iter().enumerate() {
        let mut accum = match operation {
            "*" => 1_u64,
            "+" => 0_u64,
            _ => panic!("Invalid input"),
        };
        for split_line in &split_lines {
            match operation {
                "*" => {
                    accum *= split_line[i].parse::<u64>().unwrap();
                }
                "+" => {
                    accum += split_line[i].parse::<u64>().unwrap();
                }
                _ => panic!("Invalid input"),
            }
        }
        result += accum
    }

    println!("{result}");
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
