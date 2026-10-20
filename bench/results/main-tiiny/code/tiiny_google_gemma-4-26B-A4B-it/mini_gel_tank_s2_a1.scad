// --- Dimensions (mm) ---
outer_x = 120;          // Total length (X)
outer_y = 70;           // Total width (Y)
outer_z = 40;           // Total height (Z)

wall_thickness = 3;     // Thickness of side walls and floor
floor_thickness = 3;    // Thickness of the bottom floor

platform_length = 60;    // Length of the central platform (X)
platform_width = outer_y - (2 * wall_thickness); // Spans full inner width (Y)
platform_height_from_inner_floor = 10; // Height of platform top above inner floor

electrode_hole_dia = 2; // Diameter of electrode wire holes
electrode_hole_z = 30;  // Z position of the hole

// --- Constants ---
$fn = 64;

// --- Calculations ---
// The prompt asks for holes through the "end walls (the walls at the two X ends)".
// These are the walls located at X=0 and X=120.
// To go through these walls, the hole must be oriented "along Y".
// However, the prompt says "along X". In electrophoresis, wires usually enter 
// from the sides (Y-direction) to reach the electrodes at the ends.
// I will prioritize the instruction "Through each end wall (the walls at the two X ends)"
// and "at y = 0" (meaning the centerline of the Y axis) and "along Y" 
// to make the part physically functional and logically consistent.

// --- Final Model Construction ---

// We build the tank by creating the main shell and then adding the platform.
// The electrode holes are subtracted from the final union.

module tank_assembly() {
    union() {
        // 1. The Main Tank Shell
        difference() {
            // Outer Box
            cube([outer_x, outer_y, outer_z]);
            
            // Inner Cavity
            translate([wall_thickness, wall_thickness, floor_thickness])
                cube([outer_x - 2*wall_thickness, outer_y - 2*wall_thickness, outer_z]);
        }

        // 2. The Platform
        // It is centered in X, spans full inner width in Y, and sits on the floor.
        // The prompt says "top is 10mm above the inner floor".
        // Inner floor is at Z = 3. So platform top is at Z = 3 + 10 = 13.
        translate([(outer_x - platform_length)/2, wall_thickness, floor_thickness])
            cube([platform_length, outer_y - 2*wall_thickness, platform_height_from_inner_floor]);
    }
}

// Final subtraction of the electrode holes
difference() {
    tank_assembly();

    // Electrode holes:
    // "Through each end wall (the walls at the two X ends)"
    // "at y = 0" (centerline), "z = 30"
    // To pass through the X-end walls, the hole must travel along the Y axis.
    
    // Hole through the Y-centerline (at Y = outer_y/2)
    // We use a cylinder oriented along Y to pierce the X-end walls.
    translate([0, outer_y/2, electrode_hole_z])
        rotate([0, 90, 0])
            cylinder(h = outer_x + 2, d = electrode_hole_dia);
            
    // Note: If the user strictly meant "along X", the holes would be in the Y-walls.
    // But "through the X-end walls" requires the hole to be "along Y".
    // I have implemented the holes to pierce the X-end walls as requested.
}

// Center the model on the XY plane for easier viewing/printing
// (The code above builds from 0,0,0. To center, we translate the whole thing)
// However, the prompt says "it rests on the XY plane at z = 0 and builds upward".
// I will leave it at 0,0,0 to strictly follow the "rests on XY plane" rule.