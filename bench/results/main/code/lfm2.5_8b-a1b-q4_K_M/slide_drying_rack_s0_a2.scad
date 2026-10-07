// Base dimensions in mm
X = 90; Y = 45; Z = 20;

// Slot parameters
slot_width_mm = 1.6; slot_length_mm = 77; slot_depth_mm = 10; num_slots = 10; spacing_mm = 3.5;

// Solid base block
base_block = cube(X, Y, Z);

// Shape of a single slot (extruded depth into the block)
slot_shape = linear_extrude(
    cube([0, slot_length_mm, 0], [0, slot_width_mm, 0], [0, -slot_depth_mm, 0]),
    z_range(0, -1);
);

// Create array of 10 slots centred on the origin in X and Y
slots = [];
for (i = 0; i < num_slots; i++) {
    y_center = -((i + 0.5) * spacing_mm);
    slots.push(difference(base_block, slot_shape));
}

// Render the resulting solid
$fn = 64;