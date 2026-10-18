$fn = 128;

// --- Dimensions ---
// Disc dimensions
$DISC_DIAMETER = 85;
$DISC_THICKNESS = 2;

// Grid dimensions
$GRID_SIZE = 7;
$HOLE_COUNT = 7;
$HOLE_DIAMETER = 3;
$HOLE_SPACING = 9;

// Notch dimensions (on +Y side)
$NOTCH_WIDTH = 10;   // X dimension
$NOTCH_DEPTH = 4;    // Y dimension (in from rim)

// --- Calculations ---
// Calculate disc radius
$R = $DISC_DIAMETER / 2;

// Calculate grid offset to center the 7x7 grid
// Total span = (count - 1) * spacing
$GRID_SPAN = ($HOLE_COUNT - 1) * $HOLE_SPACING;
// To center the grid, the first hole center should be at: -(TotalSpan / 2) + (HoleDiameter / 2)
$GRID_START = -($GRID_SPAN / 2) + ($HOLE_DIAMETER / 2);
$GRID_STEP = $HOLE_SPACING;

// Calculate notch position
// Notch is centred on Y axis (X=0).
// Y position is (Radius - Depth).
$NOTCH_Y_POS = $R - $NOTCH_DEPTH;

// --- Main Body ---
difference() {
    // Create the main disc
    // Translate up by half thickness so the bottom is at Z=0
    translate([0, 0, $DISC_THICKNESS / 2])
    cylinder(
        h = $DISC_THICKNESS,
        d = $DISC_DIAMETER,
        center = true
    );

    // --- Cut Holes ---
    // Loop for 7x7 grid
    for (i = [0 : $HOLE_COUNT - 1]) {
        for (j = [0 : $HOLE_COUNT - 1]) {
            // Calculate position based on index to ensure centering
            x = $GRID_START + (i * $GRID_STEP);
            y = $GRID_START + (j * $GRID_STEP);
            
            // Cutters must extend slightly below Z=0 to ensure they cut through the full disc thickness
            translate([x, y, -$DISC_THICKNESS / 2])
            cylinder(
                h = $DISC_THICKNESS + 0.1, // Extend slightly past bottom (Z=0) for clean cut
                d = $HOLE_DIAMETER,
                center = true
            );
        }
    }

    // --- Cut Notch ---
    // The notch is a rectangular cutout on the side face.
    // We define a box that intersects the side of the cylinder.
    // The notch is 10mm wide (X) and 4mm deep (Y).
    // It is located at Y = $NOTCH_Y_POS.
    // The cut needs to go through the thickness of the disc.
    // The disc spans Z = 0 to Z = 2. The cutter should span this range plus a bit.
    
    translate([0, $NOTCH_Y_POS, -$DISC_THICKNESS / 2])
    cube([
        $NOTCH_WIDTH,      // Width in X
        $NOTCH_DEPTH,      // Depth in Y
        $DISC_THICKNESS + 0.1 // Thickness in Z (extend slightly)
    ]);
}