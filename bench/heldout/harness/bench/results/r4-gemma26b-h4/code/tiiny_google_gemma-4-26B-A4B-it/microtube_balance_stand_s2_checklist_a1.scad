// Microcentrifuge tube stand for analytical balance
// Corrected for manifold geometry and continuous profiles

// --- Dimensions ---
base_dia      = 50.0;    // Diameter of the base disc
base_height   = 4.0;     // Thickness of the base disc
cone_start_z  = 4.0;     // Z-height where the cone starts
cone_end_z    = 14.0;    // Z-height where the cone ends
cone_top_dia  = 22.0;    // Diameter at the top of the cone
column_height = 33.0;    // Total height of the column part
column_start_z = 14.0;   // Z-height where the column starts

tube_seat_dia = 11.0;    // Diameter of the cylindrical seat
seat_bottom_z = 23.0;    // Z-height where the seat transitions to cone
tip_cone_dia  = 3.0;     // Diameter at the very tip of the internal cone
tip_cone_z    = 6.0;     // Z-height of the tip of the internal cone

window_width  = 4.0;     // Width of the viewing window in Y direction
window_height = 12.0;    // Height of the window (30 - 18)
window_z_min   = 18.0;   // Bottom Z of the window
window_z_max   = 30.0;   // Top Z of the window

$fn = 128;

// --- Modeling ---

module stand_body() {
    union() {
        // 1. Base Disc
        cylinder(h = base_height, d = base_dia);
        
        // 2. Conical Transition
        // We use translate to ensure it starts exactly where the base ends
        translate([0, 0, base_height])
            cylinder(h = cone_end_z - base_height, d1 = base_dia, d2 = cone_top_dia);
        
        // 3. Main Column
        translate([0, 0, cone_end_z])
            cylinder(h = column_height - cone_end_z, d = cone_top_dia);
    }
}

module tube_seat_cutout() {
    // 1. Cylindrical part of the seat (z=23 to z=33)
    translate([0, 0, seat_bottom_z])
        cylinder(h = 33 - seat_bottom_z + 0.1, d = tube_seat_dia);
    
    // 2. Conical part of the seat (z=6 to z=23)
    // d1=3 at z=6, d2=11 at z=23
    translate([0, 0, tip_cone_z])
        cylinder(h = seat_bottom_z - tip_cone_z + 0.1, d1 = tip_cone_dia, d2 = tube_seat_dia);
}

module window_cutout() {
    // The window is cut through the column wall on the +X side.
    // To ensure it cuts through, we position the cube so it starts at the center 
    // and extends past the outer radius of the column.
    // Column radius is 22/2 = 11.
    // Window is 4mm wide in Y (from -2 to 2).
    // Window is on +X side.
    translate([0, -window_width/2, window_z_min])
        cube([20, window_width, window_height + 0.1]);
}

// Final Assembly
difference() {
    stand_body();
    tube_seat_cutout();
    window_cutout();
}