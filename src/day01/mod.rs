use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day01/input.txt";

#[allow(dead_code)]
pub fn task1() {
    let mut dial_pos = 50;
    let mut zero_count = 0;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let direction: &str = &line[0..1];
        let amount: i32 = line[1..].parse().unwrap();
        match direction {
            "L" => dial_pos = (dial_pos - amount) % 100,
            "R" => dial_pos = (dial_pos + amount) % 100,
            &_ => panic!("Found invalid direction"),
        }

        if dial_pos < 0 {
            dial_pos += 100;
        }

        if dial_pos == 0 {
            zero_count += 1;
        }
    }
    println!("{zero_count}");
}

#[allow(dead_code)]
pub fn task2() {
    let mut dial_pos = 50;
    let mut zero_count = 0;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let direction: &str = &line[0..1];
        let mut amount: i32 = line[1..].parse().unwrap();
        if amount >= 100 {
            zero_count += amount / 100;
            amount %= 100;
        }
        let mut new_dial_pos = match direction {
            "L" => dial_pos - amount,
            "R" => dial_pos + amount,
            &_ => panic!("Invalid input"),
        };

        if new_dial_pos >= dial_pos {
            if new_dial_pos >= 100 {
                zero_count += 1;
            }

            dial_pos = new_dial_pos % 100;
        } else {
            if new_dial_pos <= 0 && dial_pos > 0 {
                zero_count += 1;
            }

            new_dial_pos = if new_dial_pos < 0 {
                100 + new_dial_pos
            } else {
                new_dial_pos
            };

            dial_pos = new_dial_pos;
        }
    }
    println!("{zero_count}");
}
