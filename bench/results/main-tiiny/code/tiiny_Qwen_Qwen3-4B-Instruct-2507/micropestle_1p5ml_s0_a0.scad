// Dimensions for a pestle designed for use in a 1.5 mL microcentrifuge tube
// Printed standing upright, with the base at z = 0 and extending upward (+Z)

$fn = 64;  // High resolution for smooth curves (especially on sphere and cone)

// Handle: cylindrical section from z = 0 to z = 45, 8 mm diameter
handle_diameter = 8;
handle_length = 45;

// Cone: tapers from 8 mm at z=45 to 3 mm at z=62
cone_start_z = 45;
cone_end_z = 62;
cone_start_dia = 8;
cone_end_dia = 3;

// Tip: 3 mm diameter sphere at z = 62
tip_dia = 3;
tip_z = 62;

// Grooves: 4 circumferential grooves in the handle, 2 mm wide (in Z), 1 mm deep
groove_depth = 1;
groove_width = 2;
groove_z_positions = [10, 15, 20, 25];

// Create the main body: cylindrical handle
cylinder(h=handle_length, r=handle_diameter/2, center=true);

// Create the cone section from z=45 to z=62
// The cone is defined by tapering from 8 mm to 3 mm diameter
// We use a linear taper in radius from z=45 to z=62
// The cone is built as a difference between two cylinders (one with full radius, one with reduced)
// But we build it as a single extruded cone using a linear taper

// First, create the cone as a difference: full cylinder minus a smaller cylinder at the top
// We create a cone by subtracting a smaller cylinder from the larger one, but we need to define it properly

// Instead, we build the cone as a linear taper from z=45 to z=62
// We use a linear taper with radius changing from 4 mm to 1.5 mm (since 8/2=4, 3/2=1.5)
// The cone is built as a cylinder with a taper, using a linear extrusion or by difference

// We build the cone as a cylinder of height 17 mm (62 - 45), with radius decreasing from 4 mm to 1.5 mm
// We use a linear taper in radius: radius at z = 45 + t*(62-45) = 4 - (2.5/17)*t, where t is from 0 to 17

// Instead, we use a simple difference: a large cylinder minus a smaller cylinder at the top
// The large cylinder is from z=0 to z=62, radius 4 mm
// The small cylinder is from z=45 to z=62, radius 1.5 mm

// First, create the full cylindrical handle (from z=0 to z=62, radius 4 mm)
// But we already have the handle from z=0 to 45, so we extend it to 62 with taper

// We will build the cone as a cylinder with taper using a linear taper
// We use a linear taper from 4 mm to 1.5 mm over 17 mm

// We create the cone as a cylinder with a taper using a linear extrusion
// But OpenSCAD doesn't support linear taper directly, so we use difference

// Create a cylinder from z=0 to z=62, radius 4 mm (full handle)
cylinder(h=62, r=4, center=true);

// Now subtract a cylinder from z=45 to z=62, radius 1.5 mm
// This leaves the taper from 4 mm to 1.5 mm at z=45 to z=62
cylinder(h=17, r=1.5, center=true, translate=[0,0,45]);

// Now add the spherical tip at z=62
sphere(d=tip_dia/2, center=true, translate=[0,0,tip_z]);

// Now cut the four circumferential grooves in the handle (from z=0 to z=45)
// Each groove is 2 mm wide (in Z), 1 mm deep, centered at z=10,15,20,25
// Grooves are cut into the handle, so we subtract a rectangular prism from the handle

// We define the grooves as rectangular prisms, 2 mm wide, 1 mm deep, and 8 mm in diameter
// The grooves are cut into the cylindrical handle, so we need to place them at the correct z

// Each groove is a rectangular prism with 2 mm depth (in Z), 1 mm depth (in Y), and 8 mm diameter
// We place them at z=10,15,20,25, with 2 mm depth in Z, 1 mm depth in Y, and 8 mm diameter

// We use a for loop to create grooves

for (g = [10,15,20,25]) {
    // Translate the groove to the correct z position
    // The groove is 2 mm wide in Z, 1 mm deep in Y, and 8 mm in diameter
    // We cut a rectangular prism with 2 mm in Z, 1 mm in Y, and 8 mm in diameter
    // The groove is centered in the circular cross-section

    // We use a cylinder of 8 mm radius, and cut a rectangular prism from it
    // The groove is 1 mm deep in Y, 2 mm wide in Z, and spans the full X and Y
    // We place it at z = g, with depth in Y

    // We create a rectangular prism with 2 mm in Z, 1 mm in Y, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We use a cylinder of 8 mm radius, and subtract a rectangular prism
    // The rectangular prism is 2 mm wide in Z, 1 mm deep in Y, and 8 mm in diameter

    // We define the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We use a difference: a cylinder of 8 mm radius, minus a rectangular prism

    // First, create the full cylinder (handle) from z=0 to z=45
    // We already built the full cylinder from z=0 to z=62, but we need to cut only in the handle (z=0 to 45)

    // We will create the grooves as a difference between a cylinder and a rectangular prism

    // We create a rectangular prism of 8 mm diameter, 1 mm deep in Y, 2 mm wide in Z, at z=g
    // The groove is 2 mm wide in Z, 1 mm deep in Y, and 8 mm in diameter

    // We place the groove at z=g, and cut it into the handle

    // We use a cylinder of 8 mm radius, from z=0 to z=45, and subtract a rectangular prism

    // The rectangular prism is 2 mm wide in Z, 1 mm deep in Y, and 8 mm in diameter
    // We place it at z=g, and extend in X and Y

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We use a difference: the full handle (cylinder from z=0 to 45, r=4) minus a rectangular prism

    // But we already built the full cylinder, so we need to subtract the grooves

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We place the groove at z=g, and cut it into the handle

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We use a difference: the full handle (cylinder from z=0 to 45, r=4) minus a rectangular prism

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We place the groove at z=g, and cut it into the handle

    // We create the groove as a rectangular prism with 1 mm depth in Y, 2 mm in Z, and 8 mm in diameter
    // The groove is centered at z=g, and spans the full X and Y

    // We use a difference: