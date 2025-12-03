mod day1;
mod day2;

use std::path::Path;

const PATH: &str = "inputs/day2/input.txt";

fn main() {
    day2::task2(Path::new(PATH));
}
