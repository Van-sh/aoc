use std::{
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day09/input.txt";

fn task2() {
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
        'check_collisions: for j in (i + 1)..coords.len() {
            let (x1, y1) = (coords[i].0.min(coords[j].0), coords[i].1.min(coords[j].1));
            let (x2, y2) = (coords[i].0.max(coords[j].0), coords[i].1.max(coords[j].1));

            if x1 == x2 || y1 == y2 {
                continue;
            }

            for edge in &horizontal_edges {
                let (edge_x1, edge_y) = coords[edge.0];
                let edge_x2 = coords[edge.1].0;

                if (y1 < edge_y && edge_y < y2)
                    && ((edge_x1 <= x1 && x1 < edge_x2) || (edge_x1 < x2 && x2 <= edge_x2))
                {
                    continue 'check_collisions;
                }
            }

            for edge in &vertical_edges {
                let (edge_x, edge_y1) = coords[edge.0];
                let edge_y2 = coords[edge.1].1;

                if (x1 < edge_x && edge_x < x2)
                    && ((edge_y1 <= y1 && y1 < edge_y2) || (edge_y1 < y2 && y2 <= edge_y2))
                {
                    break 'check_collisions;
                }
            }

            let area = (x2 - x1 + 1) * (y2 - y1 + 1);

            if area > max_area {
                max_area = area;
            }
        }
    }

    println!("{max_area}");
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
