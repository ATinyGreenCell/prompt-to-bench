// Dimensions for DIY magnetic stirrer housing
$fn = 64;

// Overall dimensions
outer_width = 90;        // X dimension
outer_depth = 90;         // Y dimension
top_thickness = 2;      // Z thickness of top plate
wall_height = 40;         // Height of walls from top plate
wall_thickness = 2.5;     // Thickness of side walls

// Screw hole dimensions
screw_diameter = 4.5;   // Diameter of screw holes
screw_pattern_diameter = 71.5; // Diagonal distance between screw holes (square pattern)

// Notch for power cable
notch_width = 12;       // Width of notch in wall
notch_depth = 8;       // Depth from open edge (z = 32 to z = 40)
notch_position = 45;   // Center of wall in Y (since wall is 90mm long)

// Calculate center of top plate
plate_center_x = outer_width / 2;
plate_center_y = outer_depth / 2;

// Screw hole positions (on a square pattern centered on the plate)
// Corners of a square with diagonal = screw_pattern_diameter
// So side length = screw_pattern_diameter / sqrt(2)
screw_side = screw_pattern_diameter / sqrt(2);
screw_offset = screw_side / 2;

// Screw hole centers (relative to center of top plate)
screw1 = [plate_center_x - screw_offset, plate_center_y - screw_offset];
screw2 = [plate_center_x + screw_offset, plate_center_y - screw_offset];
screw3 = [plate_center_x + screw_offset, plate_center_y + screw_offset];
screw4 = [plate_center_x - screw_offset, plate_center_y + screw_offset];

// Top plate: 90x90mm, 2mm thick, lies on bed (z = 0 to 2)
top_plate = cube([outer_width, outer_depth, top_thickness], center = true);

// Wall extrusion: 4 walls, each 2.5mm thick, rising from top plate to z = 40
// Each wall is a rectangular prism offset from the outer edge

// Wall 1: front wall (positive Y face)
wall1 = translate([0, -outer_depth/2 - wall_thickness, 0])
         cube([outer_width, wall_thickness, wall_height], center = false);

// Wall 2: back wall (negative Y face)
wall2 = translate([0, outer_depth/2 + wall_thickness, 0])
         cube([outer_width, wall_thickness, wall_height], center = false);

// Wall 3: right wall (positive X face)
wall3 = translate([-outer_width/2 - wall_thickness, 0, 0])
         cube([wall_thickness, outer_depth, wall_height], center = false);

// Wall 4: left wall (negative X face)
wall4 = translate([outer_width/2 + wall_thickness, 0, 0])
         cube([wall_thickness, outer_depth, wall_height], center = false);

// Combine all walls
walls = union() {
    wall1;
    wall2;
    wall3;
    wall4;
}

// Combine top plate and walls to form the housing (top plate is at z = 0 to 2, walls from z = 0 to 40)
housing = union() {
    top_plate;
    walls;
}

// Now cut screw holes: 4.5mm holes through the top plate only (z = 0 to 2)
// Use cylinders that extend slightly beyond the top plate to ensure clean cut
screw_hole = cylinder(h = top_thickness + 1, r = screw_diameter / 2, center = true);

// Create 4 screw holes at the calculated positions
screw_holes = union() {
    translate([screw1[0], screw1[1], 0]) screw_hole;
    translate([screw2[0], screw2[1], 0]) screw_hole;
    translate([screw3[0], screw3[1], 0]) screw_hole;
    translate([screw4[0], screw4[1], 0]) screw_hole;
}

// Subtract screw holes from housing (only through top plate)
housing_with_screws = difference() {
    housing;
    screw_holes;
}

// Now cut notch in one wall (front wall, Y = -45mm side) for power cable
// Notch is 12mm wide, centered along wall, from z = 32 to z = 40 (8mm deep from open edge)
notch_length = notch_width; // 12mm wide (in X direction)
notch_height = notch_depth; // 8mm high (in Z direction)
notch_depth_from_top = wall_height - notch_depth; // z = 32 to 40

// Notch is centered on the front wall (Y = -45mm), so center in X is 0
notch_position_x = 0;
notch_position_y = -outer_depth/2 - wall_thickness; // Y position of front wall

notch_cuboid = translate([notch_position_x, notch_position_y, notch_depth_from_top])
               cube([notch_length, wall_thickness, notch_height], center = false);

// Subtract notch from housing
final_housing = difference() {
    housing_with_screws;
    notch_cuboid;
}

// Output final housing
final_housing;