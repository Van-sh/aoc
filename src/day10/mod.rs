use std::{
    collections::{HashMap, VecDeque},
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

fn find_all_presses(wiring_schematics: &Vec<Vec<usize>>, target: &Vec<usize>) -> usize {
    let mut result = None;
    let mut table = HashMap::new();
    let initial_state = vec![0; target.len()];
    table.insert(initial_state.clone(), 0);
    let mut queue = VecDeque::from([initial_state]);

    while let Some(state) = queue.pop_back() {
        let current_depth = table.get(&state).expect("Should not be missing").clone();
        if state == *target {
            result = Some(current_depth);
            break;
        }
        // println!("{state:?}: {current_depth}");
        for schematic in wiring_schematics {
            let mut new_sum = state.clone();
            let mut over_target = false;
            for wire in schematic {
                new_sum[*wire] += 1;
                if new_sum[*wire] > target[*wire] {
                    over_target = true;
                    break;
                }
            }
            if over_target {
                // println!("skipping {new_sum:?}");
                continue;
            }
            if let None = table.get(&new_sum) {
                println!("{new_sum:?}");
                queue.push_front(new_sum.clone());
                table.entry(new_sum.clone()).or_insert(current_depth + 1);
            }
        }
    }

    return result.expect(&format!("Could not find presses for {target:?}"));
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
                let schematic = schematic
                    .split(",")
                    .map(|num| num.parse::<usize>().unwrap())
                    .collect::<Vec<_>>();
                return schematic;
            })
            .collect::<Vec<_>>();

        println!("{:?} {:?}", wiring_schematics, joltage_requirements);

        let min_presses = find_all_presses(&wiring_schematics, &joltage_requirements);

        println!("{:?}", min_presses);
        total_button_presses += min_presses
    }

    println!("{total_button_presses}");
}
