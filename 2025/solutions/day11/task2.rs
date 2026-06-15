use std::{
    collections::HashMap,
    fs::File,
    io::{self, BufRead},
    sync::Arc,
    thread,
    time::Instant,
};

const PATH: &str = "inputs/day11/example.txt";

fn task2() {
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
    let adj = Arc::new(adj);
    let res = solve_task2(adj);

    println!("{:#?}", res);
}

fn solve_task2(adjacency_list: Arc<HashMap<String, Vec<String>>>) -> u64 {
    let tasks_fft_dac = [("svr", "fft"), ("fft", "dac"), ("dac", "out")];
    let tasks_dac_fft = [("svr", "dac"), ("dac", "fft"), ("fft", "out")];
    let tasks = [tasks_fft_dac, tasks_dac_fft];
    tasks
        .map(|task| {
            let handlers = task.map(|task| {
                let adj = adjacency_list.clone();
                let mut paths_to_dest = HashMap::from([(task.1.to_string(), 1)]);

                thread::Builder::new()
                    .name(format!("{:?}", task))
                    .spawn(move || dfs_task2_recursive(adj, &mut paths_to_dest, task.0))
                    .unwrap()
            });

            handlers
                .into_iter()
                .fold(1, |acc, handle| acc * handle.join().unwrap())
        })
        .into_iter()
        .sum()
}

fn dfs_task2_recursive(
    adjacency_list: Arc<HashMap<String, Vec<String>>>,
    paths_to_dest: &mut HashMap<String, u64>,
    node: &str,
) -> u64 {
    if let Some(paths) = paths_to_dest.get(node) {
        return *paths;
    }

    let mut paths = 0;
    for next_node in adjacency_list[node].iter() {
        let paths_from_node = dfs_task2_recursive(adjacency_list.clone(), paths_to_dest, next_node);
        paths_to_dest.insert(next_node.clone(), paths_from_node);
        paths += paths_from_node
    }
    paths
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
