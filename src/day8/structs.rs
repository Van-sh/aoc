#[derive(Debug, Eq, PartialEq)]
pub struct Point {
    pub x: u64,
    pub y: u64,
    pub z: u64,
}

impl Point {
    pub fn dist(&self, other: &Self) -> u64 {
        ((self.x.abs_diff(other.x)).pow(2)
            + (self.y.abs_diff(other.y)).pow(2)
            + (self.z.abs_diff(other.z)).pow(2))
        .isqrt()
    }
}

#[derive(Debug, Eq, PartialEq, Clone, Copy)]
pub struct Edge {
    pub points: (usize, usize),
    pub dist: u64,
}

impl PartialOrd for Edge {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Edge {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.dist.cmp(&other.dist)
    }
}

#[derive(Debug)]
pub struct DisjoinSets {
    parent: Vec<usize>,
    rank: Vec<usize>,
}

impl DisjoinSets {
    pub fn new(n: usize) -> Self {
        let mut instance = Self {
            parent: Vec::new(),
            rank: vec![1; n],
        };
        for i in 0..n {
            instance.parent.push(i);
        }
        return instance;
    }

    pub fn find_parent(&mut self, i: usize) -> usize {
        return if self.parent[i] == i {
            i
        } else {
            self.parent[i] = self.find_parent(self.parent[i]);
            self.parent[i]
        };
    }
    pub fn unite(&mut self, x: usize, y: usize) -> bool {
        let x_parent = self.find_parent(x);
        let y_parent = self.find_parent(y);

        if x_parent != y_parent {
            if self.rank[x_parent] > self.rank[y_parent] {
                self.parent[y_parent] = x_parent;
            } else if self.rank[x_parent] < self.rank[y_parent] {
                self.parent[x_parent] = y_parent;
            } else {
                self.parent[y_parent] = x_parent;
                self.rank[x_parent] += 1;
            }
            return true;
        }
        return false;
    }
}
