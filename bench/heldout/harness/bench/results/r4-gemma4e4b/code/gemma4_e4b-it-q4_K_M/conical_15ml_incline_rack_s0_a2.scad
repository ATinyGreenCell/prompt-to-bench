// --- Dimensions ---
rack_length = 130;    // Total length along X (mm)
rack_depth = 60;      // Total depth along Y (mm)
rack_height = 45;     // Total height along Z (mm)

tube_hole_diameter = 17.5; // Diameter of the tube hole (mm)
tube_hole_radius = tube_hole_diameter / 2;
tube_hole_depth = 40;    // Depth of the cylindrical cut (mm)

num_tubes = 5;         // Number of tubes to hold
spacing_x = 24;        // Distance between centers of holes along X (mm)

tilt_angle = 30;       // Tilt angle in degrees from vertical (YZ plane)

// --- Constants ---
$fn = 64; // High resolution for curves

// --- Base Block Definition ---
module base_block() {
    cube([rack_length, rack_depth, rack_height], center = true);
}

// --- Hole Geometry Calculation ---
// Total span for 5 tubes: (5-1) * spacing_x = 4 * 24 = 96 mm.
// Centered on origin, so start offset is -96/2 = -48 mm from center.
module tube_hole(center_x) {
    // The hole axis starts at Z = rack_height/2 (top face center) and goes down.
    // It is tilted 30 degrees in the YZ plane, moving towards +Y.

    // We use a cylinder centered at its local origin, then translate/rotate it so that its top face aligns with Z=rack_height/2.

    // The distance along the tilted axis from the entry point to the center is tube_hole_depth / 2.
    // When rotated by -tilt_angle around X:
    // Offset vector calculation derived from geometry for correct placement:
    // Entry point P_entry = [center_x, 0, rack_height/2]
    // Center of cylinder required in world coordinates:
    // C_world = P_entry + (tube_hole_depth/2) * [0, sin(tilt_angle), -cos(tilt_angle)]

    translate([center_x, 0, rack_height/2]) {
        rotate([0, -tilt_angle, 0]) {
            // Translate the cylinder so its center is correctly positioned relative to the entry point on Z=rack_height/2.
            // The translation vector moves the local origin (which is at the top face when unrotated) down along the tilted axis by tube_hole_depth / 2.
            translate([0, (tube_hole_depth/2) * sin(tilt_angle), -(tube_hole_depth/2) * cos(tilt_angle)]) {
                cylinder(h = tube_hole_depth, r = tube_hole_radius);
            }
        }
    }
}

// --- Final Assembly ---
difference() {
    // 1. The solid block
    base_block();

    // 2. Subtract the five holes
    union() {
        for (i = [0 : num_tubes - 1]) {
            x_pos = (-((num_tubes - 1) * spacing_x) / 2) + (i * spacing_x);
            tube_hole(center_x = x_pos);
        }
    }
}