use std::{
    fs::File,
    io::{self, BufRead},
};

const PATH: &str = "inputs/day09/input.txt";

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

#[allow(dead_code)]
pub fn task2() {
    let mut max_area = 0;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    let mut coords = Vec::new();
    let mut min_y = u64::MAX;
    let mut min_x = u64::MAX;
    let mut max_y = 0;
    let mut max_x = 0;
    for line in lines.map_while(Result::ok) {
        let coord = line
            .split(",")
            .map(|coord| coord.parse::<u64>().unwrap())
            .collect::<Vec<_>>();

        let coord = (coord[0], coord[1]);
        coords.push(coord);

        min_y = min_y.min(coord.1);
        min_x = min_x.min(coord.0);
        max_y = max_y.max(coord.1);
        max_x = max_x.max(coord.0);
    }

    let mut vertical_edges = Vec::new();
    let mut horizontal_edges = Vec::new();
    for i in 0..coords.len() {
        let j = (i + 1) % coords.len();
        if coords[i].0 == coords[j].0 {
            vertical_edges.push((i, j));
        } else if coords[i].1 == coords[j].1 {
            horizontal_edges.push((i, j));
        } else {
            panic!("Invalid input");
        }
    }

    println!("{}, {}, {}, {}", min_x, min_y, max_x, max_y);

    let scale = 1000;

    for Y in (min_y / scale - 1)..(max_y / scale + 2) {
        for X in (min_x / scale - 1)..(max_x / scale + 2) {
            let mut symbol = " ";
            for coord in coords.clone() {
                let coord = (coord.0 / scale, coord.1 / scale);
                if (X, Y) == coord {
                    symbol = "+";
                }
            }
            for edge in horizontal_edges.clone() {
                let (x1, y) = coords[edge.0];
                let (x1, y) = (x1 / scale, y / scale);
                let x2 = coords[edge.1].0 / scale;

                let lower_x = x1.min(x2);
                let upper_x = x1.max(x2);

                if Y == y && lower_x < X && X < upper_x {
                    symbol = "-"
                }
            }
            for edge in vertical_edges.clone() {
                let (x, y1) = coords[edge.0];
                let (x, y1) = (x / scale, y1 / scale);
                let y2 = coords[edge.1].1 / scale;

                let lower_y = y1.min(y2);
                let upper_y = y1.max(y2);

                if X == x && lower_y < Y && Y < upper_y {
                    symbol = "|"
                }
            }
            print!("{symbol}");
        }
        println!();
    }

    println!("horizontal_edges");
    for (i, j) in horizontal_edges {
        println!("{:?} {:?}", coords[i], coords[j]);
    }
    println!("vertical_edges");
    for (i, j) in vertical_edges {
        println!("{:?} {:?}", coords[i], coords[j]);
    }

    println!("{max_area}");
}
