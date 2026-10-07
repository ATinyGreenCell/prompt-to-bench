// L-shaped mounting bracket for NEMA 17 stepper motor
// Print orientation: Base plate on XY plane (z=0), building upward (+Z)
// Centered in X and Y at origin

// --- Dimensions & Positions (measured with calipers, units in mm) ---
$fn = 64; // Polygon resolution for smooth holes/edges

// Base Plate Geometry
base_plate_x_min = -25;     // Left edge of base plate
base_plate_x_max = 25;      // Right edge of base plate (back edge where motor plate stands)
base_plate_y_min = 0;       // Front edge of base plate
base_plate_y_max = 45;      // Back edge of base plate

// Base Plate Thickness & Features
base_thickness = 5;         // Height from z=0 to z=5
m4_hole_diameter = 4.5;    // Diameter for M4 mounting holes (through-hole)
m4_hole_x1 = -17;          // X position of first through hole
m4_hole_y_pos = 30;        // Y position of both through holes

// Motor Plate Geometry & Positioning
motor_plate_thickness = 5; // Height from z=0 to z=5 (same as base, stacked)
motor_plate_z_max = 50;    // Top edge height
motor_centre_x = 0;        // X position of motor centring boss hole centre
motor_centre_y_pos = 28;   // Y position of motor centring boss hole (along Z axis relative to base? No, user said "z=28" in plate coords)

// Motor Plate Holes
motor_boss_hole_diameter = 23; // Diameter for NEMA 17 centring boss
m3_screw_hole_diameter = 3.4;   // Diameter for M3 screw holes (through-hole along Y? No, user said "along Y cut a hole", but then says pattern is square on Z plane)

// Gusset Geometry & Positioning
gusset_thickness = 5;        // Thickness of triangular gussets in X direction
gusset_leg_y = 20;          // Length along +Y leg (from y=5 to y=25? No, user said "legs 20mm")
gusset_leg_z = 20;          // Length along +Z leg

// Gusset Corner Positioning (Right-angle corner)
gusset_corner_y = 5;        // Y coordinate of right angle corner on the intersection line
gusset_corner_z = 5;        // Z coordinate of right angle corner at base level? No, user said "y=5, z=5"

// Gusset Edge Positions (Flush with edges)
left_gusset_x_min = -25;    // Left edge flush with left side of plates (-25 to -20 is 5mm thick?) Wait: User says x from -25 to -20. That's a width of 5mm? No, user said "x from -25 to -20".
// Re-reading gusset description carefully: "each is a right triangle in the YZ plane with legs 20 mm along +Y and 20 mm along +Z"
// And position: "right-angle corner at y = 5, z = 5 (where plates meet)"
// And flush edges: x from -25 to -20? That implies a width of 5mm. But user said gusset is triangular in YZ plane... 
// Wait, if it's a triangle in the YZ plane, its extent in X should be constant (thickness).
// User says "flush with left and right edges". Left edge at x=-25? Right edge at x=20 to 25? That implies thickness is 5mm. 
// But user said gusset is triangular in YZ plane... So the triangle lies flat against the side wall (YZ plane).
// The "legs" are along +Y and +Z directions from the corner.

// Gusset Dimensions Correction based on description:
gusset_thickness_x = 5;     // Thickness of gusset plate (x-direction) - derived from flush edges (-25 to -20 is 5mm wide? No, user said x range for left gusset is -25 to -20. That's a width of 5mm.)
// Wait: "flush with the left and right edges". Left edge at x=-25. Right edge (inner) at x=-20? 
// User says: "x from -25 to -20" for left gusset. Width = |-20 - (-25)| = 5mm.
// And "right-angle corner at y=5, z=5".
// Legs are 20mm along +Y and 20mm along +Z? 
// If right angle is at (y=5, z=5), then the triangle extends from:
//   Y: 5 to 5+20 = 25.
//   Z: 5 to 5+20 = 25.
// But wait, where does it start in X? 
// If flush with left edge (x=-25), then the triangle is at x from -25 to -25 + gusset_thickness_x? Or is the thickness defined by the user's range?
// User says "x from -25 to -20". That means the gusset occupies X in [-25, -20]. So width = 5mm.

// Let's re-read carefully: 
// Gussets are triangular in YZ plane. Legs 20mm along +Y and +Z. Right angle at y=5, z=5.
// Flush with left edge (x=-25) -> The triangle starts at x=-25? Or is the gusset thickness 5mm starting from -25 to -20? 
// User says "flush with... edges". Left edge of base/motor plate is at x=-25. Right edge of left gusset (inner side) should be where it meets the main body?
// The user specifies: "x from -25 to -20" for left gusset. This defines its X extent as [-25, -20]. So thickness = 5mm.

// Gusset Positioning Details:
gusset_corner_y_start = 5; // Start Y of leg along +Y (from corner) -> extends to y=25? Or is the leg length defined differently? 
// User says "legs 20 mm". So from corner (y=5), it goes up by 20mm.
gusset_corner_z_start = 5; // Start Z of leg along +Z (from corner) -> extends to z=25? Or is the leg length defined differently? 
// User says "legs 20 mm". So from corner (z=5), it goes up by 20mm.

// Gusset Corner Position:
gusset_corner_y = 5;        // Y coordinate of right angle corner on intersection line
gusset_corner_z = 5;        // Z coordinate of right angle corner at base level? No, user said "y=5, z=5". 
// Wait, where is the motor plate relative to this? Motor plate stands on back edge (x=-25). Base plate goes from x=-25 to x=25.
// Intersection line: The plates meet along a vertical plane at x = -25? Or does the gusset bridge them? 
// User says "where the plates meet". This implies the corner is on the seam between base and motor plate.

// Gusset Geometry Construction (Right Triangle):
gusset_leg_y_length = 20;   // Length of leg along +Y from corner
gusset_leg_z_length = 20;   // Length of leg along +Z from corner


// --- Model Definition ---

module base_plate() {
    translate([base_plate_x_min, base_plate_y_min, 0]) 
        cube([base_plate_x_max - base_plate_x_min, base_plate_y_max - base_plate_y_min, base_thickness]);
    
    // Cut two M4 through-holes at (x = -17, y = 30) and (x = 17, y = 30)
    // Holes are cylindrical. They go from z=0 to top of plate? Or just cut out material? 
    // "through-holes" implies full depth through the base thickness (z=0 to z=5).
    
    difference() {
        translate([m4_hole_x1, m4_hole_y_pos, 2.75]) cylinder(r = m4_hole_diameter/2, h = base_thickness); // Center of hole at z=2.75 (mid-height)
        
        // Second hole: x = 17, y = 30
        translate([m4_hole_x1 + 34, m4_hole_y_pos, 2.75]) cylinder(r = m4_hole_diameter/2, h = base_thickness); 
    }
}

module motor_plate() {
    // Base plate is at z=0 to z