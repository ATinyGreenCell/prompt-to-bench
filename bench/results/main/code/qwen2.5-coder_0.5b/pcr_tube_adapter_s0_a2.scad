// Define variables for dimensions
$size = 1.5; // Tube size in mL
$collar_diameter = 13; // Collar diameter in mm
$collar_thickness = 1.5; // Collar thickness in mm
$sleeve_outer_diameter = 10.8; // Sleeve outer diameter in mm
$sleeve_height = 21.5; // Sleeve height in mm

// Define variables for the collar and sleeve
$collar = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);
$sleeve = cylinder(center=(0, 0, $sleeve_height), radius=$sleeve_outer_diameter/2, length=$sleeve_height);

// Define variables for the collar and sleeve body
$collar_body = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);
$sleeve_body = cylinder(center=(0, 0, $sleeve_height), radius=$sleeve_outer_diameter/2, length=$sleeve_height);

// Define variables for the collar and sleeve slots
$collar_slots = [];
for (int i=0; i<$size; i++) {
    $collar_slot = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);
    $collar_slots.push($collar_slot);
}

// Define variables for the collar and sleeve teeth
$collar_teeth = [];
for (int i=0; i<$size; i++) {
    $collar_teeth.push(cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness));
}

// Define variables for the collar and sleeve grooves
$collar_groove = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);
}

// Define variables for the collar and sleeve body
$collar_body = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);

// Define variables for the collar and sleeve slots
$collar_slots = [];
for (int i=0; i<$size; i++) {
    $collar_slot = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);
    $collar_slots.push($collar_slot);
}

// Define variables for the collar and sleeve teeth
$collar_teeth = [];
for (int i=0; i<$size; i++) {
    $collar_teeth.push(cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness));
}

// Define variables for the collar and sleeve grooves
$collar_groove = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);
}

// Define variables for the collar and sleeve body
$collar_body = cylinder(center=(0, 0, 0), radius=$collar_diameter/2, length=$collar_thickness);

// Define variables for the collar and sleeve slots
$collar_slots = [];
for (int i=0; i<$size; i++) {
    $collar_slot = cylinder(center=(0, 0, 0), radius=$coll