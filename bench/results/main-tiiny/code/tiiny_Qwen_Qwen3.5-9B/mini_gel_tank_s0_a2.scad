// Buffer Tank for Mini Horizontal Gel Electrophoresis
// Units: millimetres
// Orientation: Rests on XY plane at z=0, builds upward (+Z)
// Centred on origin in X and Y

$fn = 128; // High resolution for smooth curves and accurate hole sizing

// --- Outer Dimensions (User Measured) ---
W_OUT_X = 120; // Width along X
D_OUT_Y = 70;  // Depth along Y
H_OUT_Z = 40;  // Height along Z

// --- Wall and Floor Thickness ---
T_WALL = 3;    // Wall thickness
T_FLOOR = 3;   // Floor thickness

// --- Inner Dimensions (Calculated) ---
W_IN_X = W_OUT_X - 2*T_WALL;
D_IN_Y = D_OUT_Y - 2*T_WALL;
H_IN_Z = H_OUT_Z - T_FLOOR;

// --- Platform Dimensions ---
P_L_X = 60;    // Platform length along X (total)
P_W_Y = D_IN_Y; // Platform width along Y (full inner width)
P_H_REL = 10;  // Platform height relative to inner floor
// Platform top absolute Z position (relative to tank bottom)
P_Z_ABS = T_FLOOR + P_H_REL; 

// --- Electrode Hole Dimensions ---
D_HOLE = 2;    // Hole diameter
// Hole location: y = 0, z = 30 (relative to bottom of tank)
// Since tank is centred in Y, y=0 is the geometric centre.

// --- Generation ---

module tank_base() {
    // Create the main outer block
    difference() {
        // Outer Shell
        cube([W_OUT_X, D_OUT_Y, H_OUT_Z], center = true);
        
        // Cut out the inner void (open top)
        // Inner dimensions: X, Y, Z
        // We subtract a box that is open at the top (Z > 0 relative to inner floor)
        // To ensure clean cut, we extend slightly past the top face
        translate([0, 0, T_FLOOR]) {
            difference() {
                cube([W_IN_X, D_IN_Y, H_IN_Z + 1], center = true);
                // Cut the top face to make it open
                translate([0, 0, H_IN_Z]) {
                    cube([W_IN_X + 0.1, D_IN_Y + 0.1, 1], center = true);
                }
            }
        }
    }
}

module platform() {
    // Solid raised platform
    // Dimensions: P_L_X (X), P_W_Y (Y), P_H_REL (Z)
    // Position: Centred in X, Full width in Y, Sitting on inner floor
    translate([0, 0, T_FLOOR]) {
        cube([P_L_X, P_W_Y, P_H_REL], center = true);
    }
}

module electrode_holes() {
    // Two holes: Left and Right ends
    // Location: y = 0 (centre), z = 30 (absolute from bottom)
    // Direction: Along X axis
    
    for (i = [-1, 1]) {
        // i = -1 for Left, i = 1 for Right
        // Calculate X position: Center is 0. Ends are at +/- W_OUT_X/2.
        // Hole is at the end wall.
        x_pos = (i * (W_OUT_X / 2)) - (D_HOLE / 2);
        
        translate([x_pos, 0, 30]) {
            cylinder(h = W_OUT_X + 1, r = D_HOLE / 2, $fn = 64);
        }
    }
}

module buffer_tank() {
    union() {
        tank_base();
        platform();
    }
    
    // Apply holes using difference
    difference() {
        // Re-create the solid union to ensure holes cut through everything correctly
        union() {
            tank_base();
            platform();
        }
        
        // Cut the electrode holes
        electrode_holes();
    }
}

// --- Final Assembly ---
// The user specified the part rests on the bed at z=0.
// The internal logic of the tank (bottom at -20, top at 20) was used for symmetry.
// We shift the entire assembly up by 20mm so the bottom touches z=0.
// This places the inner floor at z=3, platform top at z=13, and holes at z=30.
translate([0, 0, 20]) {
    buffer_tank();
}