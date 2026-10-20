// Pestle for 1.5 mL microcentrifuge tube
// Fixed version: Corrected groove geometry and part continuity

// --- Dimensions ---
handle_diameter = 8;          // Diameter of the cylindrical handle
handle_height = 45;           // Height of the handle from z=0
cone_base_diameter = 8;       // Diameter at the start of the taper
cone_tip_diameter = 3;        // Diameter at the end of the taper
cone_height = 62 - 45;        // Vertical height of the conical section
tip_diameter = 3;             // Diameter of the spherical tip
tip_center_z = 62;            // Z-coordinate of the sphere center

groove_width = 2;             // Width of each groove in Z
groove_depth = 1;             // Depth of each groove into the handle
groove_z_positions = [10, 15, 20, 25]; // Z-centers for the four grooves

// --- Resolution ---
$fn = 64;

// --- Main Construction ---
// The previous version used a cylinder to cut the grooves, which 
// effectively cut a hole through the center of the handle.
// To create circumferential grooves (rings), we must subtract 
// a larger cylinder from the handle, but only within the 
// specific Z-range of the groove.

module pestle() {
    difference() {
        // 1. The Main Body (Handle + Cone + Tip)
        union() {
            // Handle
            cylinder(d = handle_diameter, h = handle_height);
            
            // Cone (Tapered section)
            translate([0, 0, handle_height])
                cylinder_taper(d1 = cone_base_diameter, d2 = cone_tip_diameter, h = cone_height);
            
            // Rounded Tip (Sphere)
            translate([0, 0, tip_center_z])
                sphere(d = tip_diameter);
        }

        // 2. The Grooves (Subtracted as rings)
        // To make a groove 1mm deep, the cutting cylinder must have 
        // a diameter of (handle_diameter - 2 * groove_depth).
        // However, to ensure a clean cut through the outer surface, 
        // we use a cylinder with diameter = handle_diameter and 
        // subtract it from the handle. 
        // Wait, the requirement is "1mm deep". 
        // If handle is 8mm, the groove should be a ring with outer diameter 8mm 
        // and inner diameter 6mm.
        
        for (z_pos = groove_z_positions) {
            // We create a ring by subtracting a smaller cylinder from a larger one
            // Or more simply: subtract a cylinder that is slightly larger than the handle
            // but we only want to cut the "sides".
            // Correct approach: Subtract a cylinder that is larger than the handle 
            // but only at the specific Z-height.
            
            translate([0, 0, z_pos - groove_width/2 - 0.1])
                cylinder(d = handle_diameter + 2, h = groove_width + 0.2);
            
            // To make it a "groove" (a ring) rather than a hole, 
            // we must NOT subtract the center. 
            // We subtract a "hollow" cylinder (a washer shape).
            // But the easiest way is to subtract a cylinder that is 
            // larger than the handle, but then we'd have a hole.
            // The correct way to make a groove is to subtract a cylinder 
            // that is larger than the handle, but we only want to remove 
            // the material between (handle_diameter - 2*depth) and handle_diameter.
            
            // Let's use a torus-like subtraction or a hollow cylinder:
            // We subtract a cylinder with diameter (handle_diameter + 2) 
            // but we must "add back" the center. 
            // Actually, the simplest way: subtract a cylinder of diameter 
            // (handle_diameter + 2) and then union a cylinder of diameter 
            // (handle_diameter - 2*groove_depth) back in.
            
            // However, the standard way to model a groove in OpenSCAD is:
            // difference() { handle; cylinder_for_groove; }
            // To make it a groove and not a hole, the cylinder must be 
            // wider than the handle but we only want to cut the perimeter.
            // Let's use a torus (rotate_extrude) for a perfect circumferential groove.
        }
    }
}

// Re-writing the logic to ensure grooves are rings, not holes.
module final_pestle() {
    difference() {
        // The solid part
        union() {
            cylinder(d = handle_diameter, h = handle_height);
            translate([0, 0, handle_height])
                cylinder_taper(d1 = cone_base_diameter, d2 = cone_tip_diameter, h = cone_height);
            translate([0, 0, tip_center_z])
                sphere(d = tip_diameter);
        }

        // The grooves (Subtracted as rings)
        for (z_pos = groove_z_positions) {
            translate([0, 0, z_pos])
                rotate_extrude($fn=64)
                    translate([handle_diameter/2 - groove_depth + 0.01, 0, 0])
                        // We use a small offset to ensure the cut is clean
                        // We use a square to define the cross-section of the groove
                        // The square is groove_width high and groove_depth wide.
                        // To make it a "groove" on the surface, we center it on the radius.
                        // But the user said "2mm wide (in Z)".
                        // So the square is: x from (handle_diameter/2 - groove_depth) to (handle_diameter/2)
                        // z from (-groove_width/2) to (groove_width/2)
                        square([groove_depth + 0.1, groove_width + 0.1]);
        }
    }
}

// Helper module for the tapered cone
module cylinder_taper(d1, d2, h) {
    hull() {
        translate([0, 0, -0.01])
            cylinder(d = d1, h = 0.02);
        translate([0, 0, h])
            cylinder(d = d2, h = 0.02);
    }
}

// Execute the model
final_pestle();