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
    let mut frequencies = vec![0_u64; origin_line.len()];
    frequencies[idx] = 1;

    for line in lines.map_while(Result::ok) {
        let prev_frequencies = frequencies.clone();
        for idx in 0..prev_frequencies.len() {
            let frequency = prev_frequencies[idx];
            if frequency == 0 {
                continue;
            }
            if &line[idx..(idx + 1)] == "^" {
                if idx > 0 {
                    frequencies[idx - 1] += frequency;
                }
                if idx < line.len() - 1 {
                    frequencies[idx + 1] += frequency;
                }
                frequencies[idx] -= frequency;
            }
        }
    }

    let timelines = frequencies.iter().sum::<u64>();
    println!("{timelines}");
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
