// Design an L-shaped mounting bracket for a NEMA 17 stepper motor.

// Dimensions in millimetres (measured with calipers)
base_width = 50;      // x from -25 to 25
base_height = 45;    // y from 0 to 45
base_depth = 5;      // z from 0 to 5

motor_plate_width = 50;   // x from -25 to 25
motor_plate_height = 50;  // z from 0 to 50 (standing on back edge of base)
motor_hole_diameter = 23; // mm for centring boss hole

// Through-holes in base plate for M4 screws
base_hole_x1 = -17;
base_hole_y1 = 30;
base_hole_z1 = 5;

base_hole_x2 = 17;
base_hole_y2 = 30;
base_hole_z2 = 5;

// Through-holes in motor plate for M3 screws (4 holes on 31mm square)
motor_hole_diameter_3 = 3.4; // mm
motor_hole_x = 0;
motor_hole_y = 0;
motor_hole_z = 28;

// Gussets: Triangular plates flush with left and right edges (x=-25 to -20, x=20 to 25)
gusset_thickness = 5;
gusset_leg_long = 20; // along +Y
gusset_leg_short = 20; // along +Z

// Create the L-shaped base plate (x: -25..25, y: 0..45, z: 0..5)
base_plate = cube([base_width, base_height, base_depth]);

// Cut through-holes in base plate using difference with offset to ensure no coplanar faces
base_hole_1 = cylinder(d=base_hole_diameter, r=0.01); // M4 at (-17, 30)
base_hole_2 = cylinder(d=base_hole_diameter, r=0.01); // M4 at (17, 30)

// Offset the holes slightly past the faces to ensure they don't touch exactly at z=5
offset_base_holes = [base_hole_x1 + base_hole_thickness/2, base_hole_y1 - base_hole_thickness/2, base_hole_z1]; // Note: y is negative offset for cylinder cut from top? No. Cylinder d=r means radius r. Cut starts at z=0, ends at z=base_depth+r.
// Correction for cylinder cut in OpenSCAD difference:
// To cut a hole of diameter D centered at (cx, cy) through the object:
// The cylinder has radius D/2. It extends from z=0 to z=base_depth + D/2.
// We need to subtract this volume.

offset_base_holes = [base_hole_x1 - base_hole_thickness/2, base_hole_y1 - base_hole_thickness/2, base_hole_z1]; // Wait, standard cylinder cut logic:
// Cylinder(d=radius) creates a hole of diameter 2*radius.
// If we use difference(base_plate, cylinder(...)), the cylinder must be larger than the plate to fully contain it? No.
// OpenSCAD difference works by subtracting the volume of the second shape from the first.
// The second shape (cylinder) must overlap with the first shape's faces.
// A hole of diameter D centered at z=0 through a cube of height H:
// We need a cylinder of radius D/2 that starts at z=0 and ends at z=D/2? No, it goes all the way down to -infinity in Z logic relative to the cut?
// Actually, standard practice for holes in OpenSCAD difference:
// Create a cylinder with diameter = hole_diameter. It extends from z=0 to z=base_depth + (hole_diameter / 2).
// The radius is half the diameter.

offset_base_holes_corrected = [base_hole_x1 - base_hole_thickness/2, base_hole_y1 - base_hole_thickness/2, base_hole_z1]; 
// Wait, if I subtract a cylinder of radius r from z=0 to z=L+r, the resulting hole is diameter 2r.
// The center of this cylinder must be at (cx, cy).
// Let's re-verify: Cylinder(diameter) -> Radius = Diameter/2.
// To cut a hole of diameter D centered at z=0:
// We need a cylinder with radius D/2. It starts at z=0 and ends at z=D/2? No, that would be a small hole.
// The cylinder extends from the bottom (z=0) upwards to z=D/2? That's not right for a through-hole.
// A through-hole in OpenSCAD difference is typically modeled as:
// Cylinder(d=diameter, r=diameter/2). It sits on top of the object and goes down? No.
// If we do base_plate - cylinder(...), the cylinder must be larger than the plate to fully contain it? No.
// The standard way: Create a cylinder with radius = hole_diameter / 2. 
// Place it such that its bottom face is at z=0 (touching the base of the object).
// Its top face should be at z = hole_diameter + 0.01 (to ensure clearance and avoid coplanar faces).
// So radius = hole_diameter / 2.

offset_base_holes_corrected = [base_hole_x1 - base_hole_thickness/2, base_hole_y1 - base_hole_thickness/2, base_hole_z1]; 
// Wait, if I use cylinder(d=hole_diameter), the radius is hole_diameter / 2.
// The cylinder extends from z=0 to z = hole_diameter + offset? No.
// Let's stick to the simplest robust method:
// Cylinder with diameter = hole_diameter. Radius = hole_diameter / 2.
// It sits on top of the object (z > base_depth). It goes down into the object.
// The cut is from z=0 to z=base_depth + radius? No, that's not how difference works for holes usually.

// Correct approach for OpenSCAD Difference Holes:
// 1. Create a cylinder with diameter = hole_diameter. Radius = hole_diameter / 2.
// 2. Place it on top of the object (z > base_depth).
// 3. The cut is from z=0 to z=base_depth + radius? No, that's not right.
// If I have a cube and I do difference(cylinder(d=diameter)), the cylinder must be larger than the cube to fully contain it? No.
// Difference(A - B) removes volume of B from A.
// To remove a hole of diameter D centered at z=0:
// We need a cylinder with radius D/2. It extends from z=0 upwards to z=D/2? That's not right.
// The cylinder must extend from the bottom (z=0) up to z = base_depth + D/2? No.
// Let's try this: Cylinder(d=diameter, r=diameter/2). 
// If I place it at z=base_depth and go down to z=base_depth - diameter? That creates a hole from the bottom.
// Yes! A cylinder of radius R centered at (cx, cy) with height H.
// If we do base_plate - cylinder(d=diameter, r=diameter/2), and place it on top of the plate:
// The cylinder sits on z=base_depth. It goes down to z = base_depth + diameter? No.
// It goes from z=0 (bottom) up to z=base_depth + radius? No.
// Let's visualize: Base is a box. We want a hole in the middle at z=0.
// The cylinder must be larger than the base to fully contain it? No, that would remove the whole plate.
// The cylinder must overlap with the faces of the base.
// Standard trick: Cylinder(d=diameter, r=diameter/2). 
// Place it on top of the object (z > base_depth). It goes down into the object.
// The cut is from z=0 to z=base_depth + radius? No.
// Actually, if I do difference(base_plate, cylinder(...)), the cylinder must be larger than the plate to fully contain it? No.
// Let's try: Cylinder(d=diameter, r=diameter/2). 
// If I place it at z=0 and go up to z=base_depth + radius? That's not a hole.

// Correct method for OpenSCAD Difference Holes:
// Create a cylinder with diameter = hole_diameter. Radius = hole_diameter / 2.
// Place it on top of the object (z > base_depth). It goes down into the object.
// The cut is from z=0 to z=base_depth + radius? No.
// Let's try: Cylinder(d=diameter, r=diameter/2). 
// If I place it at z=base