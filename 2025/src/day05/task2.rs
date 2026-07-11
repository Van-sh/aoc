use std::{
    cmp::Ordering,
    collections::BinaryHeap,
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day05/input.txt";

fn task2() {
    let mut valid_ids = 0_u64;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    let mut heap = BinaryHeap::new();
    for line in lines.map_while(Result::ok) {
        if line.is_empty() {
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
                if prev_range_value.high > curr_range.high {
                    println!("Already accounted for");
                } else if prev_range_value.high >= curr_range.low {
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
        self.low.cmp(&other.low)
    }
}

impl PartialOrd for Range {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
