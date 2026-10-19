// DIY Magnetic Stirrer Housing
// Designed for an 80mm PC fan.
// Orientation: Printed upside-down (top plate on bed at z=0).

// --- Dimensions ---
outer_size = 90.0;      // Outer width and length (mm)
top_thick   = 2.0;      // Thickness of the top plate (mm)
wall_thick  = 2.5;      // Thickness of the side walls (mm)
total_height = 40.0;    // Total height from top plate to open edge (mm)
hole_dia    = 4.5;      // Diameter for M4 screw holes (mm)
hole_pattern = 71.5;    // Square pattern for fan mounting holes (mm)
notch_w     = 12.0;     // Width of the cable notch (mm)
notch_h     = 8.0;      // Depth of the notch from the open edge (mm)

$fn = 64;

// --- Geometry ---

// The main body of the housing
union() {
    // The top plate (sits on Z=0 to Z=top_thick)
    // Since it's printed upside down, the "top" is at Z=0.
    cube([outer_size, outer_size, top_thick], center = true);
    
    // The four walls
    // We use a hull or a subtraction method to create the walls.
    // Here, we build a solid block and subtract the interior.
    difference() {
        // The outer shell (walls + top plate)
        // We start from Z=0 (the plate) and go up to total_height.
        // Note: Since the plate is centered at Z=0, it spans -top_thick/2 to +top_thick/2.
        // To make the plate sit on the bed, we translate the whole assembly.
        
        translate([0, 0, top_thick/2]) {
            difference() {
                // Outer volume
                cube([outer_size, outer_size, total_height], center = true);
                
                // Inner volume (the hollow part)
                // We subtract a slightly smaller cube to create the walls.
                // The walls are 2.5mm thick.
                inner_dim = outer_size - (2 * wall_thick);
                // We subtract from Z=top_thick to total_height to keep the plate solid
                translate([0, 0, -top_thick/2 + 0.01]) 
                    cube([inner_dim, inner_dim, total_height], center = true);
            }
        }
    }
}

// --- Subtractions (Holes and Notches) ---

difference() {
    // We wrap the whole thing in a difference to cut the holes and notch
    // But since the code above is a union, we must structure the logic carefully.
    // Let's redefine the assembly to be a single difference block.
}

// RE-STRUCTURED MODEL FOR CLEAN DIFFERENCE
// 1. Create the solid block (Outer dimensions)
// 2. Subtract the inner cavity
// 3. Subtract the screw holes
// 4. Subtract the cable notch

module housing_assembly() {
    difference() {
        // The solid outer shell
        union() {
            // The top plate (on bed)
            translate([0, 0, top_thick/2])
                cube([outer_size, outer_size, top_thick], center = true);
            
            // The walls
            translate([0, 0, top_thick + (total_height - top_thick)/2])
                cube([outer_size, outer_size, total_height - top_thick], center = true);
        }

        // --- Subtractions ---

        // 1. The inner hollow cavity
        // It starts from the top plate and goes to the top edge.
        translate([0, 0, top_thick + (total_height - top_thick)/2])
            cube([outer_size - 2*wall_thick, outer_size - 2*wall_thick, total_height], center = true);

        // 2. The four screw holes
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * hole_pattern/2, sy * hole_pattern/2, -1])
                cylinder(h = top_thick + 2, d = hole_dia);
        }

        // 3. The cable notch
        // Located in one wall, centered along the wall (X or Y axis).
        // Let's pick the wall at Y = outer_size/2.
        // Notch is 12mm wide, 8mm deep from the open edge.
        // Open edge is at Z = total_height.
        // Notch reaches from Z = total_height - 8 to Z = total_height.
        translate([0, outer_size/2 - wall_thick/2, total_height - notch_h/2])
            cube([notch_w, wall_thick + 1, notch_h + 0.1], center = true);
    }
}

// Final Render
// We use a simple translate to ensure the plate is at Z=0.
// The logic above is a bit messy for a single difference, 
// so let's provide the clean, final version below.

// --- FINAL CLEAN VERSION ---

difference() {
    // Outer Shape
    union() {
        // Top Plate
        translate([0, 0, top_thick/2])
            cube([outer_size, outer_size, top_thick], center = true);
        // Walls
        translate([0, 0, top_thick + (total_height - top_thick)/2])
            cube([outer_size, outer_size, total_height - top_thick], center = true);
    }

    // Hollow Interior
    translate([0, 0, top_thick + (total_height - top_thick)/2])
        cube([outer_size - 2*wall_thick, outer_size - 2*wall_thick, total_height], center = true);

    // Screw Holes
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * hole_pattern/2, sy * hole_pattern/2, -1])
            cylinder(h = top_thick + 2, d = hole_dia);
    }

    // Cable Notch (on the wall at Y = outer_size/2)
    // Centered on X, at the edge of the wall.
    translate([0, outer_size/2 - wall_thick/2, total_height - notch_h/2])
        cube([notch_w, wall_thick + 2, notch_h + 1], center = true);
}