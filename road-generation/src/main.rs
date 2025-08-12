mod algorithm;
mod constraints;
mod global_goals;
mod types;

use algorithm::generate_road_network;
use types::*;

fn main() {
    let initial_query = RoadQuery {
        t: 0,
        ra: RoadAttributes {
            start_x: 0.0,
            start_y: 0.0,
            angle: 0.0, // pointing right
            length: 10.0,
            road_type: RoadType::Highway,
        },
        qa: QueryAttributes {
            start_x: 0.0,
            start_y: 0.0,
            angle: 0.0,
            length: 10.0,
            road_type: RoadType::Highway,
        },
    };

    println!("Generating road network...");
    let segments = generate_road_network(initial_query);

    println!("Generated {} road segments:", segments.len());
    for (i, segment) in segments.iter().enumerate() {
        println!(
            "Segment {}: start=({:.1}, {:.1}), angle={:.2}, length={:.1}, type={:?}",
            i + 1,
            segment.ra.start_x,
            segment.ra.start_y,
            segment.ra.angle,
            segment.ra.length,
            segment.ra.road_type
        );
    }
}
