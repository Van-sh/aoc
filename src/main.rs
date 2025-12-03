mod day1;

use std::path::Path;

const PATH: &str = "inputs/day1/input.txt";

fn main() {
    day1::task2(Path::new(PATH));
}
