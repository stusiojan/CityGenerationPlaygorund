use std::cmp::Reverse;
use std::collections::BinaryHeap;

#[derive(Debug, Clone)]
pub struct RoadAttributes {
    pub start_x: f64,
    pub start_y: f64,
    pub angle: f64,
    pub length: f64,
    pub road_type: RoadType,
}

#[derive(Debug, Clone)]
pub enum RoadType {
    Highway,
    Residential,
}

#[derive(Debug, Clone)]
pub struct QueryAttributes {
    pub start_x: f64,
    pub start_y: f64,
    pub angle: f64,
    pub length: f64,
    pub road_type: RoadType,
}

#[derive(Debug, Clone)]
pub struct RoadQuery {
    pub t: u32,
    pub ra: RoadAttributes,
    pub qa: QueryAttributes,
}

impl PartialEq for RoadQuery {
    fn eq(&self, other: &Self) -> bool {
        self.t == other.t
    }
}

impl Eq for RoadQuery {}

impl PartialOrd for RoadQuery {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for RoadQuery {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.t.cmp(&other.t)
    }
}

#[derive(Debug, Clone)]
pub struct Segment {
    pub ra: RoadAttributes,
}

#[derive(Debug, PartialEq)]
pub enum ConstraintState {
    Succeed,
    Failed,
}

pub type PriorityQueue = BinaryHeap<Reverse<RoadQuery>>;
