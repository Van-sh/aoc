#[derive(Debug, Eq, PartialEq, Clone)]
pub struct Edge {
    pub state: Vec<usize>,
    pub presses: usize,
}

impl PartialOrd for Edge {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Edge {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.presses.cmp(&other.presses)
    }
}
