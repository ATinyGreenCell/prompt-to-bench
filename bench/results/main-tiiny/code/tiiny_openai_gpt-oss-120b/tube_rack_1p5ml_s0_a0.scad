// ---------- Parameters ----------
block_x = 106;          // block length (X) in mm
block_y = 72;           // block width  (Y) in mm
block_z = 30;           // block height (Z) in mm

hole_diameter = 11.2;   // tube hole diameter in mm
hole_depth = 25;        // depth of each hole in mm (from top down)
floor_thickness = 5;    // solid floor thickness below holes in mm

cols = 6;               // number of holes along X
rows = 4;               // number of holes along Y
spacing = 16;           // centre‑to‑centre spacing (mm) for both axes

// ---------- Helper variables ----------
hole_radius = hole_diameter/2;
cylinder_extra = 0.01;  // extra length to avoid coplanar faces
cyl_height = hole_depth + 2*cylinder_extra; // total height of cutting cylinder

// Grid extents (centered on origin)
grid_width  = (cols-1)*spacing;   // total span of hole columns
grid_height = (rows-1)*spacing;   // total span of hole rows
offset_x = -grid_width/2;          // X offset to centre grid on block
offset_y = -grid_height/2;         // Y offset to centre grid on block

// ---------- Model ----------
$fn = 64;   // smoothness for cylinders

// Base block (bottom at z=0, centered in X/Y)
module base_block() {
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);
}

// Single hole cylinder (cutting shape)
module hole_cylinder(pos) {
    // pos = [x, y] location of hole centre
    translate([pos[0], pos[1], floor_thickness - cylinder_extra])
        cylinder(r=hole_radius, h=cyl_height, center=false);
}

// All holes combined
module all_holes() {
    union() {
        for (i = [0 : cols-1])
            for (j = [0 : rows-1]) {
                x = offset_x + i*spacing;
                y = offset_y + j*spacing;
                hole_cylinder([x, y]);
            }
    }
}

// Final part: block with holes removed
difference() {
    base_block();
    all_holes();
}