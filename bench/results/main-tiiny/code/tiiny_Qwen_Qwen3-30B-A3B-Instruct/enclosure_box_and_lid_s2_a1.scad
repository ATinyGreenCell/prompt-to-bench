// Dimensions for the enclosure parts
$fn = 64;

// Part 1: Box (main enclosure)
box_width = 70;        // X
box_depth = 50;        // Y
box_height = 30;       // Z
wall_thickness = 2;      // Wall and floor thickness
floor_thickness = 2;

// Part 2: Lid (printed upside down)
lid_width = 70;      // X
lid_depth = 50;       // Y
lid_thickness = 2;     // Thickness of the lid plate
lip_thickness = 1.5;    // Wall thickness of the lip
lip_height = 4;      // Height of the lip wall
lip_outer_width = 65.6;  // Outer width of lip (must match box inner size with clearance)
lip_outer_depth = 45.6;   // Outer depth of lip

// Spacing between parts
gap = 10;

// Centering the parts on the X axis for both
box_x = -box_width / 2;
box_y = -box_depth / 2;
lid_x = box_x + box_width + gap;
lid_y = -lid_depth / 2;

// --- Box (Part 1) ---
// Outer box dimensions
outer_box = [box_width, box_depth, box_height];

// Inner cavity (to subtract from outer box)
inner_width = box_width - 2 * wall_thickness;
inner_depth = box_depth - 2 * wall_thickness;
inner_height = box_height - floor_thickness;

// Create the box: start with outer cube, subtract inner cavity
difference() {
    // Outer box (with floor)
    cube(outer_box, center = false);
    
    // Inner cavity (with floor removed from top)
    translate([wall_thickness, wall_thickness, 0]) {
        cube([inner_width, inner_depth, box_height - floor_thickness], center = false);
    }
}

// --- Lid (Part 2) ---
// Lid is printed upside down, so we build it with the lip on top
// First, create the flat lid plate
translate([lid_x, lid_y, 0]) {
    // Lid plate (on the bed)
    cube([lid_width, lid_depth, lid_thickness], center = false);
    
    // Lip: a rectangular wall around the inside of the lid
    // Outer lip size: 65.6 x 45.6 mm, centered on lid
    lip_x_offset = (lid_width - lip_outer_width) / 2;
    lip_y_offset = (lid_depth - lip_outer_depth) / 2;
    
    // Create the lip wall (extruded from a rectangle)
    translate([lid_x + lip_x_offset, lid_y + lip_y_offset, lid_thickness]) {
        // Outer rectangle for lip (to cut from)
        difference() {
            // Outer rectangle (larger than inner to allow for clearance)
            cube([lip_outer_width, lip_outer_depth, lip_height], center = false);
            
            // Inner rectangle (to subtract: creates the lip cavity)
            // Must be 0.2 mm smaller on each side to give 0.2 mm clearance
            // So inner = outer - 0.4 mm total (0.2 per side)
            inner_lip_width = lip_outer_width - 0.4;
            inner_lip_depth = lip_outer_depth - 0.4;
            
            translate([lip_thickness, lip_thickness, 0]) {
                cube([inner_lip_width, inner_lip_depth, lip_height], center = false);
            }
        }
    }
}