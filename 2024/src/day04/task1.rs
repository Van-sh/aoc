use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day04/input.txt";
const XMAS: [char; 4] = ['X', 'M', 'A', 'S'];

fn task1() {
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

    for (i, row) in grid.iter().enumerate() {
        for (j, character) in row.iter().enumerate() {
            if *character != XMAS[0] {
                continue;
            }

            let y_start: isize = if i < XMAS.len() - 1 { 0 } else { -1 };
            let y_end: isize = if i > grid.len() - XMAS.len() { 0 } else { 1 };
            let x_start: isize = if j < XMAS.len() - 1 { 0 } else { -1 };
            let x_end: isize = if j > row.len() - XMAS.len() { 0 } else { 1 };

            for y in y_start..=y_end {
                for x in x_start..=x_end {
                    if y == 0 && x == 0 {
                        continue;
                    };

                    for (ch_index, ch) in XMAS[1..].iter().enumerate() {
                        let ch_index = ch_index as isize + 1;

                        let y = i
                            .checked_add_signed(y * ch_index)
                            .expect("y offset exploded");
                        let x = j
                            .checked_add_signed(x * ch_index)
                            .expect("x offset exploded");

                        if grid[y][x] != *ch {
                            break;
                        } else if ch_index == 3 {
                            result += 1;
                        }
                    }
                }
            }
        }
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
