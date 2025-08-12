use crate::constraints::local_constraints;
use crate::global_goals::add_zero_to_three_roads_using_global_goals;
use crate::types::*;
use std::cmp::Reverse;

pub fn generate_road_network(initial_query: RoadQuery) -> Vec<Segment> {
    let mut q = PriorityQueue::new();
    q.push(Reverse(initial_query));

    let mut s = Vec::new();
    let mut iterations = 0;
    const MAX_ITERATIONS: usize = 10; // Prevent infinite loop in simple implementation

    while let Some(Reverse(query)) = q.pop() {
        if iterations >= MAX_ITERATIONS {
            break;
        }

        let (nqa, state) = local_constraints(&query.qa);

        if state == ConstraintState::Succeed {
            s.push(Segment {
                ra: query.ra.clone(),
            });

            add_zero_to_three_roads_using_global_goals(&mut q, query.t + 1, &nqa, &query.ra);
        }

        iterations += 1;
    }

    s
}
