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

// Total sleeve height calculation: From Z=3 to top. Top is implicitly defined by the required bore change, let's assume a reasonable total height based on the stop at Z=11 and the need for screw holes at Z=21. We will make the overall height 32mm (Z=0 to Z=32) to accommodate all features cleanly above the plate base.
total_sleeve_height = 32;

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
    // The sleeve is centered on the X/Y plane of the hole for placement later
    translate([camera_hole_x, camera_hole_y, 0]) {

        difference() {
            // 1. Outer shape (full height) - Using the largest OD for the main body structure
            cylinder(h = total_sleeve_height + 0.2, r = sleeve_outer_diameter / 2);

            // 2. Inner bore section 1 (Stop: Z=3 to Z=11)
            translate([0, 0, sleeve_inner_bore_start_z]) {
                cylinder(h = sleeve_inner_bore_stop_z - sleeve_inner_bore_start_z + 0.2, r = sleeve_inner_bore_diameter / 2);
            }

            // 3. Inner bore section 2 (Eyepiece slide: Z=11 to Top)
            // This cut must be made from the top of the stop bore up to the total height.
            translate([0, 0, sleeve_inner_bore_stop_z]) {
                cylinder(h = total_sleeve_height - sleeve_inner_bore_stop_z + 0.2, r = sleeve_outer_top_diameter / 2);
            }

            // 4. Screw holes (Radial cuts through the wall at Z=21)
            for (i = [0 : num_screws - 1]) {
                angle = i * (360 / num_screws);
                rotate([0, 0, angle]) {
                    // Cut a hole centered on the sleeve axis, extending through the wall thickness.
                    // The cut must be large enough to pass through the material at Z=21.
                    translate([0, 0, screw_hole_z_level - 0.1]) {
                        cylinder(h = 1.0 + 0.2, r = screw_hole_diameter / 2);
                    }
                }
            }
        }
    }
}

// --- Assembly ---

difference() {
    // 1. Base Plate (rests on Z=0)
    base_plate();

    // 2. Cut Camera Hole in the plate
    camera_hole_cutter();

    // 3. Sleeve structure placed on top of the plate (starts at Z=3)
    translate([0, 0, plate_thickness]) {
        round_sleeve();
    }
}