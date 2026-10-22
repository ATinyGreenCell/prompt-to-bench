$fn = 128;

// --- Dimensions ---
// Main bore diameter (straight through)
$main_bore_d = 3;

// Upper Section (8mm tubing)
$upper_section_z_start = 0;
$upper_section_z_end = 20;
$upper_barb_count = 2;
$upper_barb_height = 10;
$upper_barb_bottom_od = 7.5;
$upper_barb_top_od = 9.5;
$upper_barb_step_back = 7.5; // Diameter after the sawtooth peak

// Lower Section (5mm tubing)
$lower_section_z_start = 25;
$lower_section_z_end = 41;
$lower_barb_count = 2;
$lower_barb_height = 8;
$lower_barb_bottom_od = 6.5;
$lower_barb_top_od = 5.0;
$lower_barb_step_back = 6.5; // Diameter after the sawtooth peak

// Collar Section
$collar_z_start = 20;
$collar_z_end = 25;
$collar_diameter = 12;

// --- Helper Module for Sawtooth Barb ---
// Generates a single barb with a sawtooth profile: linear growth, peak, linear shrink, step back.
// z_start: bottom of the barb
// z_end: top of the barb
// bottom_od: outer diameter at z_start
// top_od: outer diameter at the peak (before shrinking)
// step_back: outer diameter after the peak (flat top)
module sawtooth_barb(z_start, z_end, bottom_od, top_od, step_back) {
    // Calculate radii
    r1 = bottom_od / 2;
    r2 = top_od / 2;
    r3 = step_back / 2;
    
    // Define the path in the XZ plane for rotation
    // Points: [x, z]
    // 1. Bottom: [r1, z_start]
    // 2. Peak: [r2, z_end]
    // 3. Step: [r3, z_end]
    // 4. Close: [r1, z_start]
    
    path = [
        [r1, z_start],
        [r2, z_end],
        [r3, z_end],
        [r1, z_start]
    ];
    
    // Use rotate_extrude to create the solid of revolution
    rotate_extrude() {
        polygon(points=path, convex=false);
    }
}

// --- Helper Module for Main Bore ---
// Creates a straight cylindrical hole through the center
module main_bore(z_start, z_end) {
    r = $main_bore_d / 2;
    translate([0, 0, z_start]) {
        cylinder(h = z_end - z_start, r = r, $fn = 128);
    }
}

// --- Main Assembly ---
// Start with the main body block (approximate bounding box)
// We will build the outer shape and then subtract the bore.

// 1. Upper Section (0 to 20)
// Two barbs stacked.
translate([0, 0, 0]) {
    // Barb 1 (Bottom)
    sawtooth_barb(0, 10, $upper_barb_bottom_od, $upper_barb_top_od, $upper_barb_step_back);
    
    // Barb 2 (Top)
    sawtooth_barb(10, 20, $upper_barb_bottom_od, $upper_barb_top_od, $upper_barb_step_back);
}

// 2. Collar Section (20 to 25)
translate([0, 0, 20]) {
    cylinder(h = 5, r = $collar_diameter / 2, $fn = 128);
}

// 3. Lower Section (25 to 41)
// Two barbs stacked.
translate([0, 0, 25]) {
    // Barb 1 (Bottom)
    sawtooth_barb(25, 33, $lower_barb_bottom_od, $lower_barb_top_od, $lower_barb_step_back);
    
    // Barb 2 (Top)
    sawtooth_barb(33, 41, $lower_barb_bottom_od, $lower_barb_top_od, $lower_barb_step_back);
}

// 4. Subtract the Main Bore (0 to 41)
// The bore runs through the full length.
// We subtract it from the union of all parts.
// To ensure clean cuts, we extend the cutting cylinder slightly past the ends.
difference() {
    // Union of all parts (implicitly handled by the previous blocks if we wrap them, 
    // but here we need to group them to subtract the bore from the whole assembly)
    
    // Let's restructure to ensure a single solid is created before subtraction.
    // We will create a union of all the parts first.
    
    union() {
        // Upper Section
        translate([0, 0, 0]) {
            sawtooth_barb(0, 10, $upper_barb_bottom_od, $upper_barb_top_od, $upper_barb_step_back);
            sawtooth_barb(10, 20, $upper_barb_bottom_od, $upper_barb_top_od, $upper_barb_step_back);
        }
        
        // Collar Section
        translate([0, 0, 20]) {
            cylinder(h = 5, r = $collar_diameter / 2, $fn = 128);
        }
        
        // Lower Section
        translate([0, 0, 25]) {
            sawtooth_barb(25, 33, $lower_barb_bottom_od, $lower_barb_top_od, $lower_barb_step_back);
            sawtooth_barb(33, 41, $lower_barb_bottom_od, $lower_barb_top_od, $lower_barb_step_back);
        }
    }
    
    // Subtract the bore
    translate([0, 0, -0.1]) {
        cylinder(h = 41.2, r = $main_bore_d / 2, $fn = 128);
    }
}