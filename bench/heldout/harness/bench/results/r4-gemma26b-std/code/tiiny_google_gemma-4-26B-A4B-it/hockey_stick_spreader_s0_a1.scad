// --- Dimensions ---
handle_length = 150;      // Length of the handle bar (mm)
handle_width = 6;         // Width of the handle bar (mm)
handle_thickness = 4;     // Thickness of the handle bar (mm)

foot_length = 40;         // Length of the spreading foot (mm)
foot_width = 5;           // Width of the spreading foot (mm)
foot_thickness = 2.5;     // Thickness of the spreading foot (mm)

boss_diameter = 6;        // Diameter of the joining boss (mm)
boss_height = 4;          // Height of the joining boss (mm)

hole_diameter = 4;        // Diameter of the hanging hole (mm)
hole_x_pos = 143;         // X position of the hole center (mm)

angle_deg = 120;          // Angle of the foot relative to the handle (degrees)

// --- Constants ---
$fn = 64;

// --- Main Model ---
// The part is printed lying flat on the XY plane (Z=0 is the bottom).
// The handle is defined from X=0 to 150.
// The foot centerline starts at the origin and points 120 deg CCW from +X.

difference() {
    // The solid geometry
    union() {
        // 1. The Handle
        // Positioned so X goes from 0 to 150, Y is centered, Z goes from 0 to 4.
        translate([handle_length / 2, 0, handle_thickness / 2])
        cube([handle_length, handle_width, handle_thickness], center = true);

        // 2. The Spreading Foot
        // The centerline starts at the origin. 
        // To ensure it is joined to the handle at the origin, we rotate first.
        // We translate it so the start of the foot is at the origin.
        rotate([0, 0, angle_deg])
        translate([foot_length / 2, 0, foot_thickness / 2])
        cube([foot_length, foot_width, foot_thickness], center = true);

        // 3. The Boss
        // A round boss at the origin. To ensure it is part of the solid 
        // and sits on the bed, we place it at Z=0.
        translate([0, 0, boss_height / 2])
        cylinder(h = boss_height, d = boss_diameter, center = true);
    }

    // 4. The Hanging Hole
    // Through the handle at x = 143, y = 0.
    // We extend the cylinder slightly in Z to ensure a clean cut.
    translate([hole_x_pos, 0, -1])
    cylinder(h = handle_thickness + 2, d = hole_diameter, center = true);
}

// Note on Geometry:
// The user specified the foot centerline starts at the origin.
// The handle is x=0 to 150.
// The boss is at the origin.
// This creates a "hockey stick" shape where the handle and foot meet at the origin.
// To ensure the part is watertight and has no negative Z, we use center=true 
// and translate the center of the objects to their respective half-heights.