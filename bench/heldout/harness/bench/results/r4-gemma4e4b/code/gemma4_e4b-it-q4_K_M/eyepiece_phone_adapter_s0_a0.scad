// --- Dimensions ---

// Base Plate dimensions
plate_length_x = 80;  // X dimension of the flat plate (mm)
plate_width_y = 60;   // Y dimension of the flat plate (mm)
plate_thickness = 3;  // Z thickness of the flat plate (mm)

// Camera Hole dimensions
camera_hole_diameter = 12; // Diameter of the hole for the phone camera (mm)
camera_hole_x = -20;       // X position of the camera hole center (mm)
camera_hole_y = 10;        // Y position of the camera hole center (mm)

// Sleeve dimensions
sleeve_outer_diameter = 36.6; // Outer diameter of the round sleeve (mm)
sleeve_inner_bore_stop_z = 11; // Z height where inner bore changes (mm)
sleeve_inner_bore_start_z = 3;  // Z height where inner bore starts (mm)
sleeve_inner_bore_diameter = 22; // Diameter of the stop bore (mm)
sleeve_outer_top_diameter = 30.6; // Diameter for eyepiece sliding section (mm)

// Screw hole dimensions
screw_hole_diameter = 2.5;  // Diameter for M3 centering screws (mm)
screw_hole_z_level = 21;    // Z height where screw holes are located (mm)
num_screws = 3;             // Number of radial mounting screws

// --- Constants ---
$fn = 64; // High resolution for curves

// --- Modules ---

// Module to create the main plate
module base_plate() {
    cube([plate_length_x, plate_width_y, plate_thickness]);
}

// Module to cut the camera hole through the plate
module camera_hole_cutter() {
    translate([camera_hole_x, camera_hole_y, -0.1]) { // Extend slightly below Z=0
        cylinder(h = plate_thickness + 0.2, r = camera_hole_diameter / 2);
    }
}

// Module to create the sleeve structure
module round_sleeve() {
    // The sleeve is centered on the X/Y plane of the hole for simplicity in placement later
    translate([camera_hole_x, camera_hole_y, 0]) {

        // 1. Outer shape (full height)
        difference() {
            cylinder(h = 32, r = sleeve_outer_diameter / 2); // Total height: 3 + (31-3) = 29. Use slightly more for safety margin.

            // 2. Inner bore section 1 (Stop - Z=3 to Z=11)
            translate([0, 0, sleeve_inner_bore_start_z]) {
                cylinder(h = sleeve_inner_bore_stop_z - sleeve_inner_bore_start_z + 0.2, r = sleeve_inner_bore_diameter / 2);
            }

            // 3. Inner bore section 2 (Eyepiece slide - Z=11 to Top)
            translate([0, 0, sleeve_inner_bore_stop_z]) {
                cylinder(h = 32 - sleeve_inner_bore_stop_z + 0.2, r = sleeve_outer_top_diameter / 2); // Use the smaller diameter for this section if needed, but the prompt implies a continuous outer shape with different inner bores. Let's model the required bore change.
            }

            // Re-evaluating the bore: The sleeve has one outer OD (36.6mm).
            // Bore 1: 22mm from Z=3 to Z=11.
            // Bore 2: 30.6mm from Z=11 to top.

            // Cut for Bore 1 (Z=3 to Z=11)
            translate([0, 0, sleeve_inner_bore_start_z]) {
                cylinder(h = sleeve_inner_bore_stop_z - sleeve_inner_bore_start_z + 0.2, r = sleeve_inner_bore_diameter / 2);
            }

            // Cut for Bore 2 (Z=11 to Top)
            translate([0, 0, sleeve_inner_bore_stop_z]) {
                cylinder(h = 32 - sleeve_inner_bore_stop_z + 0.2, r = sleeve_outer_top_diameter / 2); // This cut is larger than the outer diameter if we use OD=36.6mm for the whole thing.

            // ASSUMPTION: The outer diameter (36.6mm) applies to the entire height.
            // Bore 1: 22mm radius up to Z=11.
            // Bore 2: 30.6mm radius from Z=11 upwards, but it must fit inside the 36.6mm outer diameter. This implies a step down in the sleeve wall thickness above Z=11.

            // Let's model the required internal geometry based on the description:
            // Outer OD = 36.6 mm (R_out = 18.3)
            // Bore 1 (Z=3 to 11): ID = 22 mm (R_in1 = 11)
            // Bore 2 (Z=11 to Top): ID = 30.6 mm (R_in2 = 15.3)

            // Cut for Bore 1 (Z=3 to Z=11)
            translate([0, 0, sleeve_inner_bore_start_z]) {
                cylinder(h = sleeve_inner_bore_stop_z - sleeve_inner_bore_start_z + 0.