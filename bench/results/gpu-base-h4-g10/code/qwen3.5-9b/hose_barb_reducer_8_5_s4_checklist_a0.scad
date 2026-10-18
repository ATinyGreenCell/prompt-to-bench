// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints upright along Z, centred on origin in X and Y.

$fn = 128;

// Dimensions
z_start      = 0;
z_8mm_top    = 20;
z_collar_bot = 20;
z_collar_top = 25;
z_5mm_bot    = 25;
z_end        = 41;

// 8mm tubing barbs (z = 0 to 20)
// Two stacked barbs, each 10mm tall.
// Barb profile: OD grows 7.5 -> 9.5, then steps back to 7.5.
barb_8_height = 10;
barb_8_bottom = 0;
barb_8_top    = 10;
barb_8_bottom_od = 7.5;
barb_8_top_od    = 9.5;
barb_8_step_od   = 7.5;

// 5mm tubing barbs (z = 25 to 41)
// Two stacked barbs, each 8mm tall.
// Barb profile: OD shrinks 6.5 -> 5.0, then steps back to 6.5.
barb_5_height = 8;
barb_5_bottom = 25;
barb_5_top    = 33;
barb_5_bottom_od = 6.5;
barb_5_top_od    = 5.0;
barb_5_step_od   = 6.5;

// Common features
bore_diameter = 3;
collar_diameter = 12;

// Generate the 8mm barb profile points for rotate_extrude
// Profile: Bottom OD -> Top OD -> Step OD -> Bottom OD
// We need to close the loop for rotate_extrude.
// Points: [radius, z]
// z=0, r=3.75 (7.5/2)
// z=10, r=4.75 (9.5/2)
// z=10, r=3.75 (7.5/2) - step
// z=0, r=3.75 (7.5/2) - close
// Note: The prompt says "steps straight back to 7.5". This implies a vertical drop in radius at the top.
// So the profile is: (3.75, 0) -> (4.75, 10) -> (3.75, 10) -> (3.75, 0).

module create_barb_8() {
    // Profile for 8mm barb
    // (radius, z)
    p = [
        [barb_8_bottom_od / 2, barb_8_bottom],
        [barb_8_top_od / 2, barb_8_top],
        [barb_8_step_od / 2, barb_8_top],
        [barb_8_bottom_od / 2, barb_8_bottom]
    ];
    rotate_extrude() polygon(p);
}

module create_barb_5() {
    // Profile for 5mm barb
    // (radius, z)
    p = [
        [barb_5_bottom_od / 2, barb_5_bottom],
        [barb_5_top_od / 2, barb_5_top],
        [barb_5_step_od / 2, barb_5_top],
        [barb_5_bottom_od / 2, barb_5_bottom]
    ];
    rotate_extrude() polygon(p);
}

module create_collar() {
    // Cylindrical collar from z=20 to z=25
    // Radius = 6mm (12mm diameter)
    r = collar_diameter / 2;
    h = z_collar_top - z_collar_bot;
    translate([0, 0, z_collar_bot]) cylinder(h = h, d = collar_diameter);
}

difference() {
    union() {
        // Main body: 8mm barbs
        translate([0, 0, z_start]) create_barb_8();
        
        // Cylindrical collar
        create_collar();
        
        // Main body: 5mm barbs
        translate([0, 0, z_5mm_bot]) create_barb_5();
    }
    
    // Bore through the entire length
    // Extend slightly past ends to ensure clean cut
    translate([0, 0, z_start - 1]) cylinder(h = (z_end - z_start) + 2, d = bore_diameter);
}