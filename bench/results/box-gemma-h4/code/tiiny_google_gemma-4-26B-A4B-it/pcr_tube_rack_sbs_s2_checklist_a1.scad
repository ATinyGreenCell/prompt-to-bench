// 96-well PCR tube rack (0.2 mL)
// Corrected to respect specific A1 hole positioning and proper chamfer.

// --- Dimensions ---
L = 127.76;          // Length (X)
W = 85.48;           // Width (Y)
H = 20.0;            // Height (Z)
hole_d = 6.2;        // Diameter of PCR tube holes
rows = 8;            // Number of rows (Y)
cols = 12;           // Number of columns (X)
spacing = 9.0;       // Center-to-center spacing
inset_x = 14.38;     // Distance from left edge to first hole center (A1)
inset_y = 11.24;     // Distance from back edge to first hole center (A1)
chamfer_leg = 5.0;   // Length of the 45-degree chamfer legs

$fn = 64;

module rack() {
    difference() {
        // Main Block
        translate([-L/2, -W/2, 0])
            cube([L, W, H]);

        // 96 Vertical Through-Holes
        // The first hole (A1) is at (inset_x, inset_y) relative to the corner (-L/2, -W/2)
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                // Calculate position relative to the block center
                // Corner is at -L/2, -W/2. 
                // Hole center = Corner + offset + (index * spacing)
                pos_x = (-L/2) + inset_x + (i * spacing);
                pos_y = (-W/2) + inset_y + (j * spacing);
                
                translate([pos_x, pos_y, -0.01])
                    cylinder(h = H + 0.02, d = hole_d);
            }
        }

        // Orientation Chamfer (45-degree cut at A1 corner)
        // The corner is at (-L/2, -W/2). 
        // We create a wedge to cut the vertical edge.
        // A 45-degree chamfer on a vertical edge means the cut is diagonal across the XZ or YZ plane.
        // However, "chamfer off the vertical edge" usually implies a corner chamfer.
        // We will cut the corner of the block using a wedge.
        translate([-L/2 - 1, -W/2 - 1, 0])
        rotate([0, 0, 0])
        difference() {
            // Create a large enough shape to ensure clean cut
            cube([chamfer_leg * 2, chamfer_leg * 2, H + 2]);
            // The actual chamfer cut (45 degrees)
            // We use a polygon to define the triangular cross-section
            rotate([0, 0, 45])
            translate([-chamfer_leg, -chamfer_leg, 0])
            cube([chamfer_leg * 2, chamfer_leg * 2, H + 2]);
        }
        // Note: The above logic is complex for a simple chamfer. 
        // Let's use a simpler approach: a wedge that cuts the corner.
        // We'll subtract a prism that is oriented at 45 degrees.
        // To cut the corner edge (X=-L/2, Y=-W/2):
        translate([-L/2 - 1, -W/2 - 1, -1])
        rotate([0, 0, 0])
        // This creates a triangular prism to slice the corner
        // We'll use a simple hull of two lines to define the chamfer plane
        hull() {
            translate([0, chamfer_leg, 0]) cube([0.1, 0.1, H + 2]);
            translate([chamfer_leg, 0, 0]) cube([0.1, 0.1, H + 2]);
        }
    }
}

// Corrected Chamfer approach: 
// We want to cut the corner where X = -L/2 and Y = -W/2.
// A 45-degree chamfer on a vertical edge means the cut is a plane: X + Y = constant.
// But usually, "chamfer off the vertical edge" means the corner of the block is beveled.
// Let's use a more robust method:
module chamfer_cut() {
    // This creates a wedge that cuts the corner of the block
    // The chamfer is 5mm along the X and Y axes.
    intersection() {
        cube([L, W, H]);
        // We define the part to keep, then subtract it. 
        // Actually, it's easier to subtract a wedge.
    }
}

// Final implementation using a simple subtraction of a wedge
difference() {
    // Main Block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // 96 Vertical Through-Holes
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            pos_x = (-L/2) + inset_x + (i * spacing);
            pos_y = (-W/2) + inset_y + (j * spacing);
            translate([pos_x, pos_y, -0.01])
                cylinder(h = H + 0.02, d = hole_d);
        }
    }

    // Orientation Chamfer: A 45-degree cut on the corner edge.
    // This cuts the corner such that the new face connects (X=-L/2+5, Y=-W/2) and (X=-L/2, Y=-W/2+5)
    // We use a prism to cut this.
    translate([-L/2 - 1, -W/2 - 1, -1])
    rotate([0, 0, 0])
    difference() {
        // Large cube to ensure it covers the corner
        cube([chamfer_leg * 2, chamfer_leg * 2, H + 2]);
        // The chamfer cut: a triangle in XY plane, extruded in Z
        // We'll use a polygon for the triangle
        linear_extrude(height = H + 2)
        polygon(points=[[0, chamfer_leg], [chamfer_