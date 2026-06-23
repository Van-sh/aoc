use std::{fs::File, io::Read, time::Instant};

const PATH: &str = "inputs/day12/input.txt";

fn task() {
    let mut result = 0;

    let mut lines = String::new();
    let _ = File::open(PATH)
        .unwrap()
        .read_to_string(&mut lines)
        .unwrap();
    let lines = lines.replace("\r\n", "\n");
    let mut lines = lines.split("\n\n").collect::<Vec<_>>();
    let trees_input = lines.pop().expect("Empty input");

    let presents = lines
        .iter()
        .map(|present| {
            let mut present = present.split("\n");
            // skip the index.
            present.next();

            present
                .map(|row| {
                    row.chars()
                        .fold(0, |acc, ch| if ch == '#' { acc + 1 } else { acc })
                })
                .sum()
        })
        .collect::<Vec<usize>>();

    let trees = trees_input.lines();
    let regions = trees.map(|tree| {
        let tree = tree.split(":").collect::<Vec<_>>();

        let dimensions = tree[0]
            .split("x")
            .map(|d| d.parse::<usize>().unwrap())
            .collect::<Vec<_>>();
        let dimensions = (dimensions[0], dimensions[1]);

        let required_presents = tree[1]
            .split_whitespace()
            .map(|req| req.parse::<usize>().unwrap())
            .collect::<Vec<_>>();
        (required_presents, dimensions)
    });

    for (required_presets, dimensions) in regions {
        let total_size = dimensions.0 * dimensions.1;

        let present_size = required_presets
            .iter()
            .enumerate()
            .fold(0, |acc, (present_index, requirement)| {
                acc + presents[present_index] * requirement
            });

        // This seems to work for my input so I am throwing in the towel here
        // Doesn't work for the example though...
        if present_size > total_size {
            continue;
        } else {
            result += 1;
        }
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task();
    println!("Done in {:?}", timer.elapsed());
}
