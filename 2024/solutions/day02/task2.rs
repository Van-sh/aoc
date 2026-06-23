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

fn task2() {
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
            let mut is_safe = check_safe(record);
            if is_safe {
                return true;
            }
            for i in 0..record.len() {
                is_safe = check_safe(
                    &record[0..i]
                        .iter()
                        .chain(record[(i + 1)..].iter())
                        .copied()
                        .collect::<Vec<_>>(),
                );
                if is_safe {
                    return true;
                }
            }
            false
        })
        .count();

    println!("{result:?}")
}

fn check_safe(record: &[i32]) -> bool {
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
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
