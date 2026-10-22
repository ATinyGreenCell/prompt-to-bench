// --- Dimensions ---
base_diameter = 50.0;      // Diameter of the base disc
base_height = 4.0;         // Height of the base disc
cone_bottom_dia = 50.0;    // Diameter at the bottom of the cone (z=4)
cone_top_dia = 22.0;       // Diameter at the top of the cone (z=14)
cone_height = 10.0;        // Height of the cone section (14 - 4)
column_diameter = 22.0;     // Diameter of the top column
column_height = 19.0;      // Height of the column (33 - 14)
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
    // Seat Cylindrical part
    translate([0, 0, total_height - seat_cyl_depth - 0.1])
    cylinder(d = tube_seat_dia + 0.2, h = seat_cyl_depth + 0.2);

    // Seat Conical part
    // We use a hull of two cylinders to create the cone for the seat
    hull() {
        // Top of seat cone (z=23)
        translate([0, 0, total_height - seat_cyl_depth])
        cylinder(d = tube_seat_dia, h = 0.1);
        
        // Bottom of seat cone (z=6)
        translate([0, 0, 6])
        cylinder(d = seat_cone_bottom_dia, h = 0.1);
    }
    // Extend the cone downwards to ensure clean cut
    translate([0, 0, 0])
    cylinder(d = seat_cone_bottom_dia, h = 6.1);
}

module window_cutout() {
    // The window is cut on the +X side. 
    // We create a box that is wider than the column and centered on X.
    // The window is 4mm wide in Y, so Y goes from -2 to 2.
    translate([column_diameter/2 - 0.1, -window_width/2, window_z_start])
    cube([column_diameter, window_width, window_z_end - window_z_start + 0.2]);
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