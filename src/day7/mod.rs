use std::{
    collections::HashSet,
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day7/input.txt";

#[allow(dead_code)]
pub fn task1() {
    let mut encountered_splitters = 0;
    let mut indexes = HashSet::new();

    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    let origin_line = lines.next().unwrap().unwrap();
    let idx = origin_line.find("S").unwrap();
    indexes.insert(idx);

    for line in lines.map_while(Result::ok) {
        for idx in indexes.clone() {
            if &line[idx..(idx + 1)] == "^" {
                encountered_splitters += 1;
                println!("Splitter found at {}", idx);
                if idx < line.len() - 1 {
                    indexes.insert(idx + 1);
                }
                if idx > 0 {
                    indexes.insert(idx - 1);
                }
                indexes.remove(&idx);
            }
        }
    }

    let mut indexes = indexes.iter().collect::<Vec<_>>();
    indexes.sort();
    println!("{:?}", indexes);
    println!("{encountered_splitters}")
}

#[allow(dead_code)]
pub fn task2() {
    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    let origin_line = lines.next().unwrap().unwrap();
    let idx = origin_line.find("S").unwrap();
    let mut frequencies = vec![0u64; origin_line.len()];
    frequencies[idx] = 1;

    for line in lines.map_while(Result::ok) {
        let mut next_frequencies = Vec::from(frequencies.clone());
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
