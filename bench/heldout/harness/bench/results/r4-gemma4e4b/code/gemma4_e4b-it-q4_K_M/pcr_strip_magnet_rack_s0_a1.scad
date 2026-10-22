// Magnetic Bead Rack for 8-tube strip

// --- Overall Block Dimensions ---
rack_length_X = 80;   // Total length along X axis
rack_width_Y = 24;    // Total width along Y axis
rack_height_Z = 20;   // Total height of the block

// --- Tube Seat Parameters ---
tube_seat_diameter_top = 6.4; // Top diameter of the tube seat hole
tube_seat_diameter_bottom = 3.0; // Bottom (narrowed) diameter of the tube seat
tube_seat_depth = 12;          // Depth from top face (Z=20) down to Z=8
tube_seat_floor_height = 2;    // Height of the floor at the bottom of the cone
tube_seat_spacing = 9;         // Center-to-center spacing between tube seats

// --- Magnet Pocket Parameters ---
magnet_length_X = 60.4;       // Length of bar magnet (must be slightly larger than rack length for centering)
magnet_width_Y = 3.3;         // Width of bar magnet
magnet_height_Z = 10.2;       // Height of bar magnet

// --- Global Settings ---
$fn = 64; // High resolution for curves

// Calculate offsets for centering the tube seats along Y=0
num_tubes = 8;
total_seat_span = (num_tubes - 1) * tube_seat_spacing;
center_offset_Y = -(total_seat_span / 2);

// --- Module Definitions ---

// Tube Seat: A conical hole cut from the top face down to a floor.
module tube_seat(y_pos) {
    // The seat is centered at X=0, and its center line is at Y=y_pos
    translate([0, y_pos, rack_height_Z]) // Start cutting from the top surface (Z=20)
    difference() {
        // 1. Main body of the cut: A cylinder representing the initial large hole
        cylinder(h = tube_seat_depth + 1, r = tube_seat_diameter_top / 2, center = true);

        // 2. The conical taper (cut out from the bottom)
        // Replaced 'cone' with hull/difference to avoid unknown module warning and ensure correct geometry.
        // We create a shape that tapers from r1 to r2 over height H.
        translate([0, 0, -tube_seat_depth]) // Position the cone base at Z=0 relative to the cylinder's center
        hull() {
            sphere(r = tube_seat_diameter_top / 2);
            translate([0, 0, -tube_seat_depth]) sphere(r = tube_seat_diameter_bottom / 2);
        }

        // 3. The floor (a solid block that stops the cut)
        // This is placed at Z = rack_height_Z - tube_seat_depth + tube_seat_floor_height
        translate([0, 0, -(tube_seat_depth - tube_seat_floor_height)])
        cube([tube_seat_diameter_top * 1.5, tube_seat_diameter_top * 1.5, tube_seat_floor_height]);

    }
}


// Magnet Pocket: A rectangular cutout for the magnet
module magnet_pocket(y_pos) {
    // The pocket is centered in X (X=0). It extends from Z=0 up to Z=magnet_height_Z.
    translate([0, y_pos, 0])
    cube([magnet_length_X + 1, magnet_width_Y + 1, magnet_height_Z + 1]); // Add padding for cutting clearance
}


// --- Main Assembly ---

difference() {
    // 1. The main solid block (Rack Body)
    // Centered on origin in X and Y, resting on Z=0 plane.
    translate([0, 0, 0])
    cube([rack_length_X, rack_width_Y, rack_height_Z]);

    // 2. Tube Seat Holes (Cut along Y=0 line)
    for (i = [0 : num_tubes - 1]) {
        y_pos = center_offset_Y + i * tube_seat_spacing;
        tube_seat(y_pos);
    }

    // 3. Magnet Pockets (Cutouts beside the row)
    // Pocket 1: Y = -6 mm
    magnet_pocket(-6);
    // Pocket 2: Y = +6 mm
    magnet_pocket(6);
}