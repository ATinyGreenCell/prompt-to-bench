// Replacement Knob for Hotplate Stirrer (6mm D-shaft)
// Designed for FDM printing. Orientation: Bottom face on Z=0.

// --- Dimensions ---
// Knob outer diameter
$D_out = 30;
// Knob height
$H_total = 15;
// Shaft bore depth
$H_bore = 12;
// Shaft bore diameter (circle part)
$D_bore_circle = 6.2;
// Shaft bore flat width (distance from flat to opposite arc)
$W_bore_flat = 4.7;
// Groove count
$N_grooves = 18;
// Groove diameter
$D_groove = 2;
// Pointer groove width
$W_pointer = 1.5;
// Pointer groove depth
$D_pointer = 1;

// --- Configuration ---
$fn = 128; // High resolution for smooth curves and accurate D-shape

// --- Main Part Construction ---

// 1. Base Cylinder
translate([0, 0, 0])
difference() {
    // Outer Shell
    cylinder(h = $H_total, d = $D_out, center = [0,0,0]);
    
    // 2. D-Shaped Bore
    // We subtract the cylindrical hole and the rectangular cut to create the D-shape.
    // The flat side of the D-bore is aligned with the +X axis.
    
    // Calculate geometry for the flat cut
    R_bore = $D_bore_circle / 2;
    // The flat face is at X = W_bore_flat / 2.
    // The cut removes material from X = W_bore_flat / 2 to X = R_bore.
    cut_start_x = $W_bore_flat / 2;
    cut_width = R_bore - cut_start_x;
    cut_height = $D_bore_circle; // Full diameter
    
    translate([0, 0, 0])
    difference() {
        // The main cylindrical hole
        cylinder(h = $H_bore, d = $D_bore_circle, center = [0,0,0]);
        
        // The rectangular prism that creates the flat side of the D-hole
        // This prism is positioned to cut the "right" side of the cylinder
        translate([cut_start_x, -($D_bore_circle/2), 0])
        cube([cut_width, $D_bore_circle, $H_bore]);
    }
    
    // 3. Grip Grooves
    // 18 evenly spaced vertical grooves along the full height.
    // Each groove is a 2 mm diameter half-cylinder centred on the outer surface.
    // We create these by subtracting cylinders of diameter $D_groove.
    // To ensure they are "half-cylinders" (semi-circular cross-section) on the surface,
    // we subtract a cylinder of diameter $D_groove.
    for (i = [0 : $N_grooves - 1]) {
        angle = (i / ($N_grooves - 1)) * 180; // 0 to 180 degrees
        translate([0, 0, 0])
        rotate([0, 0, angle])
        translate([$D_out/2, 0, 0])
        cylinder(h = $H_total, d = $D_groove, center = [0,0,0]);
    }
    
    // 4. Pointer Groove
    // On the top face, cut a pointer groove 1.5 mm wide and 1 mm deep.
    // Runs from the centre to the outer edge, on the same side as the flat of the D (+X).
    // We subtract a rectangular prism from the top face.
    translate([0, 0, $H_total - $D_pointer])
    cube([$W_pointer, $D_out, $D_pointer], center = [$W_pointer/2, 0, 0]);
}