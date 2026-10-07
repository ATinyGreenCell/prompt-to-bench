// Sowing Template for Petri Dish

// --- Dimensions ---
disc_diameter = 85;      // Diameter of the main disc (mm)
disc_thickness = 2;      // Thickness of the disc (mm)
hole_diameter = 3;       // Diameter of each through-hole (mm)
grid_size = 7;           // Number of holes along one side (N x N grid)
spacing = 9;             // Center-to-center spacing between holes (mm)
notch_width_x = 10;      // Width of the rectangular notch in X direction (mm)
notch_depth_y = 4;       // Depth of the rectangular notch into Y from rim (mm)

// --- Constants ---
$fn = 64; // High resolution for curves

// --- Calculations ---
disc_radius = disc_diameter / 2;
hole_radius = hole_diameter / 2;

// The grid is centered. For N holes, there are (N-1) spacings between centers.
// Total span of the centers: (grid_size - 1) * spacing
total_span = (grid_size - 1) * spacing;

// Center coordinates for the hole array (relative to disc center at origin)
// X positions: -(total_span/2), ..., +(total_span/2)
x_positions = [i * spacing - total_span / 2 for i in [0 : grid_size-1]];
y_positions = [j * spacing - total_span / 2 for j in [0 : grid_size-1]];

// --- Module Definitions ---

// Main disc body
module main_disc() {
    cylinder(r = disc_radius, h = disc_thickness, center = true);
}

// Hole cutting tool (must extend slightly past the disc)
module hole_cutter(x_pos, y_pos) {
    translate([x_pos, y_pos]) { // Translate to desired grid position
        // Extend 0.1mm below Z=0 plane for clean cut. Center = true handles symmetry around Z=0.
        cylinder(r = hole_radius + 0.1, h = disc_thickness + 0.2, center = true); 
    }
}

// Notch cutting tool (must extend slightly past the rim)
module notch_cutter() {
    // The rim is at radius R. We cut into Y from the rim on the +Y side.
    // Rim location in Y: disc_radius
    // Cut depth is 4mm *in* from the rim.
    
    // To ensure the cut starts exactly at the rim plane (Z=disc_thickness/2) and goes inward, 
    // we position the center of the cube such that its top face aligns with the rim's top surface, 
    // and it extends inwards by notch_depth_y.

    // Center Y position: disc_radius - notch_depth_y / 2 (to ensure the cut starts at the rim)
    translate([0, disc_radius - notch_depth_y/2]) { 
        // Cube dimensions: Width X, Depth Y, Thickness Z
        cube([notch_width_x + 0.2, notch_depth_y + 0.2, disc_thickness + 0.2], center = true);
    }
}


// --- Assembly ---

difference() {
    // 1. The base disc
    main_disc();

    // 2. Cut the grid holes
    for (i = [0 : grid_size-1]) {
        for (j = [0 : grid_size-1]) {
            hole_cutter(x_positions[i], y_positions[j]);
        }
    }

    // 3. Cut the rim notch on the +Y side
    notch_cutter();
}