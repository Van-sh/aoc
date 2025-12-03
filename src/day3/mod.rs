use std::{
    fs::File,
    io::{self, BufRead},
    path::Path,
};

fn find_max_in_arr_slice(arr: &[char]) -> (u64, usize) {
    let mut max_num = 0;
    let mut max_num_index = 0;

    for i in 0..(arr.len()) {
        let num = arr[i].to_digit(10).unwrap() as u64;

        if num > max_num {
            max_num_index = i;
            max_num = num;
        }
    }

    return (max_num, max_num_index);
}

#[allow(dead_code)]
pub fn task1(input_file_path: &Path) {
    let mut total_joltage = 0;

    let file = File::open(input_file_path).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let chars: Vec<_> = line.chars().collect();

        let (max_num, max_num_index) = find_max_in_arr_slice(&chars[0..(chars.len() - 1)]);
        let mut max_joltage = 10 * max_num;

        let (max_num, _) = find_max_in_arr_slice(&chars[(max_num_index + 1)..chars.len()]);
        max_joltage += max_num;

        println!("{}", max_joltage);
        total_joltage += max_joltage;
    }
    println!("{total_joltage}")
}

#[allow(dead_code)]
pub fn task2(input_file_path: &Path) {
    let mut total_joltage: u64 = 0;

    let file = File::open(input_file_path).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let chars: Vec<_> = line.chars().collect();
        let mut max_joltage = 0;
        let mut max_num_index = 0;

        for i in (0..12).rev() {
            let max_num;
            let tmp;

            let start_index = if max_joltage != 0 {
                max_num_index + 1
            } else {
                0
            };

            (max_num, tmp) = find_max_in_arr_slice(&chars[start_index..(chars.len() - i)]);

            max_num_index = start_index + tmp;

            max_joltage = max_joltage * 10 + max_num;
        }

        println!("{}", max_joltage);
        total_joltage += max_joltage;
    }
    println!("{total_joltage}")
}
