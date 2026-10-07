// Define the dimensions of the buffer tank
var X = 120; // in mm
var Y = 70; // in mm
var Z = 40; // in mm

// Define the dimensions of the platform for the gel tray
var platform_length = 60; // in mm
var platform_height = 10; // in mm

// Define the dimensions of the buffer chambers
var chamber_width = 2; // in mm

// Define the position of the platform
var platform_position = [platform_length / 2, platform_height / 2, 30]; // in mm

// Define the position of each buffer chamber
var chamber_position_x = [platform_length - chamber_width, platform_height / 2, 30];
var chamber_position_y = [platform_length / 2, platform_height + chamber_width, 30];

// Define the dimensions of the electrodes
var electrode_diameter = 2; // in mm

// Define the position of each electrode
var electrode_position_x = [chamber_position_x[0], chamber_position_y[0] - electrode_diameter / 2];
var electrode_position_y = [chamber_position_x[1], chamber_position_y[1] + electrode_diameter / 2];

// Define the dimensions of the grooves
var groove_width = 2; // in mm

// Define the position of each groove
var groove_position_x = [chamber_position_x[0], chamber_position_y[0]];
var groove_position_y = [chamber_position_y[1] - groove_width / 2];

// Define the dimensions of the slots
var slot_width = 2; // in mm

// Define the position of each slot
var slot_position_x = [chamber_position_x[0], chamber_position_y[0]];
var slot_position_y = [chamber_position_y[1] + slot_width / 2];

// Define the dimensions of the teeth
var tooth_diameter = 2; // in mm

// Define the position of each tooth
var tooth_position_x = [chamber_position_x[0], chamber_position_y[0]];
var tooth_position_y = [chamber_position_y[1] - tooth_diameter / 2];

// Define the dimensions of the holes
var hole_diameter = 0.01; // in mm

// Define the position of each hole
var hole_position_x = [chamber_position_x[0], chamber_position_y[0]];
var hole_position_y = [chamber_position_y[1] - hole_diameter / 2];

// Define the dimensions of the grooves
var groove_width = 2; // in mm

// Define the position of each groove
var groove_position_x = [chamber_position_x[0], chamber_position_y[0]];
var groove_position_y = [chamber_position_y[1] - groove_width / 2];

// Define the dimensions of the slots
var slot_width = 2; // in mm

// Define the position of each slot
var slot_position_x = [chamber_position_x[0], chamber_position_y[0]];
var slot_position_y = [chamber_position_y[1] + slot_width / 2];

// Define the dimensions of the teeth
var tooth_diameter = 2; // in mm

// Define the position of each tooth
var tooth_position_x = [chamber_position_x[0], chamber_position_y[0]];
var tooth_position_y = [chamber_position_y[1] - tooth_diameter / 2];

// Define the dimensions of the holes
var hole_diameter = 0.01; // in mm

// Define the position of each hole
var hole_position_x = [chamber_position_x[0], chamber_position_y[0]];
var hole_position_y = [chamber_position_y[1] - hole_diameter / 2];

// Define the dimensions of the grooves
var groove_width = 2; // in mm

// Define the position of each groove
var groove_position_x = [chamber_position_x[0], chamber_position_y[0]];