use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day04/input.txt";

fn task2() {
    let mut result = 0;

    let file = File::open(PATH).expect("Unable to read file");
    let grid = io::BufReader::new(file)
        .lines()
        .map(|line| {
            line.expect("Couldn't read a line from the file")
                .chars()
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    for i in 1..(grid.len() - 1) {
        for j in 1..(grid[i].len() - 1) {
            if grid[i][j] != 'A' {
                continue;
            }

            let mut count = 0;
            'y_loop: for y in (-1..=1).step_by(2) {
                for x in (-1..=1).step_by(2) {
                    if grid[i.checked_add_signed(y).unwrap()][j.checked_add_signed(x).unwrap()]
                        == 'M'
                        && grid[i.checked_sub_signed(y).unwrap()][j.checked_sub_signed(x).unwrap()]
                            == 'S'
                    {
                        count += 1;
                    }

                    if count == 2 {
                        result += 1;
                        break 'y_loop;
                    }
                }
            }
        }
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
