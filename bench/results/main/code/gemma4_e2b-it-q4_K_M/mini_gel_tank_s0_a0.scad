// Buffer Tank Design for Mini Horizontal Gel-Electrophoresis Box

// --- Dimensions ---
X_outer = 120;    // Outer length of the tank (mm)
Y_outer = 70;     // Outer width of the tank (mm)
Z_outer = 40;     // Outer height of the tank (mm)
Wall_thickness = 3; // Thickness of the walls (mm)
Floor_thickness = 3; // Thickness of the floor (mm)

Platform_length = 60;  // Length of the central platform in X (mm)
Platform_height_above_inner_floor = 10; // Height of the platform above the inner floor (mm)
Inner_Y = Y_outer - 2 * Wall_thickness; // Inner width of the tank (mm)
Inner_X = X_outer - 2 * Wall_thickness; // Inner length of the tank (mm)

Hole_diameter = 2; // Diameter of the electrode holes (mm)
Hole_z = 30;      // Z-level for the electrode holes (mm)

// --- Calculations based on dimensions ---
Inner_Z_floor = Floor_thickness; // The floor is at z=0, so inner floor is at z=3.
Platform_Z = Inner_Z_floor + Platform_height_above_inner_floor; // Z-level of the platform top (3 + 10 = 13)

// --- Main Tank Body ---
module tank_body() {
    // Outer dimensions: 120x70x40
    cube([X_outer, Y_outer, Z_outer]);
}

// --- Floor ---
module tank_floor() {
    // The floor is at z=0. We model the solid block first.
    translate([0, 0, 0])
    cube([X_outer, Y_outer, Floor_thickness]);
}

// --- Inner Cavity (Hollowed out) ---
module inner_cavity() {
    difference() {
        tank_body();
        // Cut out the interior space. We subtract a slightly smaller box to ensure walls are 3mm thick.
        translate([Wall_thickness, Wall_thickness, 0])
        cube([X_outer - 2 * Wall_thickness, Y_outer - 2 * Wall_thickness, Z_outer]);
    }
}

// --- Gel Platform ---
module gel_platform() {
    // The platform spans the full inner width (Y) and is 60mm long in X, centered.
    // It sits on top of the floor structure.
    translate([ (X_outer - Platform_length) / 2, 0, Platform_Z ])
    cube([Platform_length, Inner_Y, 1]); // Height of platform is 1mm for structural integrity, or just define its shape based on placement.

    // Since the problem states it's a raised platform, we model it as a solid block spanning the inner width.
    // The platform sits at Z = Platform_Z (13). It spans from X = (120-60)/2 = 30 to X = 90.
    translate([30, 0, Platform_Z])
    cube([Platform_length, Inner_Y, 1]); // A thin block representing the platform structure itself.
}

// --- Electrode Holes ---
module electrode_holes() {
    // Drill a 2mm diameter horizontal hole along X at y = 0, z = 30 for both ends.

    // Hole at X = 0 (Left end)
    translate([0, 0, Hole_z - Hole_diameter/2])
    cylinder(r = Hole_diameter / 2, h = 2, $fn = 64);

    // Hole at X = X_outer (Right end)
    translate([X_outer, 0, Hole_z - Hole_diameter/2])
    cylinder(r = Hole_diameter / 2, h = 2, $fn = 64);
}


// --- Assembly ---
union() {
    inner_cavity();
    tank_floor();
    gel_platform();
}

// Add the electrode holes to the final assembly
translate([0, 0, 0]) // Translate back to origin for hole placement relative to the tank base
electrode_holes();