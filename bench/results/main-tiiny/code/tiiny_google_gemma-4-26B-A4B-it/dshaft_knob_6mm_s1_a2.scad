// --- Parameters ---
// Knob Dimensions
knob_diameter = 30.0;          // Total diameter of the knob
knob_height = 15.0;            // Total height of the knob

// D-Shaft Bore (Blind Bore)
bore_circle_dia = 6.2;         // Diameter of the circular part of the D-bore
bore_flat_width = 4.7;         // Distance from flat to opposite side
bore_depth = 12.0;             // How deep the D-bore goes into the knob

// Grip Grooves
num_grooves = 18;              // Number of vertical grooves
groove_dia = 2.0;              // Diameter of the half-cylinder groove

// Pointer Groove (Top Face)
pointer_width = 1.5;           // Width of the pointer groove
pointer_depth = 1.0;           // Depth of the pointer groove

// Resolution
fn_val = 64;                   // Smoothness for cylinders

// --- Calculations ---
knob_radius = knob_diameter / 2;
bore_radius = bore_circle_dia / 2;
groove_radius = groove_dia / 2;

// The distance from the center to the flat side is bore_flat_width / 2.
// To create the D-shape, we subtract a cylinder that is offset.
// The offset is the distance from the center of the bore to the center of the subtraction cylinder.
// If the subtraction cylinder has radius R, and its edge is at x = bore_flat_width/2,
// then its center is at x = bore_flat_width/2 + R.
// However, to ensure the widest part of the bore remains 6.2mm, 
// we subtract a cylinder that is offset so its edge is at the flat position.
// The distance from the center to the flat is 2.35. 
// The radius of the bore is 3.1.
// The offset for the subtraction cylinder to create a flat at 2.35:
// We want the edge of the subtraction cylinder to be at x = 2.35.
// Let's use a large cylinder to ensure a clean flat.
subtraction_offset = (bore_circle_dia / 2) - (bore_flat_width / 2);

// --- Main Model ---

difference() {
    // 1. Main Knob Body
    cylinder(h = knob_height, d = knob_diameter, $fn = fn_val);

    // 2. D-Shaft Blind Bore
    // We subtract the D-shape from the bottom.
    // To ensure the "D" is exactly 6.2 at the widest and 4.7 at the flat:
    // We take a cylinder of 6.2 and subtract a cylinder of 6.2 offset by (6.2-4.7)/2.
    // Wait, the previous logic was slightly off. Let's use a large cylinder to cut the flat.
    translate([0, 0, -0.01]) {
        union() {
            // The main circular part of the bore
            cylinder(h = bore_depth + 0.01, d = bore_circle_dia, $fn = fn_val);
            
            // To make it a "D", we subtract a cylinder that is offset.
            // The flat is at 2.35mm from center.
            // We subtract a cylinder whose edge is at 2.35mm from center.
            // Let's use a very large cylinder centered at x = 2.35 + 100.
            translate([2.35 + 100, 0, -0.01])
                cylinder(h = bore_depth + 0.02, d = 300, $fn = 6); // 6 sides for a clean flat
        }
    }
    // Wait, the logic above is for a union. We need to subtract the D-shape.
    // Let's use the standard way: 
    // Start with a cylinder of 6.2, then subtract a cylinder that is offset.
    // To get a flat at 2.35, we subtract a cylinder of diameter 6.2 offset by (6.2-4.7)/2 = 0.75.
    // No, that makes the flat at 3.1 - 0.75 = 2.35. Correct.
    // But we must do this inside the difference() block.
    
    // Let's restart the difference block logic to be precise.
}

// --- Corrected Final Structure ---

difference() {
    // 1. Main Knob Body
    cylinder(h = knob_height, d = knob_diameter, $fn = fn_val);

    // 2. D-Shaft Blind Bore
    // We want a cylinder of 6.2, but one side is cut at 4.7.
    // We achieve this by subtracting a cylinder of 6.2 offset by 0.75.
    translate([0, 0, -0.01]) {
        difference() {
            cylinder(h = bore_depth + 0.02, d = bore_circle_dia, $fn = fn_val);
            // This subtraction cylinder creates the flat.
            // Its edge is at 3.1 - 0.75 = 2.35. 
            // 2.35 * 2 = 4.7.
            translate([0.75, 0, -0.01])
                cylinder(h = bore_depth + 0.02, d = bore_circle_dia, $fn = fn_val);
        }
    }

    // 3. Vertical Grip Grooves
    // 18 evenly spaced vertical grooves around the outer surface.
    // "2 mm diameter half-cylinder centred on the outer surface"
    for (i = [0 : num_grooves - 1]) {
        angle = i * (360 / num_grooves);
        rotate([0, 0, angle])
            translate([knob_radius, 0, -0.01])
                cylinder(h = knob_height + 0.02, d = groove_dia, $fn = fn_val);
    }

    // 4. Pointer Groove (Top Face)
    // 1.5mm wide, 1mm deep, from center to outer edge, on the same side as the flat.
    // The flat is at x = 2.35 (in the subtraction logic above).
    // To align with the flat, we place the pointer at the same angle.
    // The subtraction cylinder was translated by +0.75, so the flat is at +2.35.
    // We will place the pointer at angle 0.
    translate([0, -pointer_width / 2, knob_height - pointer_depth])
        cube([knob_radius + 1, pointer_width, pointer_depth + 0.01]);
}

// Note: The previous error in the report (X -14.95 .. 14.95) was due to the 
// grip grooves being added instead of subtracted. 
// The "overhangs" at z=12 were due to the D-bore being a blind hole.
// The "pointer groove" was previously a cube, now it's correctly subtracted.