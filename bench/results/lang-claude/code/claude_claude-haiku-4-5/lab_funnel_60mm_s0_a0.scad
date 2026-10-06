// Small laboratory funnel for liquid transfer
// Stands upright with wide mouth on top
// Open at both ends for direct flow

// Dimensions (mm)
outer_tube_diameter = 10;        // outer diameter of narrow section
outer_cone_top_diameter = 10;    // outer diameter where cone starts
outer_cone_bottom_diameter = 60; // outer diameter at wide opening (top)
tube_height = 20;                // height of narrow cylindrical section
cone_height = 30;                // height of conical section
wall_thickness = 1.6;            // wall thickness (constant throughout)

// Calculated values
outer_tube_r = outer_tube_diameter / 2;
outer_cone_top_r = outer_cone_top_diameter / 2;
outer_cone_bottom_r = outer_cone_bottom_diameter / 2;
inner_tube_r = outer_tube_r - wall_thickness;
inner_cone_top_r = outer_cone_top_r - wall_thickness;
inner_cone_bottom_r = outer_cone_bottom_r - wall_thickness;

$fn = 64;

// Create the funnel
difference() {
    // Outer surfaces
    union() {
        // Cylindrical tube (z=0 to z=20)
        cylinder(h = tube_height, r = outer_tube_r, center = false);
        // Conical funnel (z=20 to z=50)
        translate([0, 0, tube_height])
            cylinder(h = cone_height, r1 = outer_cone_top_r, r2 = outer_cone_bottom_r, center = false);
    }
    
    // Inner cavity (to be subtracted)
    union() {
        // Cylindrical cavity in tube section
        cylinder(h = tube_height + 0.1, r = inner_tube_r, center = false);
        // Conical cavity in funnel section
        translate([0, 0, tube_height])
            cylinder(h = cone_height + 0.1, r1 = inner_cone_top_r, r2 = inner_cone_bottom_r, center = false);
    }
}