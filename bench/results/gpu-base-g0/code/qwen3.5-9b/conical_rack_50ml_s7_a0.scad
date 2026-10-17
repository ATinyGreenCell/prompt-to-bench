// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: Upside down. Flat plate on bed (Z=0).
// After printing, flip over so walls stand on the bed and tubes hang down.

// --- Dimensions ---
// Plate dimensions
W_PLATE = 130; // Width (X)
D_PLATE = 90;  // Depth (Y)
T_PLATE = 4;   // Thickness (Z)

// Hole specifications
N_HOLES = 6;
D_HOLE = 30.5; // Diameter
C_HOLE_X = 40; // Centre-to-centre spacing (X)
C_HOLE_Y = 40; // Centre-to-centre spacing (Y)

// Wall specifications
L_WALL = 130;  // Length (X)
T_WALL = 4;    // Thickness (Y)
H_WALL = 70;   // Height (Z)

// --- Configuration ---
$fn = 128; // High resolution for smooth holes and walls

// --- Helper: Create the main plate with holes ---
// The plate is a solid block with cylindrical holes subtracted.
// We use a large cylinder for the plate and subtract smaller cylinders for holes.
// To ensure clean cuts, we extend the hole cylinders slightly past the plate thickness.

module create_plate() {
    // Main plate body
    difference() {
        // Base plate: 130x90x4
        cube([W_PLATE, D_PLATE, T_PLATE], center = true);
        
        // Holes: 2 rows of 3
        // Row 1 (Y = -D_PLATE/2 + C_HOLE_Y/2)
        for (i = [-1, 0, 1]) {
            translate([i * C_HOLE_X, -D_PLATE/2 + C_HOLE_Y/2, 0]) {
                // Hole cylinder: diameter D_HOLE, height T_PLATE + 1mm overcut
                cylinder(h = T_PLATE + 1, d = D_HOLE, $fn = 128);
            }
        }
        // Row 2 (Y = +D_PLATE/2 - C_HOLE_Y/2)
        for (i = [-1, 0, 1]) {
            translate([i * C_HOLE_X, D_PLATE/2 - C_HOLE_Y/2, 0]) {
                // Hole cylinder: diameter D_HOLE, height T_PLATE + 1mm overcut
                cylinder(h = T_PLATE + 1, d = D_HOLE, $fn = 128);
            }
        }
    }
}

// --- Helper: Create the side walls ---
// Walls run along the long edges (X-axis), rising from Z=0 to Z=H_WALL.
// Thickness is in Y direction.
module create_walls() {
    // Left Wall (at X = -W_PLATE/2)
    translate([-W_PLATE/2, 0, 0]) {
        cube([L_WALL, T_WALL, H_WALL], center = false);
    }
    
    // Right Wall (at X = +W_PLATE/2)
    translate([W_PLATE/2, 0, 0]) {
        cube([L_WALL, T_WALL, H_WALL], center = false);
    }
}

// --- Main Assembly ---
// Combine plate and walls.
// Note: The walls are printed flush with the plate edges.
// Since the plate is 4mm thick and walls are 4mm thick, they align perfectly at the interface.

union() {
    create_plate();
    create_walls();
}