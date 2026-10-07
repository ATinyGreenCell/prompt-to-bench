// Define dimensions
$fn = 64; // For curved shapes

// Part 1: Box
box(
    size=[70, 50, 30],
    center=true,
    chamfer=2,
    material="acrylic"
);

// Part 2: Lid
lid_height = 2;
lid_thickness = 1.5;
lid_width = 65.6 - 2 * lid_thickness; // Subtracting the thickness of the wall on both sides

// Create a plate with a rectangular lip
plate = rotate_extrude(
    radius=0.5,
    height=lid_height + 2 * lid_thickness,
    center=true,
    material="plastic"
);

// Create the rectangular lip
lip = translate([lid_width / 2, -lid_height / 2, 0]) *
    cylinder(
        r1=0.5,
        r2=0.5 + lid_thickness,
        h=lid_height,
        center=true,
        material="plastic"
    );

// Combine the plate and lip
lid = union([
    plate,
    lip
]);

// Place the lid on the +X side of the box
lid_position = [70, 25, 15];
lid = translate(lid_position) * lid;

// Print both parts together with a gap between them
difference() {
    box(
        size=[70, 50, 30],
        center=true,
        chamfer=2,
        material="acrylic"
    );
    lid;
}