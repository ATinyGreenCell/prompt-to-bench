// Dimensions for the sowing template
D_DISC = 85;        // Diameter of the main disc (mm)
T_DISC = 2;         // Thickness of the disc (mm)
D_HOLE = 3;         // Diameter of the grid holes (mm)
PITCH = 9;          // Center-to-center spacing of the grid (mm)
GRID_N = 7;         // Number of holes per row/column
NOTCH_W = 10;       // Width of the orientation notch (mm)
NOTCH_D = 4;        // Depth of the orientation notch (mm)

// Calculate grid bounds
// Grid is centered, so range is from -PITCH*(N-1)/2 to +PITCH*(N-1)/2
GRID_START = -PITCH * (GRID_N - 1) / 2;

module sowing_template() {
    // Main disc body
    cylinder(h = T_DISC, d = D_DISC, $fn = 64);

    // Create the grid of holes
    for (i = [0 : GRID_N - 1]) {
        for (j = [0 : GRID_N - 1]) {
            // Calculate center position for this hole
            x_pos = GRID_START + i * PITCH;
            y_pos = GRID_START + j * PITCH;
            
            // Create a hole by subtracting a cylinder
            // The hole cylinder must be slightly taller than the disc to ensure clean cut
            difference() {
                // The main disc (re-defined for the subtraction context)
                // We use a large cylinder to cut through the main body
                // Actually, we can just subtract from the main body in the union
                // But since we are building the final object, we do:
                // Union of disc and then subtract holes.
                // However, to keep it clean, we define the disc once and subtract holes from it.
                // Let's restructure: Base disc, then subtract holes.
                // Since we are inside a module, we can't easily re-define the base without union.
                // Better approach: Create the base, then subtract holes.
                // But the logic above was a loop. Let's do the subtraction properly.
                // We will subtract the holes from the main cylinder.
                // To do this cleanly, we define the main cylinder, then subtract the holes.
                // But we can't subtract inside a loop without a union of the base.
                // Correct approach:
                // 1. Create base cylinder.
                // 2. Create a list of hole cylinders.
                // 3. Subtract them.
                // Since we are in a module, we can do:
                // union() { cylinder(...); for(...) { translate(...) { cylinder(...) } } }
                // No, we need difference.
                // Let's do:
                // difference() {
                //    cylinder(...);
                //    for(...) { translate(...) { cylinder(...) } }
                // }
                // This works.
                // But wait, the notch also needs to be subtracted.
                // So:
                // difference() {
                //    base_disc;
                //    holes;
                //    notch;
                // }
                // Let's restructure the module to do this cleanly.
            }
        }
    }
}

// Re-writing the module to handle subtraction correctly
module sowing_template() {
    // Base disc
    base_disc = cylinder(h = T_DISC, d = D_DISC, $fn = 64);
    
    // Holes
    hole_cylinders = [];
    for (i = [0 : GRID_N - 1]) {
        for (j = [0 : GRID_N - 1]) {
            x_pos = GRID_START + i * PITCH;
            y_pos = GRID_START + j * PITCH;
            // Hole cylinder must extend past the disc to ensure clean cut
            hole_cylinders += [translate([x_pos, y_pos, -0.5]) {
                cylinder(h = T_DISC + 1, d = D_HOLE, $fn = 64)
            }];
        }
    }
    
    // Notch
    // Rectangular notch on +Y side, centered on Y axis (X=0)
    // Width 10mm (X), Depth 4mm (Y, from rim)
    // Rim is at Y = D_DISC/2 = 42.5
    // Notch extends from Y = 42.5 - 4 = 38.5 to Y = 42.5
    // X range: -5 to +5
    notch_cyl = translate([0, 42.5 - 2, 0]) { // Center Y at 40.5? No.
        // Notch is a rectangular prism cut.
        // Dimensions: X=10, Y=4, Z=2 (through thickness)
        // Position: X=0, Y=42.5 - 2 = 40.5 (center of notch in Y)
        // Wait, depth is 4mm measured in from rim.
        // Rim Y = 42.5. Notch Y range: 38.5 to 42.5. Center = 40.5.
        // X range: -5 to 5. Center = 0.
        // Z range: 0 to 2.
        cube([NOTCH_W, NOTCH_D, T_DISC], center = true);
    };

    // Combine
    difference() {
        base_disc;
        // Add all holes
        for (h = hole_cylinders) {
            h;
        }
        // Add notch
        notch_cyl;
    }
}

// Final assembly
sowing_template();