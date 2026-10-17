// DIY Magnetic Stirrer Housing
// Based on an 80mm PC case fan
// Print orientation: Top plate on bed (Z=0), walls rise to Z=40

// --- Dimensions ---
// Outer size of the housing
W = 90;
H = 90;

// Thickness of the top plate (resting on bed)
T_top = 2;

// Height of the walls
H_wall = 40;

// Wall thickness
T_wall = 2.5;

// Fan mounting hole pattern
// The user specified a 71.5mm square pattern for M4 screws
// This pattern is centered on the plate.
// We need to calculate the distance from the center to the hole centers.
// Pattern size = 71.5mm. Half pattern = 35.75mm.
// The holes are M4, so we use 4.5mm diameter for the screw holes.
P_size = 71.5;
D_screw = 4.5;

// Cable notch dimensions
W_notch = 12;
H_notch = 8; // Reaches 8mm down from the open edge (Z=32 to Z=40)

// --- Configuration ---
$fn = 100; // High resolution for smooth curves and accurate hole sizes

// --- Helper Functions ---

// Function to create a rectangular hole through a wall
// x, y: center of hole
// z_start, z_end: start and end Z of the hole
// dx, dy: width and height of the hole
// wall_thickness: thickness of the wall being cut
function create_hole(x, y, z_start, z_end, dx, dy, wall_thickness) = 
  translate([x, y, z_start])
    cube([dx, dy, z_end - z_start + 0.1]); // +0.1 to ensure clean cut

// Function to create the cable notch
function create_notch() = 
  translate([0, 0, 32]) // Starts at Z=32 (8mm below open edge at Z=40)
    cube([W_notch, H, H_notch]); // Width, Full Height of wall, Notch Depth

// --- Main Construction ---

// 1. Top Plate
// Centered on origin, 90x90, 2mm thick
top_plate = translate([0, 0, 0])
  cube([W, H, T_top]);

// 2. Walls
// The walls rise from the top of the plate (Z=2) to Z=40.
// Outer dimensions are 90x90. Inner dimensions are (90 - 2*2.5) x (90 - 2*2.5) = 85x85.
// We build the walls as a solid block and then cut the holes.
// Wall block: 90x90x38 (from Z=2 to Z=40)
walls_base = translate([0, 0, T_top])
  cube([W, H, H_wall]);

// 3. Screw Holes
// Pattern: 71.5mm square centered on the plate.
// Center of pattern is (0,0).
// Hole centers are at +/- 35.75mm in X and Y.
hole_positions = [
  [-P_size/2, -P_size/2],
  [-P_size/2, P_size/2],
  [P_size/2, -P_size/2],
  [P_size/2, P_size/2]
];

// Create the holes in the walls_base
// Holes go from Z=2 (top of plate) to Z=40 (open top)
holes = for (p = hole_positions) {
  translate(p)
    cube([D_screw, D_screw, H_wall - T_top + 0.1]); // +0.1 clearance
};

// 4. Cable Notch
// Located in one wall. Let's put it in the front wall (negative Y side) or just center it on one face.
// The prompt says "In one wall... centred along the wall".
// Let's place it on the wall at Y = -H/2 + T_wall/2 (the front face).
// Actually, simpler to just subtract a block from the side of the wall assembly.
// Notch: 12mm wide, centered along the wall.
// Wall height is 40. Notch reaches 8mm down from open edge.
// Open edge is at Z=40. Notch is Z=32 to Z=40.
// Notch width 12mm. Centered along the wall (Y axis).
notch_block = create_notch();

// --- Assembly ---

// Start with the top plate
part = top_plate;

// Add the walls
part = union(part, walls_base);

// Subtract the screw holes
part = difference(part, holes);

// Subtract the cable notch
part = difference(part, notch_block);

// Final Output
part;