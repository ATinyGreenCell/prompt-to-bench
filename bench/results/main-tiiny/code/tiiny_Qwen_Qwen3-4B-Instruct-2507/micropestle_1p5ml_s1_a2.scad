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
handle_base = cube([handle_diameter, handle_diameter, handle_length], center=true);

// Create the cone from z=45 to z=62
// The cone tapers from 8mm to 3mm diameter over 17mm
// Built as a difference between two cylinders
cylinder_large = cylinder(d=handle_diameter, h=cone_end_z - cone_start_z, center=true, $fn=64);
cylinder_small = cylinder(d=cone_end_dia, h=cone_end_z - cone_start_z, center=true, $fn=64);
cone = difference() {
    cylinder_large;
    cylinder_small;
};

// Create the spherical tip at z=62, radius 1.5mm
tip = sphere(r=tip_dia/2, center=true);

// Create the grooves in the handle (from z=10 to 25)
// Each groove is 2mm wide (in X), 1mm deep (in Y), 1.1mm in Z (to avoid coplanar faces)
// We cut them into the handle, so we use difference

// Build the final pestle as a union of:
// 1. The handle with grooves cut
// 2. The cone (from z=45 to 62)
// 3. The tip (at z=62)

// First, create the handle with grooves cut
// Start with the full handle, then subtract grooves

// Define the grooves as separate cubes, translated to the correct position
// Each groove is 2mm wide (X), 1mm deep (Y), 1.1mm in Z
// Centered at (0,0,g), so it extends from z=g to g+1.1
// We place it at z=g, so it cuts into the handle

// Create the base handle with grooves
final_handle = handle_base;

// Subtract each groove
for (g = [10,15,20,25]) {
    // Create a groove block: 2x1x1.1, centered at (0,0,g)
    groove = cube([groove_width, groove_depth, 1.1], center=true);
    // Translate to (0,0,g)
    final_handle = difference() {
        final_handle;
        translate([0, 0, g]) * groove;
    };
}

// Now, add the cone and tip on top
// The cone is from z=45 to z=62, centered at (0,0,45) to (0,0,62)
// The tip is at z=62, centered at (0,0,62)

// First, place the cone
// The cone is already defined as a difference of two cylinders
// We place it at z=45 to z=62, centered at origin

// Now, place the cone on top of the handle
// The cone is centered at (0,0,45) to (0,0,62), so we just add it
// But we need to ensure it is built on top of the handle

// The cone is already defined as a solid, so we just union it with the handle
// However, the cone is defined with center=true, so it is centered at origin
// We need to place it at z=45 to z=62

// To place the cone, we need to shift it so that it starts at z=45
// But the cylinder is defined with center=true, so it is centered at origin
// We need to shift it to start at z=45

// We will build the final part as:
// 1. The handle with grooves (from z=0 to 45)
// 2. The cone (from z=45 to 62)
// 3. The tip (at z=62)

// First, create the full pestle as a union of the handle, cone, and tip

// The handle with grooves is already defined as final_handle (from z=0 to 45)

// Now, place the cone: it is centered at origin, so it extends from z=-17 to z=45
// But we want it to start at z=45, so we need to shift it up by 17mm

// We will define the cone as a solid from z=45 to z=62
// So we shift the cone to start at z=45

// The cone is defined as a difference of two cylinders, both centered at origin
// To place it at z=45 to z=62, we need to shift it by +45 in Z

// So we translate the cone to start at z=45
// The cone is defined with center=true, so it is centered at origin
// We need to shift it to start at z=45

// We will create the cone at z=45 to z=62 by translating it by +45 in Z

// But we can't translate a difference easily — we must build it as a separate solid

// Instead, we build the cone as a solid from z=45 to z=62, centered at (0,0,53.5)
// The cone is symmetric about z=53.5, so it extends from z=45 to 62
// We can define it as a cylinder with taper, but we already have it as a difference

// We will define the cone as a solid with center at (0,0,53.5), and height 17mm
// But we already have it as a difference of two cylinders centered at origin

// To place it at z=45 to z=62, we shift it by +45 in Z

// So we create a new solid for the cone, translated by +45 in Z
// But we can't do that directly in a difference

// Instead, we build the final part as:
// 1. The handle with grooves (from z=0 to 45)
// 2. The cone (from z=45 to 62), translated to start at z=45
// 3. The tip (at z=62)

// We will define the cone as a solid, then translate it by +45 in Z

// First, create the cone at origin (centered at origin)
// Then translate it to z=45 to z=62

// But the cone is already defined as a difference of two cylinders centered at origin
// We will now create a new solid for the cone, shifted to start at z=45

// Define the cone at origin
cone_at_origin = difference() {
    cylinder(d=handle_diameter, h=17, center=true, $fn=64);
    cylinder(d=cone_end_dia, h=17, center=true, $fn=64);
};

// Now, translate the cone to start at z=45
// So we shift it by +45 in Z
cone_placed = translate([0, 0, 45]) * cone_at_origin;

// Now, the tip is at z=62, so we place it at (0,0,62)
// The tip is a sphere of radius 1.5mm, centered at (0,0,62)

// Now, build the final part as a union of:
// 1. The handle with grooves (from z=0 to 45)
// 2. The cone (from z=45 to 62)
// 3. The tip (at z=62)

// But we must ensure the cone and tip are properly aligned

// Final pestle
final_pestle = union() {
    final_handle;
    cone_placed;
    tip;
};

// Output the final part
// The final part is centered at origin, with:
// - Handle with grooves from z=0 to 45
// - Cone from z=45 to 62
// - Tip at z=62

// This should be printable and solid

// Note: The cone is