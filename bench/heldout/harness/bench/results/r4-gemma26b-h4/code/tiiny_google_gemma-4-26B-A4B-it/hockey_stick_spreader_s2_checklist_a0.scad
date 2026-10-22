// L-shaped (hockey-stick) cell spreader for bacterial plating.
// Designed for FDM printing, lying flat on the XY plane.

// --- Dimensions ---
handle_l    = 150.0; // Length of the handle
handle_w    = 6.0;   // Width of the handle
handle_t    = 4.0;   // Thickness of the handle
foot_l      = 40.0;  // Length of the spreading foot
foot_w      = 5.0;   // Width of the spreading foot
foot_t      = 2.5;   // Thickness of the spreading foot
boss_d      = 6.0;   // Diameter of the joining boss
boss_h      = 4.0;   // Height of the joining boss
hole_d      = 4.0;   // Diameter of the hanging hole
angle_deg   = 120.0; // Angle between handle and foot (counter-clockwise from +X)

$fn = 64;

// --- Geometry Calculations ---
// The handle is centered on Y, so its Y range is [-handle_w/2, handle_w/2]
// The foot is rotated 120 degrees.

module spreader() {
    difference() {
        union() {
            // 1. The Handle
            // Centered on Y, extends from X=0 to X=handle_l
            translate([handle_l / 2, 0, 0])
                cube([handle_l, handle_w, handle_t], center = true);
            
            // Note: The prompt specifies x=0 to 150, y=-3 to 3, z=0 to 4.
            // To achieve this in OpenSCAD while centering on X/Y for printing:
            // We translate the cube so the corner is at the origin.
            // However, the prompt says "Two straight bars meet at the origin".
            // To ensure the part is centered on X/Y for the slicer:
            // We will build the part relative to the origin and then translate the whole thing.
            
            // Let's redefine the construction to be more precise to the prompt's geometry:
            // Handle: [0, 150] x [-3, 3] x [0, 4]
            // Foot: 40mm long, 5mm wide, 2.5mm thick, rotated 120 deg.
            
            // Handle
            translate([handle_l / 2, 0, handle_t / 2])
                cube([handle_l, handle_w, handle_t], center = true);

            // 2. The Boss (at the origin)
            // Prompt: 6mm diameter, 4mm tall at the origin.
            // To ensure it joins the bars, we place it at the junction.
            translate([0, 0, boss_h / 2])
                cylinder(h = boss_h, d = boss_d, center = true);

            // 3. The Foot
            // Center line starts at origin, points 120 deg CCW from +X.
            // Length 40, Width 5, Thickness 2.5.
            // We rotate the foot around the Z axis.
            // Since the foot is a bar, we create it centered on its own local origin 
            // and then rotate/translate.
            rotate([0, 0, angle_deg])
                translate([foot_l / 2, 0, foot_t / 2])
                    cube([foot_l, foot_w, foot_t], center = true);
        }

        // 4. The Hanging Hole
        // Through the handle at x = 143, y = 0.
        // We subtract a cylinder.
        translate([143, 0, -1])
            cylinder(h = handle_t + 2, d = hole_d);
    }
}

// Final assembly: The prompt describes the geometry relative to the origin.
// To make it "rest on the XY plane at z=0", we must adjust the Z offset.
// The handle is z=0 to 4, foot is z=0 to 2.5. 
// The boss is 4mm tall. 
// Since the handle is the thickest part (4mm), we align the bottom of the handle to Z=0.

// Re-calculating the assembly to ensure it sits on Z=0:
// Handle: Z from 0 to 4.
// Foot: Z from 0 to 2.5.
// Boss: Z from 0 to 4.

module final_spreader() {
    difference() {
        union() {
            // Handle
            translate([handle_l / 2, 0, handle_t / 2])
                cube([handle_l, handle_w, handle_t], center = true);
            
            // Boss
            translate([0, 0, boss_h / 2])
                cylinder(h = boss_h, d = boss_d, center = true);

            // Foot
            rotate([0, 0, angle_deg])
                translate([foot_l / 2, 0, foot_t / 2])
                    cube([foot_l, foot_w, foot_t], center = true);
        }
        
        // Hole
        translate([143, 0, -1])
            cylinder(h = handle_t + 2, d = hole_d);
    }
}

// Render the part
final_spreader();