// L-shaped (hockey-stick) cell spreader for plating bacteria

// --- Dimensions ---

// Handle dimensions
handle_length = 150;    // Length of the main bar (X direction)
handle_width = 6;       // Width of the handle
handle_thickness = 4;   // Thickness of the handle
handle_x_start = 0;     // X start for handle placement (to ensure it starts at Z=0 plane)
handle_y_min = -3;      // Y min for handle placement
handle_y_max = 3;       // Y max for handle placement

// Spreading foot dimensions
foot_length = 40;       // Length of the spreading foot
foot_width = 5;         // Width of the spreading foot
foot_thickness = 2.5;   // Thickness of the spreading foot
angle_degrees = 120;    // Angle between handle and foot (counter-clockwise from +X)

// Boss dimensions
boss_diameter = 6;      // Diameter of the central boss
boss_height = 4;        // Height of the central boss

// Hole dimensions
hole_diameter = 4;      // Diameter of the hanging hole
hole_x_position = 143;  // X position where the hole is cut in the handle

// --- Constants ---
$fn = 64;

// --- Geometry Construction ---

module handle() {
    // The handle must rest on Z=0. We define it starting at Z=0 and extending up by thickness.
    cube([handle_length, handle_width, handle_thickness], center = false);
}

module foot() {
    angle_rad = angle_degrees * (PI / 180);
    
    // Define the foot shape centered on its local axes
    foot_shape = cube([foot_length, foot_width, foot_thickness], center = true);

    // Rotate it and then translate so that one end is at the origin (Z=0 plane).
    // The foot thickness is 2.5mm. To rest on Z=0, its lowest point must be at Z=0.
    rotate([0, 0, angle_degrees]) {
        // Shift back by half its length along the rotated axis so the junction point is at the origin (X/Y).
        // We also shift it down by half its thickness to rest on Z=0.
        translate([-foot_length/2, 0, -foot_thickness/2]) {
            foot_shape;
        }
    }
}

module boss() {
    // Boss centered at origin for unioning with the base structure
    cylinder(h = boss_height, r = boss_diameter / 2, center = true);
}

module handle_hole() {
    // Cut a hole through the handle at x=143, y=0.
    // The handle is defined from Z=0 to Z=handle_thickness (4mm). We cut slightly deeper.
    translate([hole_x_position, 0, -1]) { // Extend slightly below Z=0 for clean cut
        cylinder(h = handle_thickness + 2, r = hole_diameter / 2);
    }
}

// --- Assembly ---

difference() {
    // 1. Base structure (Handle and Foot)
    union() {
        // Handle: Placed starting at X=0, resting on Z=0 plane.
        translate([handle_x_start, -handle_width/2, 0]) {
            handle();
        }

        // Foot: Rotated around the origin (where it meets the handle) and placed resting on Z=0 plane.
        translate([0, 0, 0]) {
            foot();
        }
    }

    // 2. Subtractions (Hole)
    union() {
        // A. Hole in the handle
        handle_hole();
    }
}

// 3. Boss addition (Placed on top of the structure, centered at origin)
translate([0, 0, boss_height / 2]) {
    boss();
}