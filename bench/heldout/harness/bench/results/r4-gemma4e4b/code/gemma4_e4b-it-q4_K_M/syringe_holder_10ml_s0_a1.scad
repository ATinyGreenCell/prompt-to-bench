// Wall-mounted syringe holder design

// --- Global Settings ---
$fn = 64; // High resolution for curves

// --- Dimensions (in mm) ---
holder_width = 50;      // Total width of the holder (X dimension)
holder_depth = 30;      // Total depth of the holder (Y dimension)
holder_height = 40;     // Total height of the holder (Z dimension)

barrel_diameter = 16;   // Syringe barrel diameter
barrel_channel_width = 16.5; // Width of the vertical channel
flange_thickness = 2;   // Thickness of the syringe finger flange (Not directly used in geometry, but kept for reference)
flange_width = 32;      // Width of the syringe finger flange

wall_screw_hole_diameter = 4.5; // Diameter for M4 wall screws
wall_screw_hole_z = 15;  // Z position for screw holes

// --- Derived/Internal Dimensions ---
half_barrel_radius = barrel_diameter / 2; // 8 mm
channel_back_radius = 8.25; // Radius of the half-circle at the back end of the channel (R=8.25)
flange_slot_width = 34;  // Width of the flange slot (X dimension)
flange_slot_height = 2.6; // Height of the flange slot (Z dimension)
flange_slot_start_z = 30; // Start Z for flange slot
flange_slot_end_z = 32.6; // End Z for flange slot

// --- Positioning Constants ---
// Holder is centered on origin in X and Y, rests on XY plane (Z=0).
// Back face is at y = holder_depth / 2 = 15. Front face is at y = -15.
holder_center_x = 0;
holder_center_y = 0;

// --- Main Body ---
module base_holder() {
    cube([holder_width, holder_depth, holder_height], center = true);
}

// --- Features to Cut (Subtractions) ---

// 1. Syringe Barrel Channel Cut
// The channel runs along the Y axis (depth). It has a rectangular body and a semi-circular back end at y=15.
module syringe_channel_cut() {
    difference() {
        // Start with an infinitely large volume to ensure the cut goes through everything, 
        // but since we are subtracting from the holder, we just define the shape to remove.
        union() {
            // A long rectangular prism covering the straight section of the channel (X=16.5, Z=40)
            cube([barrel_channel_width, holder_depth + 2, holder_height], center = true);

            // The curved back end piece: This is a half-cylinder centered at Y=15.
            // We translate it to align the cylinder's center with the required location (Y=15) and ensure it cuts through the body.
            translate([0, holder_depth/2 + channel_back_radius - 1, 0]) {
                rotate([90, 0, 0]) { // Rotate cylinder axis to align with Y direction
                    // Cylinder height must be large enough to cover the width (X) of the channel.
                    cylinder(h = barrel_channel_width + 2, r = channel_back_radius, center = true);
                }
            }
        }
    }
}

// 2. Flange Slot Cut (Cut from front face back)
module flange_slot() {
    difference() {
        // The volume to remove: A rectangular prism spanning X=34, Z=2.6, and Y=depth of cut.
        translate([0, -holder_depth/2 + 1, flange_slot_start_z]) { // Start slightly inside the front face (y=-15)
            cube([flange_slot_width, holder_depth + 2, flange_slot_height], center = true);
        }
    }
}

// 3. Wall Screw Holes
module screw_holes() {
    difference() {
        // The volume to remove: Two cylinders running through the depth of the holder.
        union() {
            // Hole at X = -19 mm
            translate([-19, 0, wall_screw_hole_z]) {
                cylinder(h = holder_depth + 2, r = wall_screw_hole_diameter / 2 + 0.01, center = true); // Extend slightly past faces
            }

            // Hole at X = 19 mm
            translate([19, 0, wall_screw_hole_z]) {
                cylinder(h = holder_depth + 2, r = wall_screw_hole_diameter / 2 + 0.01, center = true); // Extend slightly past faces
            }
        }
    }
}


// --- Final Assembly ---

difference() {
    // Start with the base holder block
    base_holder();

    // Subtract all required features
    syringe_channel_cut();
    flange_slot();
    screw_holes();
}