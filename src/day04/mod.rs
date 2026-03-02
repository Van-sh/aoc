use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day04/input.txt";

#[allow(dead_code)]
pub fn task1() {
    let mut accessible_rolls = 0;

    let file = File::open(PATH).unwrap();

    let grid: Vec<_> = io::BufReader::new(file)
        .lines()
        .map(|line| -> Vec<_> {
            line.unwrap()
                .chars()
                .map(|ch| match ch {
                    '.' => 0,
                    '@' => 1,
                    _ => panic!("Invalid input"),
                })
                .collect()
        })
        .collect();

    for i in 0..grid.len() {
        for j in 0..grid[i].len() {
            if grid[i][j] != 1 {
                continue;
            }

            let on_top_edge = i == 0;
            let on_bottom_edge = i == grid.len() - 1;
            let on_left_edge = j == 0;
            let on_right_edge = j == grid[0].len() - 1;

            // Corners always accessible
            if (on_top_edge || on_bottom_edge) && (on_left_edge || on_right_edge) {
                println!("Found {} at corner ({}, {})", grid[i][j], i, j);
                accessible_rolls += 1;
                continue;
            }

            let mut neighbours = 0;

            for y in 0..=2 {
                if (on_top_edge && y == 0) || (on_bottom_edge && y == 2) {
                    continue;
                }
                for x in 0..=2 {
                    if (on_left_edge && x == 0) || (on_right_edge && x == 2) {
                        continue;
                    }
                    // The number itself
                    if x == 1 && y == 1 {
                        continue;
                    }

                    neighbours += grid[i + y - 1][j + x - 1];
                }
            }

            if neighbours < 4 {
                println!(
                    "Found {} at ({}, {}) with {} neighbours",
                    grid[i][j], i, j, neighbours
                );
                accessible_rolls += 1;
            }
        }
    }

    println!("{accessible_rolls}");
}

#[allow(dead_code)]
pub fn task2() {
    let mut accessible_rolls = 0;

    let file = File::open(PATH).unwrap();

    let mut grid: Vec<_> = io::BufReader::new(file)
        .lines()
        .map(|line| -> Vec<_> {
            line.unwrap()
                .chars()
                .map(|ch| match ch {
                    '.' => 0,
                    '@' => 1,
                    _ => panic!("Invalid input"),
                })
                .collect()
        })
        .collect();

    let mut iter = 0;
    loop {
        println!("Iteration - {}", iter);
        iter += 1;
        let mut accessible_rolls_coords = Vec::<(usize, usize)>::new();

        for i in 0..grid.len() {
            for j in 0..grid[i].len() {
                if grid[i][j] != 1 {
                    continue;
                }

                let on_top_edge = i == 0;
                let on_bottom_edge = i == grid.len() - 1;
                let on_left_edge = j == 0;
                let on_right_edge = j == grid[0].len() - 1;

                // Corners always accessible
                if (on_top_edge || on_bottom_edge) && (on_left_edge || on_right_edge) {
                    println!("Found {} at corner ({}, {})", grid[i][j], i, j);
                    accessible_rolls_coords.push((i, j));
                    continue;
                }

                let mut neighbours = 0;

                for y in 0..=2 {
                    if (on_top_edge && y == 0) || (on_bottom_edge && y == 2) {
                        continue;
                    }
                    for x in 0..=2 {
                        if (on_left_edge && x == 0) || (on_right_edge && x == 2) {
                            continue;
                        }
                        // The number itself
                        if x == 1 && y == 1 {
                            continue;
                        }

                        neighbours += grid[i + y - 1][j + x - 1];
                    }
                }

                if neighbours < 4 {
                    println!(
                        "Found {} at ({}, {}) with {} neighbours",
                        grid[i][j], i, j, neighbours
                    );
                    accessible_rolls_coords.push((i, j));
                }
            }
        }

        accessible_rolls += accessible_rolls_coords.len();

        if accessible_rolls_coords.len() == 0 {
            break;
        }

        for coord in accessible_rolls_coords {
            grid[coord.0][coord.1] = 0;
        }
    }

    println!("{accessible_rolls}");
}
