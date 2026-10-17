// Sowing Template for 90mm Petri Dish
// Designed to sit flat on the XY plane (Z=0)

// --- Dimensions ---
// Disc outer diameter
$D_outer = 85;
// Disc thickness
$H_thickness = 2;
// Grid size (7x7)
$N_rows = 7;
$N_cols = 7;
// Hole diameter
$D_hole = 3;
// Hole spacing (center-to-center)
$S_spacing = 9;
// Notch width (X dimension)
$W_notch = 10;
// Notch depth (Y dimension, measured from rim inward)
$D_notch = 4;
// Overcut for clean printing (Rule 5)
$OVERCUT = 0.1;

// --- Setup ---
$fn = 128; // High resolution for smooth holes

// Calculate grid offsets to center the 7x7 grid
// Total span = (N-1) * spacing
$Span_total = ($N_rows - 1) * $S_spacing;
$Offset_center = ($Span_total / 2) - ($S_spacing / 2);

// --- Main Body ---
difference() {
    // 1. The main disc
    translate([0, 0, 0])
        cylinder(
            h = $H_thickness,
            d1 = $D_outer,
            d2 = $D_outer,
            $fn = 64
        );

    // 2. The 7x7 Grid of Holes
    // We subtract cylinders. To ensure clean cuts, we extend them slightly past the faces.
    for (r = [0:$N_rows-1], c = [0:$N_cols-1]) {
        // Calculate position of this hole
        x_pos = $Offset_center + c * $S_spacing;
        y_pos = $Offset_center + r * $S_spacing;
        
        translate([x_pos, y_pos, 0])
            cylinder(
                h = $H_thickness + $OVERCUT, // Extend slightly past top and bottom
                d1 = $D_hole,
                d2 = $D_hole,
                $fn = 64
            );
    }

    // 3. The Rectangular Orientation Notch
    // Located on the +Y side, centered on Y axis.
    // Width = 10mm (X), Depth = 4mm (Y from rim).
    // Rim radius = 85/2 = 42.5mm.
    // Notch starts at Y = 42.5 - 4 = 38.5mm.
    // Notch extends from Y = 38.5 to Y = 42.5.
    // X range: -5 to +5.
    
    // We cut a rectangular prism that goes all the way through the disc thickness
    // and extends slightly past the top/bottom faces to ensure a clean cut.
    translate([0, 38.5, 0])
        cube([
            $W_notch, 
            $D_notch, 
            $H_thickness + $OVERCUT
        ]);
}