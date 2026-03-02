use std::{
    cmp::Ordering,
    collections::BinaryHeap,
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day05/input.txt";

#[allow(dead_code)]
pub fn task1() {
    let mut valid_ids = 0;

    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    let mut ranges = Vec::<(u64, u64)>::new();

    for line in lines.by_ref().map_while(Result::ok) {
        if line.len() == 0 {
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

#[allow(dead_code)]
pub fn task2() {
    let mut valid_ids = 0u64;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    let mut heap = BinaryHeap::new();
    for line in lines.map_while(Result::ok) {
        if line.len() == 0 {
            break;
        }

        let range = line
            .split("-")
            .map(|limit| limit.parse::<u64>().unwrap())
            .collect::<Vec<_>>();

        let range = Range {
            low: range[0],
            high: range[1],
        };

        heap.push(range);
    }

    // Increasing order
    let ranges = heap.into_sorted_vec();

    let mut prev_range = Option::<Range>::None;

    for curr_range in ranges {
        println!("{:?}", curr_range);
        match prev_range {
            None => {
                prev_range = Some(curr_range);
                valid_ids += curr_range.high - curr_range.low + 1;
            }
            Some(prev_range_value) => {
                if prev_range_value.high >= curr_range.low {
                    if prev_range_value.high > curr_range.high {
                        println!("Already accounted for");
                        continue;
                    }
                    valid_ids += curr_range.high - prev_range_value.high;
                    println!("expanding {:?} with {:?}", prev_range_value, curr_range);
                    println!(
                        "{}-{} | {}",
                        prev_range_value.high, curr_range.high, valid_ids
                    );
                    prev_range = Some(Range {
                        high: curr_range.high,
                        ..prev_range_value
                    });
                    continue;
                } else {
                    prev_range = Some(curr_range);
                    valid_ids += curr_range.high - curr_range.low + 1;
                }
            }
        }
        println!("{}-{} | {}", curr_range.low, curr_range.high, valid_ids);
    }

    println!("{valid_ids}")
}

#[derive(Debug, Eq, PartialEq, Copy, Clone)]
struct Range {
    low: u64,
    high: u64,
}

impl Ord for Range {
    fn cmp(&self, other: &Self) -> Ordering {
        return self.low.cmp(&other.low);
    }
}

impl PartialOrd for Range {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}
