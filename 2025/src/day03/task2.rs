use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day03/input.txt";

fn task2() {
    let mut total_joltage = 0_u64;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let chars = line.chars().collect::<Vec<_>>();
        let mut max_joltage = 0;
        let mut max_num_index = 0;

        for i in (0..12).rev() {
            let max_num;
            let tmp;

            (max_num, tmp) = find_max_in_arr_slice(&chars[max_num_index..(chars.len() - i)]);

            max_num_index += tmp + 1;

            max_joltage = max_joltage * 10 + max_num;
        }

        println!("{}", max_joltage);
        total_joltage += max_joltage;
    }
    println!("{total_joltage}")
}

fn find_max_in_arr_slice(arr: &[char]) -> (u64, usize) {
    let mut max_num = 0;
    let mut max_num_index = 0;

    for (i, ch) in arr.iter().enumerate() {
        let num = ch.to_digit(10).unwrap() as u64;

        if num > max_num {
            max_num_index = i;
            max_num = num;
        }
    }

    (max_num, max_num_index)
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
