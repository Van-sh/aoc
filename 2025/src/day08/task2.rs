mod structs;

use std::{
    cmp::Reverse,
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

use crate::structs::{DisjoinSets, Edge, Point};

const PATH: &str = "inputs/day08/input.txt";

fn task2() {
    let mut result = 0_u64;

    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    let mut points = Vec::new();
    for line in lines.map_while(Result::ok) {
        let coords = line
            .split(",")
            .map(|coord| coord.parse::<u64>().unwrap())
            .collect::<Vec<_>>();

        let point = Point {
            x: coords[0],
            y: coords[1],
            z: coords[2],
        };
        points.push(point);
    }

    let mut distances = Vec::new();
    for i in 0..(points.len() - 1) {
        for j in (i + 1)..points.len() {
            let dist = points[i].dist(&points[j]);
            distances.push(Reverse(Edge {
                points: (i, j),
                dist,
            }));
        }
    }

    distances.sort_by(|a, b| b.cmp(a));

    let mut disjoint_sets = DisjoinSets::new(points.len());
    let mut merges = 0;
    for edge in distances {
        let edge = edge.0;
        if disjoint_sets.unite(edge.points.0, edge.points.1) {
            merges += 1;
            result = points[edge.points.0].x * points[edge.points.1].x;
        }
        if merges == points.len() - 1 {
            break;
        }
    }

    println!("{result}")
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
