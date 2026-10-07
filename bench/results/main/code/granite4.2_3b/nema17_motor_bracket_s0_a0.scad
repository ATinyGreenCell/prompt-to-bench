// Dimensions in millimetres
base_x_range = 50;      // x from -25 to 25 => range 50 mm
base_y_range = 45;      // y from 0 to 45 => range 45 mm
base_z_height = 5;      // z from 0 to 5 => height 5 mm
motor_x_range = 50;     // x from -25 to 25 => range 50 mm
motor_y_range = 5;      // y from 0 to 5 => range 5 mm
motor_z_height = 50;    // z from 0 to 50 => height 50 mm
hole_diameters: M4 = 4.5, M3 = 3.4;
boss_radius = 11.5;      // centring boss diameter is 23 mm => radius 11.5 mm
square_pattern_spacing = 31; // side of square pattern in mm (distance between screw holes)
gusset_thickness = 5;    // thickness of gussets in mm
gusset_leg_length = 20;  // legs along Y and Z are 20 mm each

// Base plate: rectangle from x=-25 to 25, y=0 to 45, z=0 to 5
base_plate = cube([base_x_range, base_y_range, base_z_height], center=true);

// Cut M4 holes at (x = -17, y = 30) and (x = 17, y = 30) on the base plate.
// Ensure hole extends slightly beyond faces for proper printing.
hole1 = cylinder(diameter=M4*2, height=base_z_height + 0.02, center=[-17, 30, 0]);
hole2 = cylinder(diameter=M4*2, height=base_z_height + 0.02, center=[17, 30, 0]);

// Motor plate: rectangle from x=-25 to 25, y=0 to 5, z=0 to 50, standing on the back edge of the base.
motor_plate = cube([motor_x_range, motor_y_range, motor_z_height], center=true);

// Cut a 23 mm hole for the centring boss with centre at x=0, z=28 (in global coordinates).
// The boss is centered in Y as well? Not specified; assume it's centered along X and Z.
// Since motor plate y-range is [0,5], we place the boss such that its center aligns with the back edge of base.
// We'll define the hole as a cylinder whose axis runs along Y (as stated: "cut ... along Y").
// The centre point in global coordinates should be at x=0, z=28 (y unspecified? likely y = motor_y_range/2 = 2.5).
boss_center = [0, motor_y_range/2, motor_z_height/2]; // approximate center of motor plate's back edge region
boss_hole = cylinder(diameter=23*2, height=motor_z_height + 0.02, center=[0, motor_y_range/2, motor_z_height/2], axis=[0,1,0]); // axis along Y (rotate appropriately)

// Cut four M3 screw holes on a 31 mm square pattern centred on the boss hole.
// Pattern: 4 holes at positions relative to boss centre: (+/- gusset_leg_length in Y and Z).
// Since motor plate y-range is only 5 mm, we must place holes within bounds (y=0..5, z=0..50).
// We'll assume the square pattern is oriented with sides parallel to Y and Z axes.
// The four M3 holes are at:
//   (+gusset_leg_length, +gusset_leg_length) in YZ plane? Actually need coordinates in global space.
// Let’s define hole positions as vectors from boss centre along Y and Z directions.
// We'll use a for loop over four corners of the square pattern (centered at boss).
square_corners = [
    [-gusset_leg_length, gusset_leg_length],   // (+Y, +Z) relative to boss centre? Wait: we need Y and Z offsets.
    [gusset_leg_length, -gusset_leg_length],
    [gusset_leg_length, gusset_leg_length],
    [-gusset_leg_length, -gusset_leg_length]
]; // Actually we need four points: (±a, ±b) where a = b = gusset_leg_length? But pattern is square of side 31 mm.
// The problem says "four 3.4 mm holes for M3 screws on a 31 mm square pattern centred on the boss hole."
// So we have a square of side length 31 mm, centered at boss centre, with four screw holes at its corners? Or along edges? Usually "square pattern" means holes placed at corners of a square.
// We'll interpret as: four M3 holes located at the four corners of a square of side 31 mm, centered on the boss hole (which is a circular hole).
// The centre of the square coincides with the boss centre point.
// So we define offsets from boss centre to each corner:
//   (+gusset_leg_length, +gusset_leg_length) in YZ plane? But gusset_leg_length = 20 mm, which is less than half of 31 mm (15.5 mm). So we need a different offset magnitude.
// Actually the square pattern side length is 31 mm, so half-side = 15.5 mm. We'll use that as offset in Y and Z directions from boss centre.
half_square_side = motor_y_range/2; // but motor_y_range=5 => half=2.5 mm, which may be too small compared to required 15.5 mm.
// Better: define offsets using the given gusset dimensions? The problem says "four 3.4 mm holes ... on a 31 mm square pattern". So we need to place holes at positions that form a square of side 31 mm, centered on boss hole.
// We'll compute offset in Y and Z directions as half_side = motor_y_range/2? But motor_y_range is only 5 mm, which may not be sufficient for the pattern if we require 15.5 mm spacing along Y or Z.
// However, the problem statement likely expects that the square pattern fits within the motor plate dimensions (which are y from 0 to 5 mm). So maybe the pattern is oriented such that its sides are aligned with X and Z? Or perhaps the "31 mm square pattern" refers to a pattern in the YZ plane where each side is 31 mm, but the motor plate only has 5 mm in Y direction. This seems contradictory.
// Let's re-read: "four 3.4 mm holes for M3 screws on a 31 mm square pattern centred on the boss hole." and earlier: "each is a right triangle in the YZ plane with legs 20 mm along +Y and +Z, its right-angle corner at y = 5, z = 5 (where the plates meet)."
// So the gussets are defined in YZ plane. The motor plate's Y range is only 5 mm, so a leg of 20 mm would exceed that range. But note: the legs are along +Y and +Z directions, but the gusset thickness is 5 mm (in X direction). In the YZ plane, the legs are measured in Y and Z axes, which are within the motor plate's dimensions? The motor plate has y from 0 to 5 mm, so a leg of 20 mm along +Y would go beyond the plate.
// However, the problem says: "each is a right triangle in the YZ plane with legs 20 mm along +Y and +Z". This likely means that within the YZ cross-section (ignoring X), the triangle has legs of length 20 mm measured along the Y and Z axes. But the motor plate's y extent is only 5 mm, so this seems impossible unless we interpret "legs" as physical lengths in the printed part, not absolute coordinates.
// Given typical printing, the gusset shape should be defined using its own local coordinates; but OpenSCAD uses global axes for translate/rotate.
// To resolve: The problem likely means that the triangle's legs are 20 mm long along Y and Z directions within the printed part, meaning we place the triangle such that its right-angle corner is at (y=5, z=5) in global coordinates, and the other two vertices extend +Y by 20 mm and +Z by 20 mm. But if y range is only 0 to 5 mm on the motor plate, then extending +Y by 20 mm would go beyond the plate's boundary (y > 5). However, the gusset is flush with the left/right edges of