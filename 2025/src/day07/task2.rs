use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day07/input.txt";

fn task2() {
    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    let origin_line = lines.next().unwrap().unwrap();
    let idx = origin_line.find("S").unwrap();
    let mut frequencies = vec![0u64; origin_line.len()];
    frequencies[idx] = 1;

    for line in lines.map_while(Result::ok) {
        let mut next_frequencies = frequencies.clone();
        println!("{line}");
        for idx in 0..frequencies.len() {
            let frequency = frequencies[idx];
            if frequency == 0 {
                continue;
            }
            if &line[idx..(idx + 1)] == "^" {
                if idx > 0 {
                    next_frequencies[idx - 1] += frequency;
                }
                if idx < line.len() - 1 {
                    next_frequencies[idx + 1] += frequency;
                }
                next_frequencies[idx] -= frequency;
            }
        }
        println!("{:?}", next_frequencies);
        frequencies = next_frequencies;
    }

    let mut timelines = 0;
    for frequency in frequencies {
        timelines += frequency;
    }
    println!("{timelines}");
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
