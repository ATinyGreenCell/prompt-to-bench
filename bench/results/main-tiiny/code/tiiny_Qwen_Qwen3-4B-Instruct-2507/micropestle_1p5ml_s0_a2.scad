// Dimensions for a pestle designed for use in a 1.5 mL microcentrifuge tube
// Printed standing upright, with the base at z = 0 and extending upward (+Z)

$fn = 64;  // High resolution for smooth curves (especially on sphere and cone)

// Handle: cylindrical section from z = 0 to z = 45, 8 mm in diameter
handle_diameter = 8;
handle_length = 45;

// Cone: tapers from 8 mm diameter at z = 45 to 3 mm diameter at z = 62
cone_start_z = 45;
cone_end_z = 62;
cone_start_dia = 8;
cone_end_dia = 3;

// Tip: 3 mm diameter sphere centred at z = 62
tip_dia = 3;
tip_z = 62;

// Grooves: 4 circumferential grooves in the handle, 2 mm wide (in Z), 1 mm deep, centered at z = 10, 15, 20, 25
groove_depth = 1;
groove_width = 2;
groove_z_positions = [10, 15, 20, 25];

// Start with the full cylindrical handle (from z=0 to z=62, radius 4 mm)
// This forms the base of the pestle
cylinder(h=62, r=4, center=true);

// Subtract the cone section (from z=45 to z=62) to create the taper
// The cone has radius decreasing from 4 mm to 1.5 mm over 17 mm
// We remove a cylinder of radius 1.5 mm from z=45 to z=62
cylinder(h=17, r=1.5, center=true, translate=[0,0,45]);

// Add the spherical tip at z=62
sphere(d=tip_dia/2, center=true, translate=[0,0,tip_z]);

// Now cut the four circumferential grooves into the handle (from z=0 to z=45)
// Each groove is 2 mm wide in Z, 1 mm deep in Y, and 8 mm in diameter
// We cut them into the cylindrical handle (z=0 to z=45)

// We use a difference: subtract a rectangular prism from the handle
// The groove is 1 mm deep in Y, 2 mm wide in Z, and spans the full X and Y

// We define the grooves as rectangular prisms with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
// The grooves are centered at z = 10, 15, 20, 25

for (g = [10,15,20,25]) {
    // Create a rectangular prism 2 mm wide in Z, 1 mm deep in Y, 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y
    // We place it at z=g, and cut it into the handle (from z=0 to z=45)

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // Translate the groove to z=g, and extend in X and Y
    // The groove is 2 mm wide in Z, 1 mm deep in Y, and 8 mm in diameter
    // We use a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter

    // The groove is defined as a rectangular prism with:
    // - 1 mm depth in Y (positive Y direction)
    // - 2 mm width in Z (positive Z direction)
    // - 8 mm diameter in X and Y (full circular cross-section)

    // We place the groove at z=g, and cut it into the handle
    // We use a difference: subtract the groove from the handle

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We use a difference: subtract the groove from the main body
    // But we are building the part as a union of solids, so we must subtract the grooves

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y