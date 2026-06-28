use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day05/input.txt";

fn task1() {
    let mut valid_ids = 0;

    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    let mut ranges = Vec::<(u64, u64)>::new();

    for line in lines.by_ref().map_while(Result::ok) {
        if line.is_empty() {
            break;
        }

        let limits = line.split("-").collect::<Vec<_>>();
        ranges.push((limits[0].parse().unwrap(), limits[1].parse().unwrap()));
    }

    println!("ranges: {:?}", ranges);

    for line in lines.by_ref().map_while(Result::ok) {
        let id = line.parse::<u64>().unwrap();
        println!("Checking {}", id);

        for (low, high) in &ranges {
            if low <= &id && &id <= high {
                println!("{} found between {} and {}", id, low, high);
                valid_ids += 1;
                break;
            }
        }
    }

    println!("{valid_ids}");
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
