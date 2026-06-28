use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day02/input.txt";

#[derive(Debug)]
enum Change {
    Initial(i32),
    Increasing(i32),
    Decreasing(i32),
}

fn task1() {
    let file = File::open(PATH).expect("Unable to read file");
    let result = io::BufReader::new(file)
        .lines()
        .map(|line| {
            line.expect("Line should be present")
                .split_whitespace()
                .map(|num| num.parse::<i32>().expect("Couldn't parse a level of input"))
                .collect::<Vec<_>>()
        })
        .filter(|record| {
            let first = record[0];

            record[1..]
                .iter()
                .try_fold(Change::Initial(first), |change, level| match change {
                    Change::Initial(prev_level) => {
                        if *level > prev_level && *level <= prev_level + 3 {
                            Ok(Change::Increasing(*level))
                        } else if *level < prev_level && *level >= prev_level - 3 {
                            Ok(Change::Decreasing(*level))
                        } else {
                            Err(())
                        }
                    }
                    Change::Increasing(prev_level) => {
                        if *level > prev_level && *level <= prev_level + 3 {
                            Ok(Change::Increasing(*level))
                        } else {
                            Err(())
                        }
                    }
                    Change::Decreasing(prev_level) => {
                        if *level < prev_level && *level >= prev_level - 3 {
                            Ok(Change::Decreasing(*level))
                        } else {
                            Err(())
                        }
                    }
                })
                .is_ok()
        })
        .count();

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
