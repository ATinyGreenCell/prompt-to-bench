// Dimensions in millimeters
plate_width = 130;           // X dimension of the flat plate
plate_length = 90;          // Y dimension of the flat plate
plate_thickness = 4;       // Thickness of the plate (z-direction)
hole_diameter = 30.5;      // Diameter of each through-hole
hole_center_to_center = 40; // Center-to-center distance between holes in both directions
wall_thickness = 4;       // Thickness of the solid walls (Y-direction)
wall_height = 70;         // Height of walls from plate to z = 70

// $fn for smooth holes and edges
$fn = 64;

// Create the base plate (flat, on z = 0 to 4)
// The plate should be 130 mm (X) by 90 mm (Y) by 4 mm (Z)
base_plate = cube([plate_width, plate_length, plate_thickness]);

// Define hole positions: 3 holes in each row (2 rows), 40 mm center-to-center
// Rows at y = 20, 60 (centered on 45 mm, so 20 and 60 are within 0 to 90)
// Columns at x = 30, 70, 110 (centered on 85 mm, so 30, 70, 110 are within 0 to 130)
// So 3 columns × 2 rows = 6 holes

holes = [
  [30, 20], [70, 20], [110, 20],
  [30, 60], [70, 60], [110, 60]
];

// Create the through-holes (cylinders) in the base plate
// Each hole goes from z=0 to z=4, diameter 30.5 mm
// Extend slightly beyond the face to avoid coplanar issues
for (i = [0:5]) {
  hole_x = holes[i][0];
  hole_y = holes[i][1];
  // Cylinder with height 4 + 0.1 mm to avoid coplanar issues
  translate([hole_x, hole_y, 0]) 
    cylinder(h = plate_thickness + 0.1, r = hole_diameter / 2, center = true, $fn = 64);
}

// Create the two solid walls along the long edges (X-direction)
// Wall on left: x from 0 to 130, y from 0 to 4, z from 0 to 70
// Wall on right: x from 130 to 130, y from 0 to 4, z from 0 to 70
// But the wall should be 4 mm thick in Y (height in Y), and rise to z=70

// Wall 1: left edge (x=0), from y=0 to 4, z=0 to 70
// Wall 2: right edge (x=130), from y=0 to 4, z=0 to 70

// First, create the wall at x=0
// This wall is 130 mm long (x), 4 mm thick (y), 70 mm high (z)
// So we create a rectangular prism from x=0 to 130, y=0 to 4, z=0 to 70
// But the plate is only from x=0 to 130, y=0 to 90, z=0 to 4
// So we want to extend the wall from z=0 to 70

// Wall at x=0: from x=0 to 130, y=0 to 4, z=0 to 70
// But we must avoid overlapping with the base plate — we use difference

// Instead, build the walls as cubes and subtract the base plate?

// Better: build the walls as cubes and union with the base plate

// Wall 1: left wall (x=0 to 130, y=0 to 4, z=0 to 70)
wall_left = cube([130, 4, 70]);

// Wall 2: right wall (x=130 to 130, y=0 to 4, z=0 to 70)
// This is a 1x4x70 block at x=130
wall_right = cube([1, 4, 70]);

// But we want the right wall to be at x=130, extending from x=130 to 131, y=0 to 4, z=0 to 70
// So wall_right = cube([1, 4, 70]) at (x=130, y=0, z=0)

// Now, the base plate is at [130, 90, 4]
// We want to place the walls at x=0 and x=130, extending from y=0 to 4, z=0 to 70

// So:
// Wall at x=0: from x=0 to 130, y=0 to 4, z=0 to 70
// Wall at x=130: from x=130 to 131, y=0 to 4, z=0 to 70

// So we create:
wall_left = cube([130, 4, 70]);
wall_right = cube([1, 4, 70]);

// Translate wall_right to x=130
wall_right = translate([130, 0, 0]) cube([1, 4, 70]);

// Now, union all: base plate + walls
// But the base plate is already at [130,90,4]
// We must avoid overlapping — so we build the entire part as:
// 1. The base plate
// 2. The two walls (left and right)

// But the walls extend beyond the base plate in z, and in x

// So we create the full part as:
// base_plate + wall_left + wall_right

// However, the base plate is only 4 mm thick — we want to subtract the holes from the base plate

// Correct approach: start with the base plate, then subtract the holes (cylinders), then add the walls

// But the walls are solid and extend upward — so we must build them as separate volumes

// We will:
// 1. Start with the base plate (without holes)
// 2. Subtract the 6 cylindrical holes
// 3. Add the two walls (left and right)

// So:
// part = (base_plate - holes) + wall_left + wall_right

// But OpenSCAD: union, difference, intersection

// So:
// base_plate_minus_holes = base_plate - holes
// full_part = base_plate_minus_holes + wall_left + wall_right

// First, create the base plate
base_plate = cube([plate_width, plate_length, plate_thickness]);

// Subtract the 6 holes
for (i = [0:5]) {
  hole_x = holes[i][0];
  hole_y = holes[i][1];
  // Translate the cylinder to the hole position
  // Cylinder from z=0 to z=4, diameter 30.5 mm
  // Extend slightly beyond the face to avoid coplanar issues
  difference() {
    // The base plate
    cube([plate_width, plate_length, plate_thickness]);
    // The hole
    translate([hole_x, hole_y, 0]) 
      cylinder(h = plate_thickness + 0.1, r = hole_diameter / 2, center = true, $fn = 64);
  }
}

// But we need to build the walls as separate cubes

// Wall at left: x=0 to 130, y=0 to 4, z=0 to 70
wall_left = cube([130, 4, 70]);

// Wall at right: x=130 to 131, y=0 to 4, z=0 to 70
wall_right = translate([130, 0, 0]) cube([1, 4, 70]);

// Now, the full part is:
// base_plate_minus_holes + wall_left + wall_right

// But the base_plate_minus_holes is already a difference — we must use union

// So:
// full_part = (base_plate - holes) + wall_left + wall_right

// We build it as:
// 1. Start with the base plate
// 2. Subtract the 6 holes
// 3. Add the two walls

// So:
// final_part = (base_plate - holes) + wall_left + wall_right

// But we must define the holes as difference operations

// We will use:
// full_part = union() {
//   base_plate - holes
//   wall_left
//   wall_right
// }

// So:

// Start with base plate
// Then subtract the 6 holes
// Then add the two walls

// But we must avoid overlapping — the walls are outside the base plate

// So we build the full part as:

// 1. The