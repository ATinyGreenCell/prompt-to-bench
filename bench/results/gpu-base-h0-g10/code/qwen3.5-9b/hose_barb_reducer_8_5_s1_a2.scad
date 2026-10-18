// Hose-barb Reducer: 8mm ID to 5mm ID
// Orientation: Standing upright along Z, centered at origin.
// Base Z = 0.

// --- Dimensions ---
// Main bore diameter (constant through part)
$main_bore_d = 3.0;

// Section 1: 8mm Tubing Barbs (Z = 0 to 20)
$z_start_1 = 0;
$z_end_1 = 20;
$barb_height_1 = 10;
$barb_count_1 = 2;
$barb_od_bottom_1 = 7.5;
$barb_od_top_1 = 9.5;
$collar_od_1 = 7.5; // Diameter after the sawtooth step

// Section 2: Collar (Z = 20 to 25)
$z_start_2 = 20;
$z_end_2 = 25;
$collar_od_2 = 12.0;

// Section 3: 5mm Tubing Barbs (Z = 25 to 41)
$z_start_3 = 25;
$z_end_3 = 41;
$barb_height_3 = 8;
$barb_count_3 = 2;
$barb_od_bottom_3 = 6.5;
$barb_od_top_3 = 5.0;
$collar_od_3 = 6.5; // Diameter after the sawtooth step

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate holes

// Helper to create the main body profile
// We define the radius at specific Z heights to create the "sawtooth" and steps.
// The profile is rotationally symmetric.
// We use a polygon defined by (x, y) coordinates where x is Z and y is Radius.
// Then we rotate_extrude.

module main_body() {
    // Define the profile points (Z, Radius)
    // Z=0: R = 7.5/2 = 3.75
    // Z=10: R = 9.5/2 = 4.75 (Top of Barb 1)
    // Z=10+: R = 7.5/2 = 3.75 (Step down for Barb 2 base)
    // Z=20: R = 9.5/2 = 4.75 (Top of Barb 2)
    // Z=20+: R = 12.0/2 = 6.0 (Step up to Collar)
    // Z=25: R = 6.0 (Bottom of Collar)
    // Z=25: R = 6.5/2 = 3.25 (Step down to Barb 3 base)
    // Z=33: R = 5.0/2 = 2.5 (Top of Barb 3)
    // Z=33+: R = 6.5/2 = 3.25 (Step down for Barb 4 base)
    // Z=41: R = 6.5/2 = 3.25 (Top of Barb 4)

    // We will create a polygon with vertices (z, r).
    // Note: rotate_extrude expects (x, y) where x is the axis of extrusion (Z here) and y is the radius.
    
    points = [
        [0, 3.75],
        [10, 4.75],
        [10, 3.75], // Step down
        [20, 4.75],
        [20, 6.0],  // Step up to collar
        [25, 6.0],
        [25, 3.25], // Step down
        [33, 2.5],
        [33, 3.25], // Step down
        [41, 3.25]
    ];

    // Create the polygon
    poly = polygon(points);

    // Extrude and rotate
    rotate_extrude() {
        linear_extrude(height = 41, center = true) {
            poly;
        }
    }
}

// Module to create the through-hole
// We need to cut a cylinder of diameter $main_bore_d through the entire part.
// To ensure it cuts cleanly without coplanar faces, we extend it slightly past the ends.
module through_hole() {
    $h = 41 + 1; // Extend 1mm past top and bottom
    $d = $main_bore_d;
    $r = $d / 2;
    
    // Cut from Z = -0.5 to Z = 41.5
    translate([0, 0, -0.5]) {
        cylinder(h = $h, d = $d, $fn = $fn);
    }
}

// Module to create the barb holes
// We need to cut holes for the tubing.
// The prompt implies the barbs are for 8mm and 5mm tubing.
// Usually, the hole diameter is slightly larger than the tubing ID to allow insertion.
// We will assume a standard fit: Hole ID = Tubing ID + 0.2mm.
// 8mm tubing -> Hole ID = 8.2mm
// 5mm tubing -> Hole ID = 5.2mm

module barb_holes(z_start, z_end, id_tubing, count, offset_z) {
    $d_hole = id_tubing + 0.2;
    $r_hole = $d_hole / 2;
    $h = z_end - z_start;
    
    // We need to cut holes at specific Z positions within the barb range.
    // The barbs are "stacked".
    // If count=2 and height=10, and they are stacked, they occupy 0-10 and 10-20.
    // We need to determine the Z positions of the centers of the holes.
    // Assuming the hole is centered vertically within the barb segment.
    
    // Calculate segment height
    $seg_h = $h / count;
    
    // Calculate Z positions for hole centers
    // Segment 1: z_start to z_start + seg_h. Center = z_start + seg_h/2
    // Segment 2: z_start + seg_h to z_start + 2*seg_h. Center = z_start + 1.5*seg_h
    // ...
    
    for (i = [0 : count-1]) {
        $z_center = z_start + (i + 0.5) * $seg_h;
        translate([0, 0, $z_center]) {
            cylinder(h = $seg_h, d = $d_hole, $fn = $fn);
        }
    }
}

// Main assembly
difference() {
    union() {
        main_body();
    }
    
    // Cut the main through hole
    through_hole();
    
    // Cut holes for Section 1 (8mm tubing)
    // Z = 0 to 20. Two barbs stacked.
    barb_holes(0, 20, 8, 2, 0);
    
    // Cut holes for Section 3 (5mm tubing)
    // Z = 25 to 41. Two barbs stacked.
    barb_holes(25, 41, 5, 2, 0);
}