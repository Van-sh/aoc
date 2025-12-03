use std::path::Path;

pub mod day1;
pub mod day2;
pub mod day3;

const PATH: &str = "inputs/day3/input.txt";

fn main() {
    day3::task2(Path::new(PATH));
}
