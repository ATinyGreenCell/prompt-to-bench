// Microcentrifuge tube stand for analytical balance
// Designed to be printed standing up (Z-axis)

// --- Dimensions ---
base_d       = 50.0;    // Diameter of the base disc
base_h       = 4.0;     // Height of the base disc
cone_bottom_d = 50.0;   // Diameter at the bottom of the cone (z=4)
cone_top_d    = 22.0;   // Diameter at the top of the cone (z=14)
cone_h       = 10.0;    // Height of the cone section (14 - 4)
col_h        = 19.0;    // Height of the column section (33 - 14)
total_h      = 33.0;    // Total height of the stand

tube_seat_d  = 11.0;    // Diameter of the cylindrical seat
tube_seat_h  = 10.0;    // Height of the cylindrical seat (33 - 23)
tube_tip_d   = 3.0;     // Diameter at the tip of the internal cone
tube_tip_z   = 6.0;     // Z-coordinate where the internal cone ends
tube_tip_h   = 17.0;    // Height of the internal cone (23 - 6)

window_w     = 4.0;     // Width of the viewing window (along Y)
window_z_min  = 18.0;   // Bottom of the viewing window
window_z_max  = 30.0;   // Top of the viewing window

$fn = 128;

// --- Modeling ---

module stand_geometry() {
    union() {
        // 1. Base Disc
        cylinder(h = base_h, d = base_d);
        
        // 2. Conical Section (z=4 to z=14)
        translate([0, 0, base_h])
            cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
        
        // 3. Column Section (z=14 to z=33)
        translate([0, 0, base_h + cone_h])
            cylinder(h = col_h, d = cone_top_d);
    }
}

module tube_seat_cutout() {
    // 4. Cylindrical Seat (z=23 to z=33)
    translate([0, 0, total_h - tube_seat_h])
        cylinder(h = tube_seat_h + 0.1, d = tube_seat_d);
    
    // 5. Internal Conical Tip (z=6 to z=23)
    // The cone narrows from 11mm at z=23 to 3mm at z=6
    translate([0, 0, tube_tip_z])
        cylinder(h = tube_tip_h + 0.1, d1 = tube_tip_d, d2 = tube_seat_d);
}

module window_cutout() {
    // 6. Viewing Window
    // Cut through the +X side. 
    // The window is 4mm wide in Y, so it spans from -2 to +2 in Y.
    // We use a large cube to ensure it cuts through the entire column wall.
    // The column radius is 11mm. We'll extend the cube from the center out to 20mm.
    translate([0, -window_w/2, window_z_min])
        cube([20, window_w, window_z_max - window_z_min + 0.1]);
}

// Final Assembly
difference() {
    stand_geometry(),
    tube_seat_cutout(),
    window_cutout()
}