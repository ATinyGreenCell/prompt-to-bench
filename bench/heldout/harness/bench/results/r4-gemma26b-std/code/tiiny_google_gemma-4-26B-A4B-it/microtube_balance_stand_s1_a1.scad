// --- Dimensions ---
base_diameter = 50.0;      // Diameter of the base disc
base_height = 4.0;         // Height of the base disc
cone_bottom_dia = 50.0;    // Diameter at the bottom of the cone (z=4)
cone_top_dia = 22.0;       // Diameter at the top of the cone (z=14)
cone_height = 10.0;        // Height of the cone section (14 - 4)
column_diameter = 22.0;     // Diameter of the top column
column_height = 19.0;       // Height of the column (33 - 14)
total_height = 33.0;       // Total height of the object

tube_seat_dia = 11.0;      // Diameter of the cylindrical part of the seat
seat_cyl_depth = 10.0;     // Depth of the cylindrical seat (33 - 23)
seat_cone_top_dia = 11.0;  // Diameter at the top of the seat cone (z=23)
seat_cone_bottom_dia = 3.0; // Diameter at the bottom of the seat cone (z=6)
seat_cone_height = 17.0;   // Height of the seat cone (23 - 6)

window_width = 4.0;        // Width of the viewing window in Y direction
window_height = 12.0;      // Height of the window (30 - 18)
window_z_start = 18.0;     // Bottom Z of the window
window_z_end = 30.0;       // Top Z of the window

// --- Constants ---
$fn = 64;

// --- Main Construction ---

module stand_geometry() {
    union() {
        // 1. Base Disc
        cylinder(d = base_diameter, h = base_height);

        // 2. Conical Section
        translate([0, 0, base_height])
        cylinder(d1 = cone_bottom_dia, d2 = cone_top_dia, h = cone_height);

        // 3. Top Column
        translate([0, 0, base_height + cone_height])
        cylinder(d = column_diameter, h = column_height);
    }
}

module tube_seat_cutout() {
    // The seat is a subtraction from the top down.
    // Part 1: Cylindrical seat from z=33 down to z=23
    translate([0, 0, total_height - seat_cyl_depth - 0.01])
    cylinder(d = tube_seat_dia, h = seat_cyl_depth + 0.02);

    // Part 2: Conical seat from z=23 down to z=6
    // We use hull to ensure a perfect cone between the two diameters
    hull() {
        // Top of seat cone (z=23)
        translate([0, 0, total_height - seat_cyl_depth])
        cylinder(d = seat_cone_top_dia, h = 0.01);
        
        // Bottom of seat cone (z=6)
        translate([0, 0, 6])
        cylinder(d = seat_cone_bottom_dia, h = 0.01);
    }
    
    // Ensure the hole is fully cleared down to z=6
    translate([0, 0, 5.9])
    cylinder(d = seat_cone_bottom_dia, h = 0.2);
}

module window_cutout() {
    // The window is 4mm wide in Y, cut through the column wall on the +X side.
    // To ensure it cuts "straight through the column wall", we make the box 
    // wide enough to span from the center to well beyond the column radius.
    // The window is between z=18 and z=30.
    
    // Positioned on +X side. 
    // X-range: from center (0) to column radius (11) + extra to ensure clean cut.
    // Y-range: -2 to 2 (width of 4).
    // Z-range: 18 to 30.
    translate([0, -window_width/2, window_z_start])
    cube([column_diameter, window_width, window_height + 0.1]);
}

// --- Final Assembly ---

difference() {
    // The solid body
    stand_geometry();

    // The tube seat (subtracted)
    tube_seat_cutout();

    // The viewing window (subtracted)
    window_cutout();
}