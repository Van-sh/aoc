use std::{fs::File, io::Read, time::Instant};

const PATH: &str = "inputs/day02/input.txt";

fn task1() {
    let mut invalid_id_sum = 0;
    let mut text = String::new();
    let _ = File::open(PATH).unwrap().read_to_string(&mut text).unwrap();

    let ranges = text.trim().split(",").map(|range| {
        range
            .split("-")
            .map(|s| s.parse::<i64>().unwrap())
            .collect::<Vec<_>>()
    });

    for range in ranges {
        for id in range[0]..=range[1] {
            let mut width = 0;
            while 10_i64.pow(width) <= id {
                width += 1;
            }

            if width % 2 == 1 {
                continue;
            }

            let cutoff = 10_i64.pow(width / 2);
            let left = id / cutoff;
            let right = id % cutoff;

            if left == right {
                invalid_id_sum += id;
            }
        }
    }
    println!("{invalid_id_sum}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
