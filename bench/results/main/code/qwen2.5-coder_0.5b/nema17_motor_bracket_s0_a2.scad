// Define variables for dimensions
$fn = 64; // Set the number of faces to 64 for curved shapes

// Create the base plate
cube(x=-25, y=0, z=5, color=color(1, 0.8, 0.8));

// Create the vertical motor plate
cube(x=-25, y=0, z=50, color=color(1, 0.8, 0.8));

// Define the through-holes for the motor's centring boss
translate((x=-17, y=30)) cube(x=17, y=30);

// Define the M3 screws on a 31 mm square pattern centred on the boss hole
cube(x=-25, y=0, z=50, color=color(1, 0.8, 0.8));

// Define the triangular gussets
translate((x=-25, y=5)) cube(x=20, y=5, z=5);

// Define the through-holes for the M3 screws on the boss hole
cube(x=-25, y=5, z=50, color=color(1, 0.8, 0.8));

// Define the triangular gussets
translate((x=-25, y=5)) cube(x=20, y=5, z=5);

// Define the through-holes for the M3 screws on the boss hole
cube(x=-25, y=5) cube(x=20, y=5, z=5);