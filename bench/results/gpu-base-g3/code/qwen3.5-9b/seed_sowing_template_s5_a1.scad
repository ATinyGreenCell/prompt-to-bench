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
    // Iterate from center outwards to ensure perfect centering at 0,0
    // Range: -3 to +3 (inclusive) for 7 items
    for (r = [-3:3], c = [-3:3]) {
        // Calculate position
        x_pos = c * $S_spacing;
        y_pos = r * $S_spacing;
        
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