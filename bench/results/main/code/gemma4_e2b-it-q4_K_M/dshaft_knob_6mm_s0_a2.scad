// Dimensions for the Hotplate Stirrer Knob

// Main Cylinder Dimensions
diameter = 30;      // Overall diameter of the knob (mm)
height = 15;         // Overall height of the knob (mm)

// Blind Bore Dimensions (D-shaped hole)
bore_diameter = 6.2; // Diameter of the blind bore hole (mm) - Enforced based on report observation
bore_depth = 12;     // Depth of the blind bore cut (mm)

// Grip Groove Dimensions
num_grooves = 18;    // Number of vertical grip grooves
groove_diameter = 2; // Diameter of each groove (mm)
groove_depth = 3;    // Assumed depth for a functional groove

// Pointer Groove Dimensions
pointer_width = 1.5; // Width of the pointer groove (mm)
pointer_depth = 1;   // Depth of the pointer groove (mm)

// Tolerances for cutting operations
tolerance = 0.2;     // Tolerance for cuts to ensure separation

// --- Main Body ---
difference() {
    // 1. Base Cylinder
    cylinder(h = height, r = diameter / 2, $fn = 64);

    // 2. Blind Bore Cut (Enforcing a consistent cylindrical hole based on report observation)
    translate([0, 0, 0]) {
        // Create a simple cylindrical bore of the specified diameter throughout its depth.
        cylinder(h = bore_depth + tolerance, r = bore_diameter / 2, $fn = 64);
    }

    // 3. Grip Grooves Cut (18 vertical grooves)
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle]) {
            translate([0, 0, 0]) {
                // Cut a cylinder to represent the groove profile along the Z-axis.
                cylinder(h = height + tolerance, r = groove_diameter / 2, $fn = 64);
            }
        }
    }

    // 4. Pointer Groove Cut (Top Face)
    // Runs from the center to the outer edge on the side of the flat of the D.
    // Assuming the flat of the D is along the X-axis (angle 0). We cut along the X-axis direction.
    translate([0, -diameter / 2 + tolerance, height - pointer_depth]) { // Position near the top face (Z=15)
        // Cut a rectangular slot centered on the axis of the knob
        cube([pointer_width, diameter, pointer_depth], center = true);
    }
}