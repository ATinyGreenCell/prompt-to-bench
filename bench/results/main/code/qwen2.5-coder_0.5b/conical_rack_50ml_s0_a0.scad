// Define variables for dimensions
$X = 130; // Length of the plate in X (mm)
$Y = 90; // Length of the plate in Y (mm)
$Z = 70; // Height of the rack (mm)

// Create a flat plate with six through-holes
cube($X, $Y, $Z);

// Define the dimensions of each tube
$tube_diameter = 30.5; // Diameter of each tube in mm
$num_rows = 2;
$num_columns = 3;

// Define the center-to-centre distance for the tubes
$center_to_centre_distance = 4;

// Create a list of through-holes
list_through_holes = [];
for (int i = 0; i < num_rows; i++) {
    for (int j = 0; j < num_columns; j++) {
        list_through_holes.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z - $i * $num_columns));
    }
}

// Define the dimensions of each slot
slot_diameter = 130 / 2; // Diameter of each slot in mm
$slots_count = num_rows * num_columns;

// Create a list of slots
list_slots = [];
for (int i = 0; i < slots_count; i++) {
    list_slots.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each tooth
tooth_diameter = 130 / 2; // Diameter of each tooth in mm
$tooth_count = num_rows * num_columns;

// Create a list of teeth
list_teeth = [];
for (int i = 0; i < tooth_count; i++) {
    list_teeth.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each groove
groove_diameter = 130 / 2; // Diameter of each groove in mm
$groove_count = num_rows * num_columns;

// Create a list of grooves
list_grooves = [];
for (int i = 0; i < groove_count; i++) {
    list_grooves.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each hole
hole_diameter = 130 / 2; // Diameter of each hole in mm
$holes_count = num_rows * num_columns;

// Create a list of holes
list_holes = [];
for (int i = 0; i < holes_count; i++) {
    list_holes.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each slot
slot_diameter = 130 / 2; // Diameter of each slot in mm
$slots_count = num_rows * num_columns;

// Create a list of slots
list_slots = [];
for (int i = 0; i < slots_count; i++) {
    list_slots.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each tooth
tooth_diameter = 130 / 2; // Diameter of each tooth in mm
$tooth_count = num_rows * num_columns;

// Create a list of teeth
list_teeth = [];
for (int i = 0; i < tooth_count; i++) {
    list_teeth.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each groove
groove_diameter = 130 / 2; // Diameter of each groove in mm
$groove_count = num_rows * num_columns;

// Create a list of grooves
list_grooves = [];
for (int i = 0; i < groove_count; i++) {
    list_grooves.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each hole
hole_diameter = 130 / 2; // Diameter of each hole in mm
$holes_count = num_rows * num_columns;

// Create a list of holes
list_holes = [];
for (int i = 0; i < holes_count; i++) {
    list_holes.append(cube($X - $center_to_centre_distance, $Y - $center_to_centre_distance, $Z + i * $num_columns));
}

// Define the dimensions of each slot
slot_diameter = 130 / 2; // Diameter of each slot in mm
$slots_count = num_rows * num_columns;

// Create a list of slots