// Microcentrifuge tube stand for analytical balance
// Corrected version to ensure exact Z-heights and +X window placement

// --- Dimensions ---
base_dia      = 50.0;    // Diameter of the base disc
base_h        = 4.0;     // Height of the base disc
cone_bottom_d = 50.0;   // Diameter at z=4
cone_top_d    = 22.0;   // Diameter at z=14
cone_h        = 10.0;    // Height of cone (14 - 4)
col_h         = 19.0;    // Height of column (33 - 14)
col_dia       = 22.0;    // Diameter of column

tube_seat_dia = 11.0;   // Diameter of cylindrical seat
seat_cyl_h    = 10.0;   // Height of cylindrical seat (33 - 23)
tube_tip_dia  = 3.0;    // Diameter at the tip (z=6)
tip_cone_h    = 17.0;   // Height of tip cone (23 - 6)

window_w      = 4.0;    // Width of window in Y
window_h      = 12.0;   // Height of window (30 - 18)

$fn = 128;

// --- Assembly ---

difference() {
    // 1. The Main Body
    union() {
        // Base disc: z = 0 to 4
        cylinder(h = base_h, d = base_dia);
        
        // Cone section: z = 4 to 14
        translate([0, 0, base_h])
        cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
        
        // Column: z = 14 to 33
        translate([0, 0, base_h + cone_h])
        cylinder(h = col_h, d = col_dia);
    }

    // 2. The Tube Seat (Subtractive)
    // Cylindrical part: z = 23 to 33
    // We use a small overlap (0.1) to ensure clean cut
    translate([0, 0, 33 - seat_cyl_h])
    cylinder(h = seat_cyl_h + 0.1, d = tube_seat_dia);
    
    // Conical part: z = 6 to 23
    translate([0, 0, 6])
    cylinder(h = tip_cone_h + 0.1, d1 = tube_seat_dia, d2 = tube_tip_dia);

    // 3. The Viewing Window (Subtractive)
    // "cut straight through the column wall on the +X side"
    // "4 mm wide (in Y)"
    // "between z=18 and z=30"
    // To place on +X side, we translate the cube so its left face is at X=0.
    // The cube width in X must be at least the radius of the column to cut through.
    translate([0, -window_w/2, 18])
    cube([col_dia, window_w, window_h]);
}