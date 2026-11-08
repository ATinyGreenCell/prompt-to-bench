// Design an L-shaped mounting bracket for a NEMA 17 stepper motor.

// --- Dimensions (mm) ---
base_width = 50;       // x from -25 to 25
base_height = 45;     // y from 0 to 45
base_depth = 5;       // z from 0 to 5

motor_plate_width = 50; // x from -25 to 25
motor_plate_height = 50; // z from 0 to 50 (standing on back edge of base)
motor_hole_diameter = 23; // mm for centring boss hole
gusset_thickness = 5;   // mm

// --- Geometry Definitions ---

// Base Plate: x -25..25, y 0..45, z 0..5
base_plate = cube([base_width, base_height, base_depth]);

// Vertical Motor Plate: x -25..25, y 0..5, z 0..50
motor_plate = cube([motor_plate_width, motor_plate_height, motor_plate_height]);

// --- Holes for Base Plate (M4) ---
// Two through-holes at (x=-17, y=30) and (x=17, y=30), diameter 4.5 mm
hole_m4_a = cylinder([4.5, 28, 0]); // radius 2.25, height 28
hole_m4_b = translate([base_width/2 - 17, base_height/2 - 30, 0]) rotate(90) cylinder([4.5, 28, 0]);

// --- Holes for Motor Plate (M3) ---
// Four M3 holes on a 31mm square pattern centred on the boss hole at x=0, z=28
boss_hole = translate([0, 0, motor_plate_height/2 - 11.5]) rotate(90) cylinder([3.4, 67, 0]); // radius 1.7

// The square pattern is centred on the boss hole. 
// Boss hole center: x=0, z=28 (in motor plate coords).
// Square side length: 31 mm. Center of square: x=0, z=28 + 15.5 = 43.5.
square_x_center = 0;
square_z_center = boss_hole.position.z + 15.5;

// Create a 3x3 grid of holes (9 holes total)
// Hole size: diameter 3.4 mm -> radius 1.7 mm
hole_m3_radius = 1.7;
hole_m3_size = 2 * hole_m3_radius; // 3.4 mm

for(hole_idx = -1 to 1, step(1)) {
    for(zhole_idx = -1 to 1, step(1)) {
        // Calculate position relative to square center (0, 43.5)
        sx = hole_idx * hole_m3_size;
        sy = (hole_idx + 2) * hole_m3_size / 2; // Center of the row
        
        // Convert from square center coordinates back to motor plate local coords
        // Square is centered at x=0, z=square_z_center.
        // We want holes at: sx, sy relative to (0, square_z_center).
        
        // Translate by -square_x_center and +square_z_center
        pos = translate([-square_x_center, square_z_center]) rotate(90) cylinder([hole_m3_size, 67, 0]);

        // Apply the four M3 holes: top-left, top-right, bottom-left, bottom-right of the square
        // Top row (sy > 15.5): Left and Right
        if(sy > hole_m3_radius) {
            pos = translate([sx - hole_m3_size/2, sy - hole_m3_radius, 0]) rotate(90) cylinder([hole_m3_size, 67, 0]);
            pos = translate([sx + hole_m3_size/2, sy - hole_m3_radius, 0]) rotate(90) cylinder([hole_m3_size, 67, 0]);
        }
        
        // Bottom row (sy < 15.5): Left and Right
        if(sy < -hole_m3_radius) {
            pos = translate([-sx + hole_m3_size/2, sy + hole_m3_radius, 0]) rotate(90) cylinder([hole_m3_size, 67, 0]);
            pos = translate([sx - hole_m3_size/2, sy + hole_m3_radius, 0]) rotate(90) cylinder([hole_m3_size, 67, 0]);
        }

        // Add the central boss hole (always present)
        pos = translate([0, 0, motor_plate_height/2 - 11.5]) rotate(90) cylinder([hole_m3_size, 67, 0]);
    }
}

// --- Gussets ---
// Two triangular gussets, 5 mm thick, flush with left and right edges (x = -25 to -20 and x = 20 to 25)
// Each is a right triangle in the YZ plane.
// Legs: 20 mm along +Y and 20 mm along +Z.
// Right-angle corner at y=5, z=5 (where plates meet).

// Gusset Left (x = -25 to -20)
gusset_left = translate([-base_width/2 - base_width/4, 0, 0]) rotate(90) polygon([[-15, 0], [15, 0], [-15, 20], [15, 20]]); // Note: OpenSCAD polygon uses (x,y,z). Here we define the triangle vertices.
// Wait, standard polygon in OpenSCAD is (x,y,z) or (y,x,z)? It's (x,y,z).
// Let's re-orient for clarity.
// Gusset Left: x from -25 to -20. y from 0 to 45. z from 0 to 50.
// Triangle vertices in YZ plane (relative to its own local origin at bottom-left):
// Origin of triangle: y=5, z=5.
// Leg along +Y: length 20 -> vertex at y = 5+20 = 25.
// Leg along +Z: length 20 -> vertex at z = 5+20 = 25.
// Hypotenuse connects (y=5, z=5) to (y=25, z=25).

gusset_left_vertices = [5, 5, 5]; // y,z,x
gusset_left_vertices[1] = [25, 25, -base_width/2 + base_width/4]; // x coordinate for left edge
// Actually, the triangle is in the YZ plane. The X dimension of the part is constant (-20 to -25).
// So the vertices are:
v1 = [5, 5, 5]; // Bottom-Left (relative)
v2 = [25, 25, -base_width/4 + base_width/4]; // Top-Right (relative) -> y=25, z=25. x=-20.
v3 = [5, 25, -base_width/4 + base_width/4]; // Bottom-Right (relative) -> y=25, z=5. x=-20.

// Create the triangle face
gusset_left_face = polygon([v1, v2, v3]);

// Gusset Right (x = 20 to 25)
gusset_right_vertices = [5, 5, 5]; // Bottom-Left (relative) -> y=25, z=5. x=20.
v1 = [5, 5, 5]; 
v2 = [25, 25, -base_width/4 + base_width/4]; // Top-Right (relative) -> y=25, z=25. x=20.
v3 = [5, 25, -base_width/4 + base_width/4]; // Bottom-Right (relative) -> y=5, z=5. x=20.

gusset_right_face = polygon([v1, v2, v3]);

// Extrude the gussets
gusset_left_extruded = extrude(gusset_thickness) rotate(90) union(gusset_left_face); // Rotate 90 to align with YZ plane normal? 
// Wait. The triangle is in the YZ plane (normal along X). To print it flat against the XY bed, we need to rotate it so its normal points +X or -X depending on orientation.
// The prompt says "flush with the left and right edges". This implies they are vertical plates extending from the side walls of the base/motor plate.
// If we just extr