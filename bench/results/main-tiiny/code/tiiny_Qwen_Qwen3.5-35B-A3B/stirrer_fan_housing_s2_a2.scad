// Dimensions for DIY Magnetic Stirrer Housing (80mm PC Fan)
// Units: millimetres

// Overall outer dimensions
outer_width = 90;
outer_height = 90;
box_height = 40;

// Wall and top plate thicknesses
wall_thickness = 2.5;
top_thickness = 2;

// Screw hole pattern
screw_hole_dia = 4.5;
screw_pattern_size = 71.5;

// Cable notch dimensions
notch_width = 12;
notch_depth = 8; // From top edge (z=40) down

// Print orientation: Top plate on bed (z=0 to 2), walls rise to z=40
// Centered on origin (X, Y)

// Calculate inner dimensions (for reference)
inner_width = outer_width - 2 * wall_thickness;
inner_height = outer_height - 2 * wall_thickness;

// Calculate screw hole positions (centered on 71.5mm square)
screw_offset = screw_pattern_size / 2;

// Define the main box structure
module stirrer_housing() {
    // Base plate (top of the physical part, on the bed)
    // 90x90x2mm, centered at origin, z=0 to z=2
    cube([outer_width, outer_height, top_thickness], center = true);

    // Four walls rising from the base
    // Wall thickness is 2.5mm, height is 38mm (from z=2 to z=40)
    // Walls are centered at origin, so they extend from -45 to +45 in X/Y
    
    // Front wall (Y negative side)
    // Centered at (0, -45, 21) -> Y range: -45 - 1.25 to -45 + 1.25? No.
    // Wall is 2.5 thick. Centered at Y = -45 + 1.25 = -43.75?
    // Let's use translate to position the center of the wall.
    // Wall Y center = -outer_height/2 + wall_thickness/2 = -45 + 1.25 = -43.75
    translate([0, -outer_height/2 + wall_thickness/2, 2])
        cube([outer_width, wall_thickness, box_height - top_thickness], center = true);
        
    // Back wall (Y positive side)
    // Center Y = 45 - 1.25 = 43.75
    translate([0, outer_height/2 - wall_thickness/2, 2])
        cube([outer_width, wall_thickness, box_height - top_thickness], center = true);
        
    // Left wall (X negative side)
    // Center X = -45 + 1.25 = -43.75
    translate([-outer_width/2 + wall_thickness/2, 0, 2])
        cube([wall_thickness, outer_height, box_height - top_thickness], center = true);
        
    // Right wall (X positive side)
    // Center X = 45 - 1.25 = 43.75
    translate([outer_width/2 - wall_thickness/2, 0, 2])
        cube([wall_thickness, outer_height, box_height - top_thickness], center = true);
}

// Define the screw holes
module screw_holes() {
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * screw_offset, y * screw_offset, 0])
                cylinder(h = box_height, d = screw_hole_dia, $fn = 64);
        }
    }
}

// Define the cable notch
module cable_notch() {
    // Notch is in one wall. Let's pick the front wall (Y negative side).
    // It is centered along the wall (X=0).
    // It reaches 8mm down from the open edge (z=40). So z goes from 32 to 40.
    // Width is 12mm.
    // We need to cut this out of the wall.
    // The wall is at Y = -45 (outer edge).
    // We create a cutter that extends slightly past the wall thickness to ensure clean cut.
    
    // Cutter dimensions:
    // X: -6 to +6 (width 12)
    // Y: -45 - 1 (to cut through the wall) to -45 + 1 (to cut through)
    // Z: 32 to 40 (plus a bit to ensure cut)
    
    translate([0, -outer_height/2 - 1, 32])
        cube([notch_width + 0.02, 2, notch_depth + 0.02], center = false);
}

// Main assembly
union() {
    // Create the solid box
    stirrer_housing();
    
    // Cut the screw holes
    difference() {
        stirrer_housing();
        screw_holes();
    }
    
    // Cut the cable notch
    difference() {
        stirrer_housing();
        cable_notch();
    }
}