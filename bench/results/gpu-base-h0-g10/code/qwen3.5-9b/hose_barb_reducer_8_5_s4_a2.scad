// Hose-barb Reducer Design
// Units: millimetres
// Orientation: Standing upright along Z, resting on XY plane at z=0

// --- Dimensions ---
// Main bore diameter (constant through the part)
$main_bore_d = 3.0;
$main_bore_r = $main_bore_d / 2;

// Section 1: 8mm Tubing Barbs (z = 0 to 20)
// Two identical barbs stacked.
// Barb 1: z=0 to 10. Barb 2: z=10 to 20.
$z_start_1 = 0;
$z_end_1 = 20;
$barb_height_1 = 10;
$barb_od_bottom_1 = 7.5;
$barb_od_top_1 = 9.5;

// Section 2: Collar (z = 20 to 25)
$z_start_2 = 20;
$z_end_2 = 25;
$collar_od = 12.0;
$collar_r = $collar_od / 2;

// Section 3: 5mm Tubing Barbs (z = 25 to 41)
// Two identical barbs stacked.
// Barb 3: z=25 to 33. Barb 4: z=33 to 41.
$z_start_3 = 25;
$z_end_3 = 41;
$barb_height_3 = 8;
$barb_od_bottom_3 = 6.5;
$barb_od_top_3 = 5.0;

// --- Geometry Generation ---

module build_part() {
    // We build the part by unioning distinct sections to ensure watertightness.
    // Then we subtract the central bore.
    
    union() {
        // --- Barb 1 (z=0 to 10) ---
        // OD grows linearly from 7.5 to 9.5
        translate([0, 0, 0])
        cylinder(
            h=$barb_height_1,
            r1=$barb_od_bottom_1 / 2,
            r2=$barb_od_top_1 / 2,
            center=false
        );

        // --- Barb 2 (z=10 to 20) ---
        // OD grows linearly from 7.5 to 9.5
        translate([0, 0, $barb_height_1])
        cylinder(
            h=$barb_height_1,
            r1=$barb_od_bottom_1 / 2,
            r2=$barb_od_top_1 / 2,
            center=false
        );

        // --- Collar (z=20 to 25) ---
        // Cylindrical, OD 12mm
        translate([0, 0, $z_end_1])
        cylinder(
            h=($z_end_2 - $z_start_2),
            r=$collar_r,
            center=false
        );

        // --- Barb 3 (z=25 to 33) ---
        // OD shrinks linearly from 6.5 to 5.0
        translate([0, 0, $z_start_3])
        cylinder(
            h=$barb_height_3,
            r1=$barb_od_bottom_3 / 2,
            r2=$barb_od_top_3 / 2,
            center=false
        );

        // --- Barb 4 (z=33 to 41) ---
        // OD shrinks linearly from 6.5 to 5.0
        translate([0, 0, $z_start_3 + $barb_height_3])
        cylinder(
            h=$barb_height_3,
            r1=$barb_od_bottom_3 / 2,
            r2=$barb_od_top_3 / 2,
            center=false
        );
    }
    
    // --- Subtract Central Bore ---
    // The bore runs straight through the full length (z=0 to z=41)
    difference() {
        // We need to subtract the hole from the union created above.
        // Since we are inside a difference(), we define the cutter.
        // Note: The union() above is the "positive" geometry. 
        // We must wrap the union in a difference() to subtract the hole, 
        // OR structure the code as: difference() { union() { ... } cylinder() { ... } }
        
        // Let's restructure to ensure the subtraction applies to the whole assembly.
        // The previous structure (union() { ... }) was inside build_part().
        // We need to move the subtraction outside or nest it correctly.
        
        // Correct structure:
        // difference() {
        //    union() { ... cylinders ... }
        //    cylinder() { ... hole ... }
        // }
    }
}

// Corrected Structure for Subtraction
difference() {
    union() {
        // --- Barb 1 (z=0 to 10) ---
        translate([0, 0, 0])
        cylinder(
            h=$barb_height_1,
            r1=$barb_od_bottom_1 / 2,
            r2=$barb_od_top_1 / 2,
            center=false
        );

        // --- Barb 2 (z=10 to 20) ---
        translate([0, 0, $barb_height_1])
        cylinder(
            h=$barb_height_1,
            r1=$barb_od_bottom_1 / 2,
            r2=$barb_od_top_1 / 2,
            center=false
        );

        // --- Collar (z=20 to 25) ---
        translate([0, 0, $z_end_1])
        cylinder(
            h=($z_end_2 - $z_start_2),
            r=$collar_r,
            center=false
        );

        // --- Barb 3 (z=25 to 33) ---
        translate([0, 0, $z_start_3])
        cylinder(
            h=$barb_height_3,
            r1=$barb_od_bottom_3 / 2,
            r2=$barb_od_top_3 / 2,
            center=false