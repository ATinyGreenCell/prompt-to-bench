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
            
            // Note: The user specified x=0 to 150, y=-3 to 3, z=0 to 4.
            // To keep it centered on origin for easier modeling, 
            // I will use the user's coordinate logic but translate to Z=0.
            // Let's build it using the user's specific coordinate request:
            
            // Handle: x [0, 150], y [-3, 3], z [0, 4]
            // To make it sit at Z=0, we use the user's dimensions.
            // We'll use a union of the handle, the foot, and the boss.
            
            // Handle
            translate([handle_l / 2, 0, handle_t / 2])
                cube([handle_l, handle_w, handle_t], center = true);

            // 2. The Spreading Foot
            // Center line starts at origin, 120 deg from +X.
            // Foot length is 40, width 5, thickness 2.5.
            // We rotate the foot around the Z axis.
            // Since the foot is a bar, we create it centered and then rotate.
            rotate([0, 0, angle_deg])
            translate([foot_l / 2, 0, foot_t / 2])
                cube([foot_l, foot_w, foot_t], center = true);

            // 3. The Boss
            // 6mm diameter, 4mm tall at the origin.
            // To ensure it joins the bars, we place it at the origin.
            translate([0, 0, boss_h / 2])
                cylinder(d = boss_d, h = boss_h, center = true);
        }

        // 4. The Hanging Hole
        // 4mm diameter through the handle at x = 143, y = 0.
        // We extend the cylinder in Z to ensure a clean cut.
        translate([143, 0, -1])
            cylinder(d = hole_d, h = handle_t + 2, center = true);
    }
}

// Execute the module
// We translate the whole assembly so the bottom of the handle is at Z=0
// The user requested z=0 to 4 for the handle, so we don't need a global Z offset.
// However, the foot is z=0 to 2.5. To ensure the whole part sits on Z=0:
// We'll build the parts such that their minimum Z is 0.

module final_spreader() {
    difference() {
        union() {
            // Handle: x [0, 150], y [-3, 3], z [0, 4]
            translate([handle_l/2, 0, handle_t/2])
                cube([handle_l, handle_w, handle_t], center = true);
            
            // Foot: 40 long, 5 wide, 2.5 thick. 
            // Center line starts at origin, points 120 deg from +X.
            // We rotate the foot around the origin.
            rotate([0, 0, angle_deg])
            translate([foot_l/2, 0, foot_t/2])
                cube([foot_l, foot_w, foot_t], center = true);
            
            // Boss: 6 dia, 4 tall at origin.
            // To bridge the handle (z=0 to 4) and foot (z=0 to 2.5), 
            // we place the boss at the origin.
            translate([0, 0, boss_h/2])
                cylinder(d = boss_d, h = boss_h, center = true);
        }
        
        // Hole: x=143, y=0, through handle
        translate([143, 0, -1])
            cylinder(d = hole_d, h = handle_t + 2, center = true);
    }
}

final_spreader();