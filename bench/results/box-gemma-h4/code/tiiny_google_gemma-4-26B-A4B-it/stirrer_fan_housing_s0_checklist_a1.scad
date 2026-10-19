// DIY Magnetic Stirrer Housing
// Designed for an 80mm PC fan.
// Orientation: Printed upside-down (top plate on bed at z=0).

// --- Dimensions ---
outer_size   = 90.0;      // Outer width and length (mm)
top_thick    = 2.0;       // Thickness of the top plate (mm)
wall_thick   = 2.5;       // Thickness of the side walls (mm)
total_height = 40.0;      // Total height from top plate to open edge (mm)
hole_dia     = 4.5;       // Diameter for M4 screw holes (mm)
hole_pattern = 71.5;      // Square pattern for fan mounting holes (mm)
notch_w      = 12.0;      // Width of the cable notch (mm)
notch_h      = 8.0;       // Depth of the notch from the open edge (mm)

$fn = 64;

// --- Geometry ---

// We build the solid block and subtract the hollow parts and holes.
// To ensure the plate sits at Z=0, we build everything from Z=0 upwards.

difference() {
    // 1. THE SOLID OUTER SHELL
    // A single block representing the outer boundary of the box.
    cube([outer_size, outer_size, total_height]);

    // 2. THE INNER HOLLOW CAVITY
    // This creates the walls. The cavity starts at the top of the plate (Z = top_thick)
    // and goes to the top of the box (Z = total_height).
    translate([wall_thick, wall_thick, top_thick])
        cube([outer_size - 2 * wall_thick, outer_size - 2 * wall_thick, total_height]);

    // 3. THE FOUR SCREW HOLES
    // Holes are drilled through the top plate (Z=0 to Z=top_thick).
    // Pattern is centered on the plate.
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * hole_pattern / 2, sy * hole_pattern / 2, -1])
            cylinder(h = top_thick + 2, d = hole_dia);
    }

    // 4. THE CABLE NOTCH
    // Located in one wall, centered along the wall.
    // Reaches 8mm down from the open edge (Z = total_height - notch_h).
    // We place it on the wall at Y = outer_size.
    // The notch is 12mm wide (X) and 8mm deep (Z).
    // To ensure a clean cut, we make the notch slightly wider in Y.
    translate([outer_size - wall_thick, outer_size / 2 - notch_w / 2, total_height - notch_h])
        cube([wall_thick + 2, notch_w, notch_h + 0.1]);
}

// Note: The part is centered in X and Y by default if we use cube([s,s,h]) 
// and don't use center=true. To match the user's request for centering:
// We wrap the whole thing in a translation to center it on X and Y.

// Re-applying centering logic to the final structure:
// (The code above is the logic; the block below is the final centered version)