// Hose Barb Reducer: 8mm ID to 5mm ID
// Designed for FDM printing, standing upright along Z-axis.

// Global settings
$fn = 64; // High resolution for smooth curves

// --- Dimensions for 8mm Tubing Barbs (Bottom Section) ---
tubing_8mm_id = 8;
barb_8mm_height = 10; // Height of each individual barb
barb_8mm_bottom_od = 7.5; // OD at the base of the barb
barb_8mm_top_od = 9.5; // OD at the tip of the barb
num_barbs_8mm = 2; // Number of stacked barbs

// --- Dimensions for 5mm Tubing Barbs (Top Section) ---
tubing_5mm_id = 5;
barb_5mm_height = 8; // Height of each individual barb
barb_5mm_bottom_od = 6.5; // OD at the base of the barb
barb_5mm_top_od = 5.0; // OD at the tip of the barb
num_barbs_5mm = 2; // Number of stacked barbs

// --- Dimensions for Collar (Middle Section) ---
collar_z_start = 20;
collar_z_end = 25;
collar_diameter = 12;

// --- Bore Dimensions ---
bore_diameter = 3;
total_length = 41; // Total height of the part

// --- Helper Module: Create a single tapered barb segment ---
// This creates a frustum (tapered cylinder) representing one barb tooth.
// It is centered at the origin in X/Y, and extends from z=0 to z=height.
module barb_segment(height, bottom_od, top_od) {
    // We use a linear_extrude of a polygon to create the taper, 
    // or simply a cylinder with different radii if we were using a more complex approach.
    // However, OpenSCAD's cylinder only supports constant radius.
    // So we use a linear_extrude of a trapezoid, or better yet, a rotate_extrude of a polygon.
    // Actually, the simplest way to make a tapered cylinder in OpenSCAD is using a hull of two circles 
    // or a linear_extrude. Let's use linear_extrude of a polygon for precision.
    
    // Define the cross-section profile (half-profile for rotate_extrude is easier)
    // But since we are building the whole object, let's just use a cylinder approximation 
    // or a hull. A hull of two cylinders (one at bottom, one at top) works well.
    
    // Bottom circle
    translate([0, 0, 0])
        cylinder(h = 0.01, r = bottom_od / 2, center = false);
        
    // Top circle
    translate([0, 0, height])
        cylinder(h = 0.01, r = top_od / 2, center = false);
        
    // Hull them together to create the taper
    hull() {
        translate([0, 0, 0])
            cylinder(h = 0.01, r = bottom_od / 2, center = false);
        translate([0, 0, height])
            cylinder(h = 0.01, r = top_od / 2, center = false);
    }
}

// --- Main Body Construction ---
difference() {
    union() {
        // 1. Bottom Section: 8mm Tubing Barbs (z = 0 to z = 20)
        for (i = [0 : num_barbs_8mm - 1]) {
            z_offset = i * barb_8mm_height;
            translate([0, 0, z_offset])
                barb_segment(barb_8mm_height, barb_8mm_bottom_od, barb_8mm_top_od);
        }
        
        // 2. Middle Section: Collar (z = 20 to z = 25)
        translate([0, 0, collar_z_start])
            cylinder(h = collar_z_end - collar_z_start, d = collar_diameter, center = false);
            
        // 3. Top Section: 5mm Tubing Barbs (z = 25 to z = 41)
        for (i = [0 : num_barbs_5mm - 1]) {
            z_offset = collar_z_end + i * barb_5mm_height;
            translate([0, 0, z_offset])
                barb_segment(barb_5mm_height, barb_5mm_bottom_od, barb_5mm_top_od);
        }
    }
    
    // 4. Central Bore (z = 0 to z = 41)
    // Extend slightly past the top and bottom to ensure clean cuts
    translate([0, 0, -0.1])
        cylinder(h = total_length + 0.2, d = bore_diameter, center = false);
}