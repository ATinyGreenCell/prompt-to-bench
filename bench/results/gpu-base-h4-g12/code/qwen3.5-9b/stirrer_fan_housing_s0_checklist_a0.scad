// DIY Magnetic Stirrer Housing - based on an 80mm PC fan.
// Orientation: Top plate on bed (z=0), walls rising to z=40.
// Outer dimensions: 90 x 90 mm.

$fn = 64;

// Dimensions
outer_w = 90;
outer_h = 90;
top_thk = 2;
wall_thk = 2.5;
wall_h   = 40; // Total height from bed to open top
notch_w  = 12;
notch_d  = 8;  // Depth from open edge (z=32) down to z=24

// Fan mounting hole pattern
mounting_sq = 71.5;
mounting_hole = 4.5;

// Derived positions
half_outer = outer_w / 2;
half_mount = mounting_sq / 2;
z_open     = wall_h; // The open top is at z = 40

// Main body: Top plate + 4 walls
module housing_body() {
    // Start with the solid block including walls
    translate([0, 0, 0]) 
        cube([outer_w, outer_h, wall_h + 0.01]); // +0.01 to ensure solid union

    // Cut the internal cavity
    // Cavity starts at z = top_thk and goes up to z_open
    translate([0, 0, top_thk]) 
        cube([outer_w - 2*wall_thk, outer_h - 2*wall_thk, wall_h - top_thk + 0.01]);
}

// Screw holes in the top plate
module screw_holes() {
    for (i = [0 : 3]) {
        // Calculate X and Y positions for the 4 corners of the 71.5mm square
        // Pattern is centred on the 90mm plate
        x_pos = (i < 2) ? (-half_mount) : (half_mount);
        y_pos = (i < 1) ? (-half_mount) : (half_mount);
        
        translate([x_pos, y_pos, 0]) {
            // Cut through the top plate only (z=0 to z=top_thk)
            translate([0, 0, -1]) 
                cylinder(h = top_thk + 1, d = mounting_hole);
        }
    }
}

// Cable notch in one wall (let's say the front wall, facing +Y)
// Notch is 12mm wide, centred along the wall, 8mm deep from the open edge (z=40)
module cable_notch() {
    // Position: Centred on the wall (x=0), at the top edge (y = half_outer - wall_thk/2)
    // Actually, the wall is at y = half_outer - wall_thk/2 to y = half_outer + wall_thk/2?
    // No, the outer box is 90x90. The wall is on the perimeter.
    // Let's assume the notch is on the wall at y = half_outer - wall_thk/2 (front face)
    // Wait, if the box is 90x90, the walls are at x=+-45 and y=+-45.
    // Let's put the notch on the wall at y = 45 - 1.25 = 43.75?
    // No, the wall thickness is 2.5. The inner face is at 43.75, outer at 46.25.
    // The notch should be on the inner face or outer face? Usually inner for cable access.
    // Let's cut it from the outer face inwards? Or just cut a slot in the wall volume.
    // "reaching 8 mm down from the open edge". Open edge is at z=40.
    // So notch goes from z=40 down to z=32.
    
    // Position: x=0, y = half_outer - wall_thk/2 (inner face of front wall)
    // Actually, let's just define the wall location clearly.
    // Wall is between y = 43.75 and y = 46.25.
    // Notch is in the wall. Let's center it on the inner face (y=43.75) for easy wiring.
    
    translate([0, half_outer - wall_thk/2, 0]) {
        // Cut a rectangular prism
        // Width: 12mm
        // Height (Z): 8mm (from z=32 to z=40)
        // Depth (Y): wall_thk (to cut through the whole wall)
        translate([0, 0, 32]) 
            cube([notch_w, wall_thk, notch_d + 0.01]);
    }
}

// Combine everything
difference() {
    union() {
        housing_body();
        // Add the screw holes as negative space in the top plate
        // We can't easily do "add holes" in a union, so we do the holes in the main difference block
    }
    
    // 1. Screw holes
    screw_holes();
    
    // 2. Cable notch
    cable_notch();
}