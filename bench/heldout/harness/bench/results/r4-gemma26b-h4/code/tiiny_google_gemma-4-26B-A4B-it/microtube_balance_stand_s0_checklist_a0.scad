// Microcentrifuge tube stand for analytical balance
// Designed to be printed standing up (Z-axis is vertical)

// --- Dimensions ---
base_dia     = 50.0;    // Diameter of the base disc
base_h       = 4.0;     // Height of the base disc
cone_bottom_d = 50.0;   // Diameter at the bottom of the cone (z=4)
cone_top_d    = 22.0;   // Diameter at the top of the cone (z=14)
cone_h       = 10.0;    // Height of the cone section (14 - 4)
col_h        = 19.0;    // Height of the column (33 - 14)
col_dia      = 22.0;    // Diameter of the column

tube_seat_dia = 11.0;   // Diameter of the cylindrical seat
seat_depth    = 10.0;   // Depth of the cylindrical seat (33 - 23)
tube_tip_dia  = 3.0;    // Diameter at the tip of the tube cone
tip_cone_h    = 17.0;   // Height of the tip cone (23 - 6)

window_w      = 4.0;    // Width of the viewing window (in Y)
window_h      = 12.0;   // Height of the window (30 - 18)

$fn = 128;

// --- Helper Modules ---

module base_and_cone() {
    // The base disc
    cylinder(h = base_h, d = base_dia);
    
    // The cone section
    translate([0, 0, base_h])
    cylinder(h = cone_h, d1 = cone_bottom_d, d2 = cone_top_d);
}

module column() {
    // The main column
    translate([0, 0, base_h + cone_h])
    cylinder(h = col_h, d = col_dia);
}

module tube_seat_cutout() {
    // The cylindrical part of the seat
    translate([0, 0, base_h + cone_h + col_h - seat_depth])
    cylinder(h = seat_depth + 0.1, d = tube_seat_dia);
    
    // The conical part of the seat (follows tube tip)
    // Starts at z=23 (base_h + cone_h + col_h - seat_depth - tip_cone_h)
    // Ends at z=6
    translate([0, 0, base_h + cone_h + col_h - seat_depth - tip_cone_h])
    cylinder(h = tip_cone_h + 0.1, d1 = tube_seat_dia, d2 = tube_tip_dia);
}

module window_cutout() {
    // Window is cut on the +X side. 
    // It is 4mm wide in Y, meaning Y goes from -2 to 2.
    // It is between z=18 and z=30.
    // We use a cube to cut through the column.
    
    // Calculate the radius of the column at the window's vertical position
    // Since the window is between 18 and 30, and the column starts at z=24 (4+10+10)
    // Wait, let's re-calculate Z:
    // Base: 0-4
    // Cone: 4-14
    // Column: 14-33
    // Window: 18 to 30. This is entirely within the column.
    
    // The window is "cut straight through the column wall on the +X side"
    // This implies the window is a slot oriented along the X axis.
    // "4 mm wide (in Y)" means the thickness of the slot in the Y direction is 4mm.
    
    translate([0, -window_w/2, 18])
    cube([col_dia + 2, window_w, window_h]);
}

// --- Final Assembly ---

difference() {
    // Main Body
    union() {
        base_and_cone();
        column();
    }
    
    // The tube seat (the hole)
    tube_seat_cutout();
    
    // The viewing window
    // To ensure it cuts through the +X side, we translate it to the edge.
    // The prompt says "cut straight through... on the +X side". 
    // This usually means the window is a slot centered on the X axis.
    translate([0, -window_w/2, 18])
    cube([col_dia, window_w, window_h]);
}