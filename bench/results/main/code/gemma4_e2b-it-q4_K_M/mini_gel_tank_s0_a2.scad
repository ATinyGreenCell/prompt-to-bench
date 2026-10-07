// Buffer Tank Design for Mini Horizontal Gel-Electrophoresis Box - FINAL CORRECTED VERSION

// --- Dimensions ---
X_outer = 120;    // Outer length of the tank (mm)
Y_outer = 70;     // Outer width of the tank (mm)
Z_outer = 40;     // Outer height of the tank (mm)
Wall_thickness = 3; // Thickness of the walls (mm)
Floor_thickness = 3; // Thickness of the floor (mm)

Platform_length = 60;  // Length of the central platform in X (mm)
Platform_height_above_inner_floor = 10; // Height of the platform above the inner floor (mm)
Hole_diameter = 2; // Diameter of the electrode holes (mm)
Hole_z = 30;      // Z-level for the electrode holes (mm)

// --- Calculated Inner Dimensions ---
Inner_X = X_outer - 2 * Wall_thickness; // 120 - 6 = 114 mm
Inner_Y = Y_outer - 2 * Wall_thickness; // 70 - 6 = 64 mm

// Z-levels
Inner_Z_floor = Floor_thickness; // Inner floor is at z=3 (since floor is at z=0)
Platform_Z = Inner_Z_floor + Platform_height_above_inner_floor; // 3 + 10 = 13 mm

// --- Main Tank Body Construction ---
module tank_shell() {
    difference() {
        // 1. Outer solid block (defines the outer boundary)
        cube([X_outer, Y_outer, Z_outer]);

        // 2. Inner void subtraction (ensures 3mm walls)
        translate([Wall_thickness, Wall_thickness, 0])
        cube([Inner_X, Inner_Y, Z_outer]);
    }
}

// --- Floor Construction ---
module tank_floor() {
    // The floor is at z=0. We model the solid block that forms the base.
    translate([0, 0, 0])
    cube([X_outer, Y_outer, Floor_thickness]);
}

// --- Gel Platform Construction ---
module gel_platform() {
    // The platform spans the full inner width (Inner_Y = 64 mm) and is 60mm long in X, centered.
    // It sits on top of the floor structure.
    translate([ (X_outer - Platform_length) / 2, 0, Platform_Z ])
    cube([Platform_length, Inner_Y, 1]); // A thin block representing the platform structure itself.
}

// --- Electrode Holes ---
module electrode_holes() {
    // Drill a 2mm diameter horizontal hole along X at y = 0 (outer wall) at z = Hole_z for both ends.

    // Hole at X = 0 (Left end wall)
    translate([0, 0, Hole_z - Hole_diameter/2])
    cylinder(r = Hole_diameter / 2, h = 2, $fn = 64);

    // Hole at X = X_outer (Right end wall)
    translate([X_outer, 0, Hole_z - Hole_diameter/2])
    cylinder(r = Hole_diameter / 2, h = 2, $fn = 64);
}


// --- Final Assembly ---
union() {
    tank_shell();
    tank_floor();
    gel_platform();
}

// Add the electrode holes to the final assembly (These are drilled through the shell)
electrode_holes();