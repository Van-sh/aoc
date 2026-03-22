use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day06/input.txt";

pub fn task1() {
    let mut result = 0u64;

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
        println!("{}", operation);
        let mut accum = match operation {
            "*" => 1u64,
            "+" => 0u64,
            _ => panic!("Invalid input"),
        };
        for split_line in &split_lines {
            println!("{}", split_line[i]);
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
        println!("{}", accum);
        result += accum
    }

    println!("{result}");
}

pub fn task2() {
    let mut result = 0u64;

    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file)
        .lines()
        .map(|line| line.unwrap())
        .collect::<Vec<_>>();

    let operations = lines.pop().unwrap();
    let operations = operations.split_whitespace().collect::<Vec<_>>();
    let lines = lines
        .iter()
        .map(|line| line.chars().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    let mut col = 0;
    for operation in operations {
        println!("{operation}");
        let mut accum = match operation {
            "+" => 0u64,
            "*" => 1u64,
            _ => panic!("Invalid input"),
        };
        while col < lines[0].len() {
            let mut is_num = false;

            let mut num = 0u64;
            for line in &lines {
                if let Some(digit) = line[col].to_digit(10) {
                    is_num = true;
                    num = num * 10 + digit as u64;
                }
            }

            col += 1;
            if !is_num {
                break;
            }
            println!("\t\tnum: {num}");
            accum = match operation {
                "+" => accum + num,
                "*" => accum * num,
                _ => panic!("Invalid input"),
            }
        }
        println!("\taccum: {accum}");
        result += accum;
    }

    println!("result: {result}");
}
