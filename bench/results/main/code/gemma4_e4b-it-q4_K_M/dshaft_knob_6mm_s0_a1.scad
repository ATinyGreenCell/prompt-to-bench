// --- Dimensions in mm ---

// Main Knob Dimensions
knob_diameter = 30;    // Total diameter of the knob
knob_height = 15;      // Total height of the knob
shaft_diameter = 6;    // Diameter of the D-shaft bore (nominal)

// D-Shaft Bore Dimensions
bore_depth = 12;       // Depth of the blind bore
bore_diameter = 6.2;   // Diameter of the circular cross-section for the bore
bore_flat_distance = 4.7; // Distance across the flat side of the bore (height)

// Grip Groove Dimensions
num_grooves = 18;      // Number of grip grooves
groove_diameter = 2;   // Diameter of the half-cylinder groove
groove_depth = knob_height; // Full height of the groove

// Pointer Groove Dimensions
pointer_width = 1.5;   // Width of the pointer groove (extrusion depth)
pointer_depth = 1;     // Depth of the pointer groove (cut into Z)

// Tolerance for cutting operations
tolerance = 0.2;

$fn = 64;

// --- Module Definitions ---

// Function to create a half-cylinder profile (for grip grooves)
module half_cylinder(d, h) {
    translate([0, 0, -h/2])
    rotate([90, 0, 0])
    cylinder(r = d/2, h = d);
}

// Extrude the profile along the Z axis to create the blind hole shape (D-shape)
module d_bore_cut_extruded() {
    // The D-shape needs to be extruded from Z=0 up to bore_depth.
    linear_extrude(height = bore_depth + tolerance*2) {
        difference() {
            // Full circle profile (used as the base shape for extrusion)
            circle(r = bore_diameter / 2);

            // Cut away the unwanted half using translation along the Y-axis of the profile plane
            // The distance from the center to the flat edge is bore_flat_distance / 2.
            translate([0, -bore_flat_distance/2 + tolerance*1.5])
            circle(r = bore_diameter / 2);
        }
    }
}

// --- Main Assembly ---

difference() {
    // Start with the solid knob body
    knob = cylinder(h = knob_height, r = knob_diameter / 2);

    // 1. Cut D-Shaft Bore (Must be done first as it affects subsequent cuts)
    translate([0, 0, -tolerance]) // Start slightly below Z=0 to ensure full cut through the base
    d_bore_cut_extruded();

    // 2. Cut Grip Grooves (18 evenly spaced vertical half-cylinders)
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle])
        // Position the center of the groove on the outer surface radius minus half the groove diameter
        translate([(knob_diameter/2) - (groove_diameter/2) + tolerance*0.5, 0, 0])
        half_cylinder(d = groove_diameter, h = knob_height);
    }

    // 3. Cut Pointer Groove (Top Surface)
    // This is a slot cut into the top face (Z=knob_height/2).
    // We assume the flat side of the D-bore faces along +Y relative to the center axis when viewed from above.
    
    // The groove runs from X=0 to X = knob_diameter/2 - tolerance*1.5, and has a width of pointer_width (along Y) and depth of pointer_depth (along Z).

    translate([0, bore_flat_distance/2 + tolerance*1.5, knob_height/2 - pointer_depth/2]) // Positioned on the flat side (+Y), centered vertically at Z=knob_height/2
    linear_extrude(height = pointer_width + tolerance) {
        // The profile is a rectangle: Length (along X axis of extrusion plane) x Width (along Y axis of extrusion plane)
        // Length runs from center to edge: knob_diameter/2 - tolerance*1.5
        // Width is the slot width: pointer_depth
        rectangle([knob_diameter/2 - tolerance*1.5, pointer_depth], [0, pointer_width]); 
    }

}