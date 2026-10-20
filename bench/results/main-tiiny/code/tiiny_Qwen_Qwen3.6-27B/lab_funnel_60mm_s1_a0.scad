// Lab Funnel - OpenSCAD Model
// Dimensions measured in mm

// Spout dimensions
spout_outer_dia = 10;
spout_inner_dia = 6.8;
spout_height = 20;

// Cone dimensions
cone_bottom_outer_dia = 10;
cone_top_outer_dia = 60;
cone_bottom_inner_dia = 6.8;
cone_top_inner_dia = cone_top_outer_dia - 2 * 1.6; // 56.8 mm
cone_height = 30; // z=20 to z=50

// Wall thickness
wall_thickness = 1.6;

// Print quality
$fn = 64;

// Center the funnel on the origin in X and Y
// The funnel rests on z=0 and builds upward

union() {
    // Spout (straight tube from z=0 to z=20)
    difference() {
        // Outer spout
        cylinder(h = spout_height, r = spout_outer_dia / 2, center = false);
        // Inner spout (bore) - extend slightly past to ensure clean cut
        translate([0, 0, -0.05])
        cylinder(h = spout_height + 0.1, r = spout_inner_dia / 2, center = false);
    }
    
    // Cone section (from z=20 to z=50)
    difference() {
        // Outer cone
        translate([0, 0, spout_height])
        cylinder(h = cone_height, r1 = cone_bottom_outer_dia / 2, r2 = cone_top_outer_dia / 2, center = false);
        
        // Inner cone (bore) - extend slightly past to ensure clean cut
        translate([0, 0, spout_height - 0.05])
        cylinder(h = cone_height + 0.1, r1 = cone_bottom_inner_dia / 2, r2 = cone_top_inner_dia / 2, center = false);
    }
}