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

#[allow(dead_code)]
pub fn task2() {
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

    let mut vertical_edges = Vec::new();
    let mut horizontal_edges = Vec::new();
    for i in 0..coords.len() {
        let j = (i + 1) % coords.len();
        if coords[i].0 == coords[j].0 {
            let edge = if coords[i].1 < coords[j].1 {
                (i, j)
            } else {
                (j, i)
            };
            vertical_edges.push(edge);
        } else if coords[i].1 == coords[j].1 {
            let edge = if coords[i].0 < coords[j].0 {
                (i, j)
            } else {
                (j, i)
            };
            horizontal_edges.push(edge);
        } else {
            panic!("Invalid input");
        }
    }

    for i in 0..(coords.len() - 1) {
        for j in (i + 1)..coords.len() {
            let (x1, y1) = (coords[i].0.min(coords[j].0), coords[i].1.min(coords[j].1));
            let (x2, y2) = (coords[i].0.max(coords[j].0), coords[i].1.max(coords[j].1));

            if x1 == x2 || y1 == y2 {
                continue;
            }

            let mut edge_is_inside = false;

            for k in 0..horizontal_edges.len() {
                let edge = horizontal_edges[k];
                let (edge_x1, edge_y) = coords[edge.0];
                let edge_x2 = coords[edge.1].0;

                if y1 < edge_y && edge_y < y2 {
                    if edge_x1 <= x1 && x1 < edge_x2 {
                        println!(
                            "Skipping cause edge ({}-{}, {}) is inside {:?}-{:?} on the left edge",
                            edge_x1,
                            edge_x2,
                            edge_y,
                            (x1, y1),
                            (x2, y2)
                        );
                        edge_is_inside = true;
                        break;
                    }
                    if edge_x1 < x2 && x2 <= edge_x2 {
                        println!(
                            "Skipping cause edge ({}-{}, {}) is inside {:?}-{:?} on the right edge",
                            edge_x1,
                            edge_x2,
                            edge_y,
                            (x1, y1),
                            (x2, y2)
                        );
                        edge_is_inside = true;
                        break;
                    }
                }
            }

            if edge_is_inside {
                continue;
            }

            for k in 0..vertical_edges.len() {
                let edge = vertical_edges[k];
                let (edge_x, edge_y1) = coords[edge.0];
                let edge_y2 = coords[edge.1].1;

                if x1 < edge_x && edge_x < x2 {
                    if edge_y1 <= y1 && y1 < edge_y2 {
                        println!(
                            "Skipping cause edge ({}, {}-{}) is inside {:?}-{:?} on the top edge",
                            edge_x,
                            edge_y1,
                            edge_y2,
                            (x1, y1),
                            (x2, y2)
                        );
                        edge_is_inside = true;
                        break;
                    }
                    if edge_y1 < y2 && y2 <= edge_y2 {
                        println!(
                            "Skipping cause edge ({}, {}-{}) is inside {:?}-{:?} on the bottom edge",
                            edge_x,
                            edge_y1,
                            edge_y2,
                            (x1, y1),
                            (x2, y2)
                        );
                        edge_is_inside = true;
                        break;
                    }
                }
            }

            if edge_is_inside {
                break;
            }

            let area = (x2 - x1 + 1) * (y2 - y1 + 1);

            if area > max_area {
                max_area = area;
            }
            println!("Area for {:?} and {:?} is {}", coords[i], coords[j], area);
        }
    }

    println!("{max_area}");
}
