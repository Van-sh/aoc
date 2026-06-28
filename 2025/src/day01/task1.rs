use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day01/input.txt";

fn task1() {
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

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
