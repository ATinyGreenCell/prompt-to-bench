$fn = 128;

// --- Dimensions ---
// Outer dimensions
D_X_OUT = 120; // mm
D_Y_OUT = 70;  // mm
D_Z_OUT = 40;  // mm

// Wall and floor thickness
WALL_THICK = 3; // mm
FLOOR_THICK = 3; // mm

// Platform dimensions
P_L_X = 60;     // mm (Length in X, centred)
P_W_Y = D_Y_OUT; // mm (Spans full inner width)
P_H = 10;       // mm (Height above inner floor)

// Hole dimensions
HOLE_D = 2;     // mm diameter
HOLE_Y = 0;     // mm position
HOLE_Z = 30;    // mm position

// --- Calculated Inner Dimensions ---
// Inner X = Outer X - 2*Wall
D_X_IN = D_X_OUT - 2 * WALL_THICK;
// Inner Y = Outer Y - 2*Wall
D_Y_IN = D_Y_OUT - 2 * WALL_THICK;
// Inner Z (floor level) = Outer Z - Floor
Z_FLOOR = D_Z_OUT - FLOOR_THICK;

// --- Main Tank Body ---
// Create the outer shell
tank_outer = translate([0, 0, 0])
    cube([D_X_OUT, D_Y_OUT, D_Z_OUT], center = false);

// Create the inner void for subtraction
// The void starts at the floor level and goes up to the top.
// We add a small offset (0.1mm) to ensure the cut is clean and not coplanar.
void_offset = 0.1;
void_height = D_Z_OUT - FLOOR_THICK + void_offset;
void_x_start = WALL_THICK - void_offset;
void_x_end = D_X_OUT - WALL_THICK + void_offset;
void_y_start = WALL_THICK - void_offset;
void_y_end = D_Y_OUT - WALL_THICK + void_offset;

inner_void = translate([void_x_start, void_y_start, FLOOR_THICK])
    cube([void_x_end - void_x_start, void_y_end - void_y_start, void_height], center = false);

// Combine to get the tank shell
tank = union([tank_outer, inner_void]);

// --- Raised Platform ---
// The platform sits on the inner floor.
// Position: Centred in X, spans full Y, starts at Z = FLOOR_THICK.
// Top Z = FLOOR_THICK + P_H.
// We add this volume to the tank.

platform_pos_x = (D_X_OUT - P_L_X) / 2;
platform_pos_y = (D_Y_OUT - P_W_Y) / 2; // Should be 0 since P_W_Y = D_Y_OUT
platform_z_start = FLOOR_THICK;
platform_z_end = FLOOR_THICK + P_H;

platform = translate([platform_pos_x, platform_pos_y, platform_z_start])
    cube([P_L_X, P_W_Y, P_H], center = false);

// Combine Tank and Platform
final_part = union([tank, platform]);

// --- Electrode Holes ---
// Drilling horizontal holes along X at specific Y and Z.
// We create two cylinders, one for each end wall, to cut through the solid.
// Hole center: Y = HOLE_Y, Z = HOLE_Z.
// Hole extends along X through the wall thickness.

// Calculate X positions for the centers of the holes in the end walls
// Wall thickness is 3mm. Center is 1.5mm from the face.
hole_x1 = WALL_THICK / 2;
hole_x2 = D_X_OUT - WALL_THICK / 2;

// Create the hole cutters
hole_cutters = [];
for (i = [0, 1]) {
    x_pos = (i == 0) ? hole_x1 : hole_x2;
    // Cylinder height must be greater than the tank length to cut through
    cutter = translate([x_pos, HOLE_Y, HOLE_Z])
        cylinder(h = D_X_OUT + 10, r = HOLE_D / 2, $fn = 64);
    hole_cutters.push(cutter);
}

// Apply holes using difference
final_part = difference([final_part, hole_cutters]);

// --- Final Output ---
// Center the part on the origin in X and Y as requested
translate([(D_X_OUT)/2, (D_Y_OUT)/2, 0])
    final_part;