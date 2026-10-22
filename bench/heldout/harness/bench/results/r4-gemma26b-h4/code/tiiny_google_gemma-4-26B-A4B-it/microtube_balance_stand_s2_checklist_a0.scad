// Microcentrifuge tube stand for analytical balance
// Designed to be printed standing up (Z-axis)

// --- Dimensions ---
base_dia      = 50.0;    // Diameter of the base disc
base_height   = 4.0;     // Thickness of the base disc
cone_start_z  = 4.0;     // Z-height where the cone starts
cone_end_z    = 14.0;    // Z-height where the cone ends
cone_top_dia  = 22.0;    // Diameter at the top of the cone
column_height = 33.0;    // Total height of the column part
column_start_z = 14.0;   // Z-height where the column starts

tube_seat_dia = 11.0;    // Diameter of the cylindrical seat
seat_depth    = 10.0;    // Depth of the cylindrical seat (33 - 23)
seat_bottom_z = 23.0;    // Z-height where the seat transitions to cone
tip_cone_dia  = 3.0;     // Diameter at the very tip of the internal cone
tip_cone_z    = 6.0;     // Z-height of the tip of the internal cone

window_width  = 4.0;     // Width of the viewing window in Y direction
window_height = 12.0;    // Height of the window (30 - 18)
window_z_min   = 18.0;   // Bottom Z of the window
window_z_max   = 30.0;   // Top Z of the window

$fn = 128;

// --- Modeling ---

module stand_geometry() {
    // 1. Base Disc
    cylinder(h = base_height, d = base_dia);
    
    // 2. Conical Transition
    cylinder(h = cone_end_z - cone_start_z, d1 = base_dia, d2 = cone_top_dia);
    
    // 3. Main Column
    translate([0, 0, cone_end_z])
        cylinder(h = column_height - cone_end_z, d = cone_top_dia);
}

module tube_seat_cutout() {
    // 1. Cylindrical part of the seat
    translate([0, 0, seat_bottom_z])
        cylinder(h = seat_depth, d = tube_seat_dia);
    
    // 2. Conical part of the seat (following the tube tip)
    // The cone goes from d=11 at z=23 to d=3 at z=6
    // We use a polygon/rotate_extrude approach or a cone
    // Since it's a subtraction, we define the cone shape
    translate([0, 0, tip_cone_z])
        cylinder(h = seat_bottom_z - tip_cone_z, d1 = tip_cone_dia, d2 = tube_seat_dia);
}

module window_cutout() {
    // The window is cut through the column wall on the +X side.
    // It is 4mm wide in Y, meaning from Y = -2 to Y = 2.
    // It is cut from the seat (z=18) to z=30.
    // We use a large cube to ensure it cuts through the wall.
    translate([cone_top_dia/2 - 1, -window_width/2, window_z_min])
        cube([cone_top_dia, window_width, window_height]);
}

// Final Assembly
difference() {
    stand_geometry();
    
    // Subtract the tube seat
    tube_seat_cutout();
    
    // Subtract the viewing window
    window_cutout();
}