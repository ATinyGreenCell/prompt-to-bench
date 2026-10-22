// --- Dimensions ---
// Rod inner diameter
rod_id = 12.7;
// Rod wall thickness
rod_wall = 3;
// Rod outer diameter
rod_od = rod_id + 2 * rod_wall; // 18.7

// Rod ring opening: width in Y, located at -X side
rod_opening_y = 10;
rod_opening_half_y = rod_opening_y / 2; // 5

// Tubing inner diameter
tube_id = 6;
// Tubing wall thickness
tube_wall = 2;
// Tubing outer diameter
tube_od = tube_id + 2 * tube_wall; // 10

// Tubing ring opening: width in Y, located at +X side
tube_opening_y = 4.5;
tube_opening_half_y = tube_opening_y / 2; // 2.25

// Bridge width in Y
bridge_y = 6;
bridge_half_y = bridge_y / 2; // 3

// Bridge X extent
bridge_x_start = 8;
bridge_x_end = 12;

// Extrusion height (Z)
height = 10;

// --- Parameters ---
$fn = 64;

// --- Build the profile in XY plane, then extrude ---
module profile() {
    // Rod ring (centered at origin)
    difference() {
        // Outer cylinder (rod OD)
        cylinder(h = 0.01, r = rod_od / 2, center = false);
        // Inner cylinder (rod ID) - slightly larger to ensure clean cut
        cylinder(h = 0.01, r = rod_id / 2 + 0.01, center = false);
        // Opening on -X side: remove everything with x < 0 and |y| < 5
        translate([-0.01, 0, 0])
            cube([0.01, rod_opening_y + 0.02, 0.01], center = true);
    }
    
    // Tubing ring (centered at x=15, y=0)
    difference() {
        translate([15, 0, 0]) {
            // Outer cylinder (tube OD)
            cylinder(h = 0.01, r = tube_od / 2, center = false);
            // Inner cylinder (tube ID) - slightly larger to ensure clean cut
            cylinder(h = 0.01, r = tube_id / 2 + 0.01, center = false);
            // Opening on +X side: remove everything with x > 15 and |y| < 2.25
            translate([0.01, 0, 0])
                cube([0.01, tube_opening_y + 0.02, 0.01], center = true);
        }
    }
    
    // Bridge: solid rectangle between x=8 and x=12, width 6 in Y
    translate([(bridge_x_start + bridge_x_end) / 2, 0, 0])
        cube([bridge_x_end - bridge_x_start, bridge_y, 0.01], center = true);
}

// --- Extrude the profile ---
linear_extrude(height = height)
    profile();