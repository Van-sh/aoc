use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day10/input.txt";

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

    return result;
}

#[allow(dead_code)]
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
                let schematic = schematic
                    .split(",")
                    .map(|num| num.parse::<usize>().unwrap())
                    .collect::<Vec<_>>();
                return schematic;
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
