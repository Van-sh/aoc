use std::path::Path;

pub mod day1;
pub mod day2;
pub mod day3;
pub mod day4;

const PATH: &str = "inputs/day4/input.txt";

fn main() {
    day4::task2(Path::new(PATH));
}
