use std::{fs::File, io::Read, time::Instant};

const PATH: &str = "inputs/day02/input.txt";

fn task2() {
    let mut invalid_id_sum = 0;
    let mut text = String::new();
    let _ = File::open(PATH).unwrap().read_to_string(&mut text).unwrap();

    let ranges = text.trim().split(",").map(|range: &str| -> Vec<_> {
        range
            .split("-")
            .map(|s| -> i64 { s.parse().unwrap() })
            .collect()
    });

    for range in ranges {
        for id in range[0]..=range[1] {
            let mut width = 0;
            while 10i64.pow(width) <= id {
                width += 1;
            }

            for attempt_width in 1..=(width / 2) {
                let cutoff = 10i64.pow(attempt_width);

                let pattern = id % cutoff;
                let mut tmp = id / cutoff;
                let mut is_valid = false;

                while tmp > 0 {
                    if tmp < cutoff / 10 || tmp % cutoff != pattern {
                        is_valid = true;
                        break;
                    }
                    tmp /= cutoff;
                }

                if !is_valid {
                    invalid_id_sum += id;
                    break;
                }
                if attempt_width == width / 2 {}
            }
        }
    }
    println!("{invalid_id_sum}")
}

fn main() {
    let timer = Instant::now();
    task2();
    println!("Done in {:?}", timer.elapsed());
}
