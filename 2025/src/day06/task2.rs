use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day06/input.txt";

fn task2() {
    let mut result = 0_u64;

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
            "+" => 0_u64,
            "*" => 1_u64,
            _ => panic!("Invalid input"),
        };
        while col < lines[0].len() {
            let mut is_num = false;

            let mut num = 0_u64;
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

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
