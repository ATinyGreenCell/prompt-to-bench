// DIY Magnetic Stirrer Housing - based on an 80mm PC fan.
// Orientation: Upside down. Top plate on bed (z=0), walls rise to z=40.
// Outer size: 90x90mm.

// Dimensions
outer_w = 90;
outer_h = 90;
top_t   = 2;
wall_t  = 2.5;
box_h   = 40; // Total height from bed to open top

// Fan mounting hole pattern
mounting_hole_d = 4.5;
mounting_pitch = 71.5;

// Cable notch
notch_w = 12;
notch_start_z = 32; // Bottom of notch
notch_end_z = 40;   // Top of notch (open edge)

$fn = 64;

// 1. Create the solid block (Outer box)
// We build the full 90x90x40 block first.
block = translate([0, 0, 0]) 
    cube([outer_w, outer_h, box_h]);

// 2. Cut the cable notch in one wall (let's say the front wall, facing +Y)
// The notch goes from z=32 to z=40, width 12mm, centred on the wall.
// Wall is at Y = outer_h/2. Notch is centred there.
notch_x_start = (outer_w - notch_w) / 2;
notch_x_end   = notch_x_start + notch_w;
notch_y       = outer_h / 2;

notch_cut = translate([notch_x_start, notch_y, notch_start_z]) 
    cube([notch_w, wall_t, notch_end_z - notch_start_z]);

// 3. Cut the four mounting holes through the top plate (z=0 to z=top_t)
// Pattern: 71.5mm square centred on origin.
// Coordinates: +/- (71.5/2) = +/- 35.75
hole_x = mounting_pitch / 2;
hole_y = mounting_pitch / 2;

hole_cut = translate([0, 0, 0]) 
    cylinder(h = top_t, d = mounting_hole_d);

// 4. Assemble the final part
difference() {
    union() {
        block;
        // Add the cable notch as a positive shape to be cut out? 
        // No, difference() subtracts. We need to subtract the notch from the block.
        // But we can't subtract inside the union easily without nesting.
        // Let's restructure: Start with block, subtract holes, subtract notch.
    }
    
    // Subtract mounting holes
    for (i = [-1, 1]) {
        for (j = [-1, 1]) {
            translate([i * hole_x, j * hole_y, 0]) {
                cylinder(h = top_t + 0.1, d = mounting_hole_d); // +0.1 to ensure clean cut
            }
        }
    }
    
    // Subtract cable notch
    translate([notch_x_start, notch_y, notch_start_z]) {
        cube([notch_w, wall_t + 0.1, notch_end_z - notch_start_z]);
    }
}