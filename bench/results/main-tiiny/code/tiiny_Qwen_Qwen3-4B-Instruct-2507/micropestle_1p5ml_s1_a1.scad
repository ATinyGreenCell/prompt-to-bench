// Dimensions and parameters for a pestle designed for use in a 1.5 mL microcentrifuge tube
// Printed standing upright, with the base at z = 0 and extending upward in +Z
$fn = 64;  // High resolution for smooth curves (especially for sphere and cone)

// Key dimensions in millimeters
handle_diameter = 8;           // Diameter of cylindrical handle
handle_length = 45;           // Height of cylindrical handle (from z=0 to z=45)
cone_start_z = 45;            // Start of cone at z=45
cone_end_z = 62;             // End of cone at z=62
cone_start_dia = 8;          // Diameter at start of cone (z=45)
cone_end_dia = 3;            // Diameter at end of cone (z=62)
tip_dia = 3;                 // Diameter of spherical tip at z=62
groove_depth = 1;            // Depth of each groove (in Z)
groove_width = 2;            // Width of each groove (in X or Y)
groove_positions_z = [10, 15, 20, 25]; // Z positions where grooves are centered

// Create the cylindrical handle from z=0 to z=45
handle = cube([handle_diameter, handle_diameter, handle_length], center=true);

// Create the cone from z=45 to z=62
// The cone tapers from 8mm to 3mm diameter over 17mm
// We build it as a difference between two cylinders:
// - A large cylinder of diameter 8mm from z=45 to z=62
// - A small cylinder of diameter 3mm from z=45 to z=62, centered at the same point

// First, create the large cylinder (diameter 8mm) from z=45 to z=62
cylinder_large = cylinder(d=handle_diameter, h=cone_end_z - cone_start_z, center=true, $fn=64);

// Second, create the small cylinder (diameter 3mm) from z=45 to z=62
cylinder_small = cylinder(d=cone_end_dia, h=cone_end_z - cone_start_z, center=true, $fn=64);

// The cone is the large cylinder minus the small cylinder (tapered)
// This gives a conical shape from 8mm to 3mm in diameter
cone = difference() {
    cylinder_large;
    cylinder_small;
};

// Create the spherical tip at z=62, with diameter 3mm
// Centered at (0,0,62), radius 1.5mm
tip = sphere(r=tip_dia/2, center=true);

// Now, cut four circumferential grooves into the handle (from z=10 to 25)
// Each groove is 2mm wide (in X), 1mm deep (in Y), 1mm in Z
// We cut them into the handle, so we use difference

// We will create the grooves as rectangular prisms, centered at z = groove_position
// Each groove is 2mm wide (in X), 1mm deep (in Y), 1mm in Z
// The groove is centered at z = groove_position, and extends from z = groove_position to groove_position+1

// First, create the base handle (full cylinder)
base_handle = cube([handle_diameter, handle_diameter, handle_length], center=true);

// Now, create grooves at z=10,15,20,25
// Each groove is a 2x1x1 block, centered at (0,0,g), and extending from z=g to g+1
// But we need to ensure the groove is cut into the handle, so we use difference

// We will create a list of grooves and subtract them from the base handle
// Each groove is a cube of 2x1x1, centered at (0,0,g), and placed at z=g to g+1

// However, to avoid coplanar faces, we extend the groove slightly beyond the face
// We will create a groove as a cube with a small offset in Z

// Define the grooves
for (g = [10,15,20,25]) {
    // Create a rectangular block: 2mm wide (X), 1mm deep (Y), 1mm in Z
    // Centered at (0,0,g), so it extends from z=g to g+1
    // We place it so that it cuts into the handle
    // The groove is 1mm deep in Y, 2mm wide in X, 1mm in Z
    groove = cube([groove_width, groove_depth, 1], center=true);
    // Translate to position: (0,0,g)
    // But we need to shift it so that the groove is centered in the handle
    // The handle is symmetric, so we place the groove at z=g, centered in Y and X
    // The groove will be centered at (0,0,g)
    // But we need to ensure it's within the handle
    // We will subtract this groove from the base handle
    // We do this in a difference, so we create a new solid
}

// We will build the final part as:
// 1. The base handle
// 2. The cone (from z=45 to 62)
// 3. The tip (at z=62)
// 4. The grooves (cut into the handle)

// First, create the full handle (from z=0 to 45)
handle_base = cube([handle_diameter, handle_diameter, handle_length], center=true);

// Now, create the grooves as separate blocks and subtract them
// We will create a new solid that is the handle minus the grooves

// Create a list of grooves
grooves_list = [];

for (g = [10,15,20,25]) {
    // Each groove is a 2x1x1 block, centered at (0,0,g)
    // But we need to place it so that it cuts into the handle
    // The groove is 1mm deep in Y, 2mm wide in X, 1mm in Z
    // We place it at z = g, and extend from z=g to g+1
    // To avoid coplanar faces, we extend the groove by 0.1mm in Z
    // So the groove is from z=g to g+1.1
    // But we only need to cut into the handle, so we place it at z=g
    // We create a cube of 2x1x1.1, centered at (0,0,g)
    // But we need to shift it so that it is centered in the handle
    // The groove is centered at (0,0,g), so we place it at (0,0,g)
    // We will create a cube with dimensions [2,1,1.1] and center at (0,0,g)
    // But we need to ensure it is within the handle
    // The handle is from z=0 to 45, so g=10,15,20,25 are all within
    groove = cube([groove_width, groove_depth, 1.1], center=true);
    // Translate to (0,0,g)
    grooves_list.append(translate([0, 0, g]) * groove);
}

// Now, create the final pestle as:
// 1. The base handle (cylinder)
// 2. The cone (from z=45 to 62)
// 3. The tip (sphere at z=62)
// 4. The grooves cut into the handle

// First, build the handle with grooves cut
// We start with the full handle, then subtract the grooves
// But we must ensure the grooves are only in the handle (z=0 to 45)

// Create the full handle
handle_with_grooves = handle_base;

// Subtract each groove
for (g = [10,15,20,25]) {
    handle_with_grooves = difference() {
        handle_with_grooves;
        translate([0, 0, g]) * cube([groove_width, groove_depth, 1.1], center=true);
    };
}

// Now, build the cone and tip on top
// The cone is from z=45 to z=62, tapering from 8mm to 3mm
// We build it as a difference between two cylinders

// First, create the large cylinder (8mm diameter) from z=45 to 62
cylinder_large = cylinder(d=handle_diameter, h=cone_end_z - cone_start_z, center=true, $fn=64);

// Second, create the small cylinder (3mm diameter) from z=45 to 62
cylinder_small = cylinder(d=cone_end_dia, h=cone_end_z - cone_start_z, center=true, $fn=64);

// The cone is the large minus the small
cone = difference() {
    cylinder_large;
    cylinder_small;
};

// Now, place the cone on top of the handle
// The cone is centered at (0,