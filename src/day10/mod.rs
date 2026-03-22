use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day10/input.txt";
const EPSILON: f64 = 1e-9;

fn combination_util<T: Clone + std::fmt::Debug>(
    arr: &Vec<T>,
    result: &mut Vec<Vec<T>>,
    data: &mut Vec<T>,
    r: usize,
    index: usize,
) {
    if data.len() == r {
        result.push(data.to_vec());
        return;
    }

    for i in index..arr.len() {
        data.push(arr[i].clone());
        combination_util(arr, result, data, r, i + 1);

        data.pop();
    }
}

fn find_all_combinations<T: Clone + std::fmt::Debug>(arr: &Vec<T>) -> Vec<Vec<Vec<T>>> {
    let mut result = Vec::new();

    for r in 1..arr.len() {
        let mut intermediate_result = Vec::new();

        let mut data = Vec::<T>::new();
        combination_util(arr, &mut intermediate_result, &mut data, r, 0);
        result.push(intermediate_result);
    }

    result
}

pub fn task1() {
    let mut total_button_presses = 0;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let mut line = line.split_whitespace().collect::<Vec<_>>();

        let _joltage_requirements_not_used_for_task1 = line.pop();

        let light_diagram = line.remove(0);
        let light_diagram = &light_diagram[1..(light_diagram.len() - 1)];
        let light_diagram = light_diagram
            .chars()
            .map(|light| light == '#')
            .collect::<Vec<_>>();

        let wiring_schematics = line
            .iter()
            .map(|schematic| {
                let schematic = &schematic[1..(schematic.len() - 1)];
                schematic
                    .split(",")
                    .map(|num| num.parse::<usize>().unwrap())
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();

        println!("{:?} {:?}", light_diagram, wiring_schematics);

        let combinations = find_all_combinations(&wiring_schematics);

        for combinations in combinations {
            let mut done = false;
            for combination in combinations {
                println!("Combination {:?}", combination);
                let mut lights = vec![false; light_diagram.len()];
                let presses = combination.len();

                for wirings in combination {
                    for wire in wirings {
                        lights[wire] = !lights[wire];
                    }
                }
                println!("{:?}", lights);
                if lights == light_diagram {
                    total_button_presses += presses;
                    done = true;
                    break;
                }
            }
            if done {
                break;
            }
        }
    }

    println!("{total_button_presses}");
}

fn find_all_presses(wiring_schematics: &[Vec<usize>], joltage_requirements: &[usize]) -> usize {
    let matrix = Matrix::new(wiring_schematics, joltage_requirements);
    let max = joltage_requirements.iter().max().unwrap() + 1;
    let mut min = usize::MAX;
    let mut values = vec![0; matrix.independents.len()];
    dfs(&matrix, 0, &mut values, &mut min, max);

    min
}

struct Matrix {
    data: Vec<Vec<f64>>,
    rows: usize,
    cols: usize,
    dependents: Vec<usize>,
    independents: Vec<usize>,
}

impl Matrix {
    fn new(wiring_schematics: &[Vec<usize>], joltage_requirements: &[usize]) -> Self {
        let rows = joltage_requirements.len();
        let cols = wiring_schematics.len();
        let mut data = vec![vec![0.0; cols + 1]; rows];

        for (c, button) in wiring_schematics.iter().enumerate() {
            for &r in button {
                if r < rows {
                    data[r][c] = 1.0;
                }
            }
        }
        for (r, &val) in joltage_requirements.iter().enumerate() {
            data[r][cols] = val as f64;
        }

        let mut matrix = Self {
            data,
            rows,
            cols,
            dependents: Vec::new(),
            independents: Vec::new(),
        };
        matrix.gaussian_elimination();

        matrix
    }

    fn gaussian_elimination(&mut self) {
        let mut pivot = 0;
        let mut col = 0;
        let mut pivot_cols = vec![false; self.cols];

        while pivot < self.rows && col < self.cols {
            let mut best_row = pivot;
            for r in pivot + 1..self.rows {
                if self.data[r][col].abs() > self.data[best_row][col].abs() {
                    best_row = r;
                }
            }

            if self.data[best_row][col].abs() < EPSILON {
                col += 1;
                continue;
            }

            self.data.swap(pivot, best_row);
            self.dependents.push(col);
            pivot_cols[col] = true;

            let pv = self.data[pivot][col];
            for val in &mut self.data[pivot][col..=self.cols] {
                *val /= pv;
            }

            for r in 0..self.rows {
                if r != pivot {
                    let factor = self.data[r][col];
                    for c in col..=self.cols {
                        self.data[r][c] -= factor * self.data[pivot][c];
                    }
                }
            }
            pivot += 1;
            col += 1;
        }
        for (c, col) in pivot_cols.iter().enumerate().take(self.cols) {
            if !col {
                self.independents.push(c);
            };
        }
    }

    fn valid(&self, values: &[usize]) -> Option<usize> {
        let mut total = values.iter().sum::<usize>();
        for (row, &_dep_col) in self.dependents.iter().enumerate() {
            let mut val = self.data[row][self.cols];
            for (i, &ind_col) in self.independents.iter().enumerate() {
                val -= self.data[row][ind_col] * (values[i] as f64);
            }
            if val < -EPSILON {
                return None;
            }
            let rounded = val.round();
            if (val - rounded).abs() > EPSILON {
                return None;
            }
            total += rounded as usize;
        }
        Some(total)
    }
}

fn dfs(matrix: &Matrix, idx: usize, values: &mut Vec<usize>, min: &mut usize, max: usize) {
    if idx == matrix.independents.len() {
        if let Some(total) = matrix.valid(values) {
            *min = (*min).min(total);
        }
        return;
    }
    let current_sum: usize = values[..idx].iter().sum();
    for val in 0..max {
        if current_sum + val >= *min {
            break;
        } // Pruning [1]
        values[idx] = val;
        dfs(matrix, idx + 1, values, min, max);
    }
}

pub fn task2() {
    let mut total_button_presses = 0;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    for line in lines.map_while(Result::ok) {
        let mut line = line.split_whitespace().collect::<Vec<_>>();

        let joltage_requirements = line.pop().unwrap();
        let joltage_requirements = &joltage_requirements[1..(joltage_requirements.len() - 1)];
        let joltage_requirements = joltage_requirements
            .split(",")
            .map(|num| num.parse::<usize>().unwrap())
            .collect::<Vec<_>>();

        let _light_diagram_not_used_for_task2 = line.remove(0);

        let wiring_schematics = line
            .iter()
            .map(|schematic| {
                let schematic = &schematic[1..(schematic.len() - 1)];
                schematic
                    .split(",")
                    .map(|num| num.parse::<usize>().unwrap())
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>();

        println!("{:?} {:?}", wiring_schematics, joltage_requirements);

        let min_presses = find_all_presses(&wiring_schematics, &joltage_requirements);

        println!("{:?}", min_presses);
        total_button_presses += min_presses
    }

    println!("{total_button_presses}");
}
