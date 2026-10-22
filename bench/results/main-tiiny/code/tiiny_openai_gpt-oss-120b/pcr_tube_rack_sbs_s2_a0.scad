// --------------- Parameters ----------------
// Block dimensions (mm)
block_length = 127.76;   // X dimension
block_width  = 85.48;    // Y dimension
block_height = 20;       // Z dimension

// Hole pattern
hole_diameter = 6.2;     // mm
hole_radius   = hole_diameter/2;
hole_spacing  = 9.0;     // mm centre‑to‑centre
cols = 12;               // number of columns (X direction)
rows = 8;                // number of rows (Y direction)

// Offsets of the first hole (A1) from the left and back edges
offset_x_from_left = 14.38;   // mm
offset_y_from_back = 11.24;   // mm

// Chamfer (orientation mark) at the left‑back corner
chamfer_leg = 5.0;           // mm, length of the 45° legs
chamfer_extra = 0.01;        // mm, extend beyond the block faces

// Cutting tolerances
cut_extra = 0.1;              // mm, extra length of cylinders beyond block faces

// Rendering quality
$fn = 64;

// ----------------- Model -------------------
module rack() {
    // Main block (centered on origin)
    block = cube([block_length, block_width, block_height], center = true);
    
    // Holes (through‑cylinders)
    module holes() {
        // Edge positions of the block (for reference)
        left_edge  = -block_length/2;
        back_edge  = -block_width/2;
        
        // First hole centre coordinates
        first_x = left_edge + offset_x_from_left;
        first_y = back_edge + offset_y_from_back;
        
        for (i = [0:cols-1], j = [0:rows-1]) {
            translate([ first_x + i*hole_spacing,
                        first_y + j*hole_spacing,
                        -cut_extra ])
                cylinder(h = block_height + 2*cut_extra,
                         r = hole_radius,
                         center = false);
        }
    }
    
    // Chamfer cut (45° triangular prism)
    module chamfer_cut() {
        // Corner coordinates (left‑back)
        corner_x = -block_length/2;
        corner_y = -block_width/2;
        
        // 2‑D right triangle (right‑angle at corner)
        triangle = polygon(points = [
            [0,0],
            [chamfer_leg,0],
            [0,chamfer_leg]
        ]);
        
        // Extrude to height + a little extra, then translate to corner
        linear_extrude(height = block_height + 2*cut_extra)
            translate([corner_x - chamfer_extra,
                       corner_y - chamfer_extra,
                       -cut_extra])
                triangle;
    }
    
    // Subtract