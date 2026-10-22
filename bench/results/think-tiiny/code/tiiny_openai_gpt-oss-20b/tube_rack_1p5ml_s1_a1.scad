// Bench rack for 1.5 mL microcentrifuge tubes

// Block dimensions (mm)
block_length = 106; // X
block_width  = 72;  // Y
block_height = 30;  // Z

// Hole parameters (mm)
hole_diameter = 11.2; // diameter
hole_depth    = 25;   // depth from top
hole_radius   = hole_diameter / 2;

// Grid parameters (mm)
cols   = 6; // holes along X
rows   = 4; // holes along Y
spacing = 16; // centre‑to‑centre spacing

// Small offset to avoid coplanar faces
extra = 0.01; // mm

// Resolution for curved surfaces
$fn = 64;

// Main model – block rests on XY plane at z = 0
translate([0,0,15]) difference() {
    // Solid block
    cube([block_length, block_width, block_height], center = true);

    // Holes – positioned so that they open at the top of the block
    for (i = [0:cols-1]) {
        for (j = [0:rows-1]) {
            x = - ((cols-1)*spacing)/2 + i*spacing;
            y = - ((rows-1)*spacing)/2 + j*spacing;
            // In the block‑centered coordinate system, the bottom of a hole
            // must be at z = -10 so that the global bottom is at z = 0
            translate([x, y, -10]) {
                cylinder(h = hole_depth + extra, r = hole_radius, center = false);
            }
        }
    }
}