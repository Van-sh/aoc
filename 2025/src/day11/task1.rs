use std::{
    collections::HashMap,
    fs::File,
    io::{self, BufRead},
    time::Instant,
};

const PATH: &str = "inputs/day11/input.txt";

fn task1() {
    let file = File::open(PATH).unwrap();
    let lines = io::BufReader::new(file).lines();

    let mut adj = HashMap::from([("out".to_string(), vec![])]);
    for line in lines.map_while(Result::ok) {
        let mut line = line.split(":");
        let node = line.next().unwrap().to_string();
        let paths = line
            .next()
            .unwrap()
            .trim()
            .split(" ")
            .map(|path| path.to_string())
            .collect::<Vec<_>>();

        adj.insert(node, paths);
    }
    let res = dfs_task1(&adj);

    println!("{:#?}", res);
}

fn dfs_task1(adjacency_list: &HashMap<String, Vec<String>>) -> u32 {
    let starting_node = "you";
    let mut visited = HashMap::new();
    for node in adjacency_list.keys() {
        visited.insert(node.clone(), false);
    }

    let mut res = 0;
    dfs_task1_recursive(
        adjacency_list,
        &mut visited,
        starting_node,
        &mut res,
        &mut vec![],
    );

    res
}

fn dfs_task1_recursive(
    adj: &HashMap<String, Vec<String>>,
    visited: &mut HashMap<String, bool>,
    node: &str,
    res: &mut u32,
    debug: &mut Vec<String>,
) {
    debug.push(node.to_string());
    visited.insert(node.to_string(), true);

    for next_node in adj[node].iter() {
        if visited[next_node] {
            continue;
        }
        if next_node == "out" {
            *res += 1;
            debug.push("out".to_string());
            println!("{:?}", debug);
            debug.pop();
            continue;
        }

        dfs_task1_recursive(adj, visited, next_node, res, debug);
    }
    visited.insert(node.to_string(), false);
}

fn main() {
    let timer = Instant::now();
    task1();
    println!("Done in {:?}", timer.elapsed());
}
