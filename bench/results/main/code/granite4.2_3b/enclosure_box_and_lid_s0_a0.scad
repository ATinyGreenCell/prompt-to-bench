// Dimensions in millimetres
box_outer_x = 70;      // X size of the box (outer dimension)
box_outer_y = 50;      // Y size of the box (outer dimension)
box_outer_z = 30;      // Z height of the box (overall)
box_wall_thickness = 2; // Wall thickness for the box
box_floor_thickness = 2; // Floor thickness for the box
lid_plate_thickness = 2; // Thickness of the lid plate
lid_lip_height = 4;      // Height of the lip on top of the lid
lid_lip_outer_x = 65.6;  // Outer X size of the lid lip (centered)
lid_lip_outer_y = 45.6;  // Outer Y size of the lid lip (centered)
gap_between_parts = 10;   // Gap between box and lid on the bed
clearance_per_side = 0.2; // Clearance from edge for proper fit

// Build the box part
box_part = difference(
    translate([0, 0, 0]) * cube([box_outer_x, box_outer_y, box_wall_thickness]),
    translate([0, 0, box_wall_thickness]) * cube([box_outer_x - 2*box_wall_thickness, box_outer_y - 2*box_wall_thickness, lid_lip_height])
);

// Build the lid part (plate with lip)
lid_part = union(
    // Plate on the bed (z=0 to z=lid_plate_thickness)
    translate([0, 0, 0]) * cube([lid_lip_outer_x, lid_lip_outer_y, lid_plate_thickness]),

    // Lip extending upward from the plate edge
    translate([lid_lip_outer_x/2, lid_lip_outer_y/2, lid_plate_thickness]) * cube([
        lid_lip_height,
        lid_lip_height,
        lid_plate_thickness - lid_plate_thickness  // thickness is lid_plate_thickness along Z? Clarify: lip is a wall of height lid_lip_height and thickness lid_plate_thickness in X/Y.
    ])
);
// Correction: The lip should be a rectangular extrusion with thickness lid_plate_thickness (in XY) and height lid_lip_height.
// We model the lip as a rectangular prism extending from the plate edge upward, centered on the plate's outer edge.
lid_lip = translate([lid_lip_outer_x/2 - lid_plate_thickness/2, lid_lip_outer_y/2 - lid_plate_thickness/2, 0]) * cube([
    lid_plate_thickness,
    lid_plate_thickness,
    lid_lip_height
]);
// Actually, the lip is a wall of thickness lid_plate_thickness (in XY) and height lid_lip_height. It sits on top of the plate edge.
// So we define it as: from z = lid_plate_thickness to z = lid_plate_thickness + lid_lip_height? No, better: the lip is a rectangular prism that starts at the plate's outer edge (z=lid_plate_thickness) and extends upward by lid_lip_height.
// But the plate thickness is lid_plate_thickness in Z direction from z=0 to z=lid_plate_thickness? Actually, the plate lies on the bed: its bottom face at z=0, top face at z = lid_plate_thickness.
// The lip should be attached along the outer edge of the plate (at z = lid_plate_thickness), extending upward by lid_lip_height.
// So we define the lip as a rectangular prism with dimensions: width = lid_plate_thickness, height = lid_plate_thickness, depth = lid_lip_height? Wait, in 3D, a rectangular prism defined by cube([w, h, d]) has w along X, h along Y, d along Z.
// We want the lip to be centered on the plate's outer edge (which is at x = lid_lip_outer_x/2, y = lid_lip_outer_y/2) and extend in +Z direction by lid_lip_height, with XY thickness lid_plate_thickness.
// So we can define the lip as:
lid_lip_prism = translate([lid_lip_outer_x/2 - lid_plate_thickness/2, lid_lip_outer_y/2 - lid_plate_thickness/2, 0]) * cube([
    lid_plate_thickness,   // X extent (along plate edge)
    lid_plate_thickness,   // Y extent (along plate edge)
    lid_lip_height         // Z extent (upward from plate top)
]);
// But note: the plate's outer edge is at x = lid_lip_outer_x/2, y = lid_lip_outer_y/2. The lip should be centered on that edge, so its center in XY is exactly at that point.
// So we shift by half of lid_plate_thickness in both X and Y directions from the plate's outer corner? Actually, the plate extends to x = lid_lip_outer_x/2, y = lid_lip_outer_y/2 (the outer edge). The lip is centered on that edge, meaning its center line runs along the edge direction.
// We define the lip as a rectangular prism whose XY cross-section is a square of side lid_plate_thickness, centered at (lid_lip_outer_x/2, lid_lip_outer_y/2) in XY plane, and extending +Z by lid_lip_height.
// So we can use: translate([lid_lip_outer_x/2 - lid_plate_thickness/2, lid_lip_outer_y/2 - lid_plate_thickness/2, 0]) * cube([lid_plate_thickness, lid_plate_thickness, lid_lip_height]).
// This places the center of the lip at (lid_lip_outer_x/2, lid_lip_outer_y/2) in XY, and its extent along X and Y is lid_plate_thickness on each side.
// The top face of the plate is at z = lid_plate_thickness, so the lip starts there and goes up to z = lid_plate_thickness + lid_lip_height? But we want the lip to be exactly attached: the plate's top edge (at z=lid_plate_thickness) should meet the bottom of the lip.
// So if we define the lip prism with cube([lid_plate_thickness, lid_plate_thickness, lid_lip_height]), and translate it so that its bottom face is at z = lid_plate_thickness, then:
//   - The prism's Z range goes from z = lid_plate_thickness to z = lid_plate_thickness + lid_lip_height.
// But we placed the translation with [0] in Z? Actually, cube([w, h, d]) creates a box centered at origin if not translated; but translate moves it so that its faces are at absolute coordinates.
// Better: define the lip as:
lid_lip = translate([lid_lip_outer_x/2 - lid_plate_thickness/2, lid_lip_outer_y/2 - lid_plate_thickness/2, 0]) * cube([
    lid_plate_thickness,   // X half-size? No, cube expects full dimensions.
]);
// Actually, in OpenSCAD, cube([w, h, d]) creates a box with side lengths w, h, d centered at the origin if no translation is applied. But when we translate, it's absolute coordinates for the faces.
// To avoid confusion, let's define the lip as:
lid_lip = translate([
    lid_lip_outer_x/2 - lid_plate_thickness/2,
    lid_lip_outer_y/2 - lid_plate_thickness/2,
    0
]) * cube([
    lid_plate_thickness,   // X half-size? No, we want full width = lid_plate_thickness in each direction.
]);
// This is ambiguous. Standard: cube([w, h, d]) creates a box with side lengths w, h, d centered at the origin of the translated coordinate system. So if we translate by [dx, dy, dz], then the faces are at dx±w/2 etc.
// We want the lip to have XY extent lid_plate_thickness in each direction (so total width = lid_plate_thickness), and Z extent = lid_lip_height.
// So define:
lid_lip = translate([
    lid_lip_outer_x/2 - lid_plate_thickness/2,
    lid_lip_outer_y/2 - lid_plate_thickness/2,
    0
]) * cube([
    lid_plate_thickness,   // full width in X (so half-size is lid_plate_thickness