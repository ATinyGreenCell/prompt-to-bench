// Replacement knob for hotplate stirrer
// D-shaft: 6 mm, Knob: 30 mm dia x 15 mm tall, printed with bottom face on bed (z=0)

// --- Knob outer dimensions ---
knob_dia = 30;           // Outer diameter of knob (mm)
knob_h = 15;             // Total height of knob (mm)
knob_r = knob_dia / 2;  // Outer radius

// --- D-shaft bore dimensions ---
shaft_dia = 6;           // Shaft diameter (mm)
bore_dia = 6.2;           // Bore diameter (slight clearance) (mm)
bore_r = bore_dia / 2;   // Bore radius
bore_depth = 12;         // Depth of blind bore from bottom (mm)
flat_to_opposite = 4.7;  // Distance from flat to opposite side of circle (mm)

// --- Calculated values ---
// For D-shape: the flat is cut such that distance from flat to opposite side = 4.7 mm
// The circle has radius 3.1 mm. The flat is at distance (3.1 - (4.7 - 3.1)) = 1.5 mm from center
// So the flat is at x = 1.5 mm (if flat is on the right side)
flat_offset = bore_r - (flat_to_opposite - bore_r);  // Distance from center to flat

// --- Grip grooves ---
num_grooves = 18;         // Number of vertical grip grooves
groove_dia = 2;           // Diameter of half-cylinder groove (mm)
groove_r = groove_dia / 2;

// --- Pointer groove ---
pointer_width = 1.5;      // Width of pointer groove (mm)
pointer_depth = 1;       // Depth of pointer groove (mm)

// --- Build the knob with all features ---
difference() {
    // Main cylinder body
    cylinder(r = knob_r, h = knob_h, $fn = 64);
    
    // Subtract D-shaped blind bore from bottom (z=0)
    // The bore goes 12mm up into the knob
    translate([0, 0, bore_depth - 0.01]) {
        // First, create the cylindrical part of the bore
        cylinder(r = bore_r, h = 0.02, $fn = 64);
        
        // Then cut the flat side
        // The flat is at x = flat_offset, cutting from there to the right
        translate([flat_offset, 0, 0]) {
            // Cut a rectangular section to create the flat
            cube([bore_r - flat_offset + 0.01, bore_dia + 0.02, 0.02], center = [0, 0, 0]);
        }
    }
    
    // Subtract vertical grip grooves (half-cylinders on outer surface)
    for (i = [0 : num_grooves - 1]) {
        angle = i * 360 / num_grooves;
        translate([cos(angle) * knob_r, sin(angle) * knob_r, 0]) {
            rotate([0, 0, angle]) {
                // Half-cylinder groove: cut from the outer surface inward
                // The groove center is on the outer surface, so we cut from r = knob_r - groove_r inward
                translate([groove_r, 0, 0]) {
                    cylinder(r = groove_r, h = knob_h + 0.02, $fn = 32);
                }
            }
        }
    }
    
    // Subtract pointer groove on top face
    // Runs from center to outer edge, on the same side as the flat of the D (positive x-axis)
    translate([0, 0, knob_h - pointer_depth]) {
        // Rectangular groove from center to edge
        translate([pointer_width / 2, 0, 0]) {
            cube([knob_r, pointer_width, pointer_depth + 0.01], center = [0, 0, 0]);
        }
    }
}