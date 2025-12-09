use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day9/input.txt";

#[allow(dead_code)]
pub fn task1() {
    let mut max_area = 0;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    let mut coords = Vec::new();
    for line in lines.map_while(Result::ok) {
        let coord = line
            .split(",")
            .map(|coord| coord.parse::<u64>().unwrap())
            .collect::<Vec<_>>();

        let coord = (coord[0], coord[1]);
        coords.push(coord);
    }

    for i in 0..(coords.len() - 1) {
        for j in (i + 1)..coords.len() {
            let (x1, y1) = coords[i];
            let (x2, y2) = coords[j];
            if x1 == x2 || y1 == y2 {
                continue;
            }
            let area = (x1.abs_diff(x2) + 1) * (y1.abs_diff(y2) + 1);

            if area > max_area {
                max_area = area;
            }
            println!("Area for {:?} and {:?} is {}", coords[i], coords[j], area);
        }
    }

    println!("{max_area}");
}
