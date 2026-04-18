use std::{collections::HashSet, fs::File, io::Read};

const PATH: &str = "inputs/day12/example.txt";

pub fn task1() {
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
        .map(|present| Present::new(present))
        .collect::<Vec<_>>();

    println!("presents: {:?}", presents);

    let trees = trees_input.lines();
    // println!("{:?}", trees.collect::<Vec<_>>());
    let _ = trees
        .map(|tree| {
            let tree = tree.split(":").collect::<Vec<_>>();
            let dimensions = tree[0]
                .split("x")
                .map(|d| d.parse::<usize>().unwrap())
                .collect::<Vec<_>>();
            let required_presents = tree[1]
                .trim()
                .split_whitespace()
                .map(|req| req.parse::<u32>().unwrap())
                .collect::<Vec<_>>();
            println!("{dimensions:?}: {required_presents:?}");
            let tree_region = vec![vec![false; dimensions[0]]; dimensions[1]];
            println!("{tree_region:?}");
        })
        .collect::<Vec<_>>();
}

#[derive(Debug)]
struct Present {
    /*
    HashSet {
        ###
        ##.
        ##.
        becomes
        vec![
            vec![true, true, true]
            vec![true, true, false]
            vec![true, true, false]
        ]
        + all orientations
    }
    */
    orientations: HashSet<Vec<Vec<bool>>>,
}

impl Present {
    pub fn new(present_string: &str) -> Self {
        let mut present = present_string.split("\n");
        // skip the index.
        present.next();
        let shape = present
            .map(|row| row.chars().map(|ch| ch == '#').collect::<Vec<_>>())
            .collect::<Vec<_>>();
        println!("{:?}", shape);

        let orientations = Self::get_orientations(shape);
        return Present { orientations };
    }

    fn get_orientations(shape: Vec<Vec<bool>>) -> HashSet<Vec<Vec<bool>>> {
        let mut orientations = HashSet::new();
        let mut reverse_shape = shape.clone();
        reverse_shape.reverse();

        orientations.extend(Self::get_rotations(shape));
        orientations.extend(Self::get_rotations(reverse_shape));

        return orientations;
    }

    fn get_rotations(mut shape: Vec<Vec<bool>>) -> Vec<Vec<Vec<bool>>> {
        let mut rotations = Vec::from([shape.clone()]);
        for _ in 0..3 {
            let mut rotated_shape = vec![vec![false; shape[0].len()]; shape.len()];

            for i in 0..shape.len() {
                for j in 0..shape[i].len() {
                    rotated_shape[j][i] = shape[i][j];
                }
            }
            rotated_shape.reverse();

            rotations.push(rotated_shape.clone());
            shape = rotated_shape;
        }

        return rotations;
    }
}
