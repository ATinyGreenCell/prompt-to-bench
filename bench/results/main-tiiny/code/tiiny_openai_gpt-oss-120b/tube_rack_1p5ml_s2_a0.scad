// Parameters (all in mm)
block_length   = 106;   // X dimension of the rack block
block_width    = 72;    // Y dimension of the rack block
block_height   = 30;    // Z dimension (height) of the rack block
hole_diameter  = 11.2;  // Diameter of each tube hole
hole_depth     = 25;    // Depth of each hole (leaving a 5 mm floor)
hole_spacing   = 16;    // Centre‑to‑centre spacing of holes in X and Y
cols           = 6;     // Number of hole columns (along X)
rows           = 4;    // Number of hole rows (along Y)
floor_thickness = block_height - hole_depth; // thickness of solid floor (5 mm)

// $fn for smooth circles/cylinders
$fn = 64;

// Main solid (block) centered on origin in X/Y, bottom at Z=0
module rack_block() {
    translate([-block_length/2, -block_width/2, 0])
        cube([block_length, block_width, block_height]);
}

// Hole cutter (cylinder) positioned to cut through the block
module hole_cutter() {
    // Extend 0.01 mm beyond the top and bottom faces of the block
    extra = 0.01;
    // Height of cutter = hole_depth + 2*extra
    cutter_h = hole_depth + 2*extra;
    // Bottom of cutter = floor_thickness - extra
    translate([0, 0, floor_thickness - extra])
        cylinder(h = cutter_h, r = hole_diameter/2);
}

// Assemble the rack with holes
difference() {
    rack_block();

    // Grid of holes
    for (i = [0 : cols-1], j = [0 : rows-1]) {
        // Compute X and Y positions (centered on the block)
        x_pos = -((cols-1)*hole_spacing)/2 + i*hole_spacing;
        y_pos = -((rows-1)*hole_spacing)/2 + j*hole_spacing;
        translate([x_pos, y_pos, 0])
            hole_cutter();
    }
}