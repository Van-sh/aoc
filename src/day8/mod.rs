mod structs;

use std::{
    cmp::Reverse,
    collections::{BinaryHeap, HashMap},
    fs::File,
    io::{self, BufRead},
};

use crate::day8::structs::{DisjoinSets, Edge, Point};

const PATH: &str = "inputs/day8/input.txt";
const CONNECTIONS: u64 = 1000;

#[allow(dead_code)]
pub fn task1() {
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

    let mut distances = BinaryHeap::new();
    for i in 0..(points.len() - 1) {
        for j in (i + 1)..points.len() {
            let dist = points[i].dist(&points[j]);
            distances.push(Reverse(Edge {
                points: (i, j),
                dist: dist,
            }));
        }
    }

    let mut disjoint_sets = DisjoinSets::new(points.len());
    for _ in 0..CONNECTIONS {
        let distance = distances.pop().unwrap().0;
        println!(
            "{:?} {:?} {:?}",
            distance, points[distance.points.0], points[distance.points.1]
        );
        disjoint_sets.unite(distance.points.0, distance.points.1);
    }

    let mut frequencies = HashMap::new();
    for i in 0..points.len() {
        let parent = disjoint_sets.find_parent(i);
        *frequencies.entry(parent).or_insert(0) += 1;
        println!("{} {}", i, frequencies[&parent]);
    }

    println!("{:?}", disjoint_sets);
    println!("{:#?}", frequencies);

    let mut frequencies = frequencies.into_values().collect::<Vec<_>>();
    frequencies.sort_by(|a, b| b.cmp(a));

    let result = frequencies[0] * frequencies[1] * frequencies[2];
    println!("{result}")
}

#[allow(dead_code)]
pub fn task2() {
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
                dist: dist,
            }));
        }
    }

    distances.sort_by(|a, b| b.cmp(a));

    let mut disjoint_sets = DisjoinSets::new(points.len());
    let mut result = 0u64;
    let mut merges = 0;
    for edge in distances {
        let edge = edge.0;
        println!(
            "{:?} {:?} {:?}",
            edge, points[edge.points.0], points[edge.points.1]
        );
        if disjoint_sets.unite(edge.points.0, edge.points.1) {
            merges += 1;
            println!("Merging");
            result = points[edge.points.0].x * points[edge.points.1].x;
        }
        if merges == points.len() - 1 {
            break;
        }
    }

    println!("{:?}", disjoint_sets);

    println!("{result}")
}
