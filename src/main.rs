use std::path::Path;

pub mod day1;
pub mod day2;
pub mod day3;
pub mod day4;
pub mod day5;

const PATH: &str = "inputs/day5/input.txt";

fn main() {
    day5::task2(Path::new(PATH));
}
