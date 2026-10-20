// Dimensions
box_x = 70;
box_y = 50;
box_z = 30;
wall_thickness = 2;
floor_thickness = 2;
lid_plate_thickness = 2;
lip_thickness = 1.5;
lip_height = 4;
lip_outer_x = 65.6;
lip_outer_y = 45.6;
gap = 10;

// Box: outer dimensions 70 x 50 x 30 mm, 2 mm walls, 2 mm floor, open top
// Centered on origin in X and Y
box = difference() {
    // Outer box
    cube([box_x, box_y, box_z], center = true);
    // Inner cavity (removing material for walls and floor)
    translate([0, 0, -floor_thickness]) {
        cube([box_x - 2 * wall_thickness, box_y - 2 * wall_thickness, box_z - floor_thickness], center = true);
    }
};

// Lid: plate 70 x 50 x 2 mm, placed on bed (z = 0), with lip on top
// Lip is 1.5 mm thick, 4 mm tall, outer size 65.6 x 45.6 mm, centered on plate
// Lid is printed upside down, so lip is on top (positive Z) when placed on bed

// Plate (base of lid)
lid_plate = cube([box_x, box_y, lid_plate_thickness], center = false);

// Lip (a rectangular frame on top of the plate)
// Create a rectangular frame (hollow) at the top of the plate
lip_outer = [lip_outer_x, lip_outer_y];
lip_inner = [lip_outer_x - 2 * lip_thickness, lip_outer_y - 2 * lip_thickness];

// Lip base (a rectangular frame at the top of the plate)
lip_base = difference() {
    // Outer rectangle (top face of lip)
    translate([0, 0, lid_plate_thickness]) {
        cube([lip_outer_x, lip_outer_y, lip_thickness], center = false);
    }
    // Inner hole (to make it a frame)
    translate([0, 0, lid_plate_thickness]) {
        cube([lip_inner[0], lip_inner[1], lip_thickness + 0.1], center = false);
    }
};

// Lip walls (vertical walls on the inner edge of the lip)
// We need to add vertical walls on the inside of the lip frame
// These walls go from the top of the plate to the top of the lip
lip_wall = difference() {
    // Outer wall (a solid block from the top of the plate to the top of the lip)
    translate([0, 0, lid_plate_thickness]) {
        cube([lip_outer_x, lip_outer_y, lip_height], center = false);
    }
    // Inner hole (to make it a frame)
    translate([0, 0, lid_plate_thickness]) {
        cube([lip_inner[0], lip_inner[1], lip_height + 0.1], center = false);
    }
};

// Combine lid plate and lip walls into a single lid
lid = union() {
    lid_plate;
    lip_wall;
}

// Position box and lid side by side with a 10 mm gap
// Box centered at origin (X = 0)
// Lid placed on +X side (X = box_x/2 + gap + lid_x/2)
// Both rest on the bed (z = 0)

// Box at origin
box_positioned = translate([0, 0, 0]) box;

// Lid placed on +X side with gap
lid_positioned = translate([
    box_x / 2 + gap + box_x / 2,
    0,
    0
]) lid;

// Render both parts
union() {
    box_positioned;
    lid_positioned;
}