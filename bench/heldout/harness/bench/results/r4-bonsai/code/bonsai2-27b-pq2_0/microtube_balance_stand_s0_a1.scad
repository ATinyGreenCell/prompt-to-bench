// 1.5 mL microcentrifuge tube stand for analytical balance
// Print orientation: standing up, base on XY plane at z=0, centred on origin.

// ---- Dimensions (mm) ----
base_diameter   = 50;   // base disc diameter
base_height     = 4;    // base disc height (z = 0..4)
cone_top_diam   = 22;   // cone top diameter at z=14
cone_top_z      = 14;   // cone top height
column_diameter = 22;   // column diameter
column_top_z    = 33;   // column top height
seat_diameter   = 11;   // tube seat diameter
seat_bottom_z   = 23;   // seat bottom height
tip_diameter    = 3;    // tube tip diameter
tip_bottom_z    = 6;    // tip cone bottom height
window_width    = 4;    // viewing window width in Y
window_bottom_z = 18;   // window bottom height
window_top_z    = 30;   // window top height
cut_margin      = 1;    // extra mm for clean cuts

$fn = 64;               // resolution for curved shapes

// ---- Build the solid ----
// Base disc (z = 0..4)
// Cone (z = 4..14)
// Column (z = 14..33)
// Tube seat (z = 23..33)
// Tube tip cone (z = 6..23)
// Viewing window cut (z = 18..30, +X side)

difference() {
    // Solid
    union() {
        // Base disc
        cylinder(h = base_height, d = base_diameter);

        // Cone
        translate([0, 0, base_height])
            cylinder(h = cone_top_z - base_height,
                     d1 = base_diameter,
                     d2 = cone_top_diam);

        // Column
        translate([0, 0, cone_top_z])
            cylinder(h = column_top_z - cone_top_z,
                     d = column_diameter);

        // Tube seat
        translate([0, 0, seat_bottom_z])
            cylinder(h = column_top_z - seat_bottom_z,
                     d = seat_diameter);

        // Tube tip cone
        translate([0, 0, tip_bottom_z])
            cylinder(h = seat_bottom_z - tip_bottom_z,
                     d1 = tip_diameter,
                     d2 = seat_diameter);
    }

    // Viewing window cut
    // The window is on the +X side, so it starts at x = seat_diameter/2
    // and extends to x = column_diameter/2 + cut_margin.
    // It is centred in Y at 0, width = window_width.
    // It spans z from window_bottom_z to window_top_z.
    translate([seat_diameter/2, 0, window_bottom_z])
        cube([column_diameter/2 - seat_diameter/2 + cut_margin,
              window_width,
              window_top_z - window_bottom_z]);
}