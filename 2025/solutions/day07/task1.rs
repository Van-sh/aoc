use std::{
    collections::HashSet,
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day07/input.txt";

 fn task1() {
    let mut encountered_splitters = 0;
    let mut indexes = HashSet::new();

    let file = File::open(PATH).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    let origin_line = lines.next().unwrap().unwrap();
    let idx = origin_line.find("S").unwrap();
    indexes.insert(idx);

    for line in lines.map_while(Result::ok) {
        for idx in indexes.clone() {
            if &line[idx..(idx + 1)] == "^" {
                encountered_splitters += 1;
                println!("Splitter found at {}", idx);
                if idx < line.len() - 1 {
                    indexes.insert(idx + 1);
                }
                if idx > 0 {
                    indexes.insert(idx - 1);
                }
                indexes.remove(&idx);
            }
        }
    }

    let mut indexes = indexes.iter().collect::<Vec<_>>();
    indexes.sort();
    println!("{:?}", indexes);
    println!("{encountered_splitters}")
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
