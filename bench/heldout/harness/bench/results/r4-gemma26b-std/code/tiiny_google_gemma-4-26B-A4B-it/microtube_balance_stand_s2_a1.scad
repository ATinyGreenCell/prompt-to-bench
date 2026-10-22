// --- Dimensions ---
base_diameter = 50;          // Diameter of the base disc
base_height = 4;            // Height of the base disc
cone_bottom_dia = 50;       // Diameter at the bottom of the cone (z=4)
cone_top_dia = 22;          // Diameter at the top of the cone (z=14)
cone_height = 10;           // Height of the cone section (14 - 4)
column_diameter = 22;       // Diameter of the upper column
column_height = 19;         // Height of the column (33 - 14)
total_height = 33;          // Total height of the stand

// Tube Seat Dimensions
seat_top_dia = 11;          // Diameter of the cylindrical seat
seat_top_z = 33;            // Z-coordinate at the top of the seat
seat_bottom_z = 23;         // Z-coordinate where seat becomes conical
seat_cone_bottom_dia = 3;   // Diameter at the tip of the internal cone
seat_cone_bottom_z = 6;     // Z-coordinate at the tip of the internal cone

// Viewing Window Dimensions
window_width_y = 4;         // Width of the window in Y direction
window_height_start = 18;   // Z-coordinate at bottom of window
window_height_end = 30;     // Z-coordinate at top of window
window_thickness_offset = 5; // Extra depth to ensure clean cut through walls

// --- Parameters ---
$fn = 64;

// --- Main Construction ---

difference() {
    // The Solid Body
    union() {
        // 1. Base Disc
        cylinder(d = base_diameter, h = base_height);

        // 2. Conical Section (z=4 to z=14)
        hull() {
            translate([0, 0, base_height])
                cylinder(d = cone_bottom_dia, h = 0.01);
            translate([0, 0, base_height + cone_height])
                cylinder(d = cone_top_dia, h = 0.01);
        }

        // 3. Upper Column (z=14 to z=33)
        translate([0, 0, base_height + cone_height])
            cylinder(d = column_diameter, h = column_height);
    }

    // --- Subtraction (Holes) ---

    // 1. The Tube Seat (Internal Cavity)
    // Note: The seat is a single continuous subtraction from top to bottom
    union() {
        // Cylindrical part of the seat (z=23 to z=33)
        translate([0, 0, seat_bottom_z])
            cylinder(d = seat_top_dia, h = seat_top_z - seat_bottom_z + 0.1);
        
        // Conical part of the seat (z=6 to z=23)
        hull() {
            translate([0, 0, seat_bottom_z])
                cylinder(d = seat_top_dia, h = 0.01);
            translate([0, 0, seat_cone_bottom_z])
                cylinder(d = seat_cone_bottom_dia, h = 0.01);
        }
        
        // Ensure the tip is fully cut through the bottom of the object
        translate([0, 0, 0])
            cylinder(d = seat_cone_bottom_dia, h = seat_cone_bottom_z + 0.1);
    }

    // 2. Viewing Window
    // Cut through the +X side.
    // The window is 4mm wide in Y, centered on Y=0.
    // It must cut from the seat (z=18) to the outside.
    // We use a large X translation to ensure it clears the entire radius.
    translate([column_diameter/2 - 1, -window_width_y/2, window_height_start])
        cube([window_thickness_offset + 2, window_width_y, window_height_end - window_height_start]);
}