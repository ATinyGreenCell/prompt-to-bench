// Adapter Sleeve for 0.2 mL PCR tubes in 1.5 mL rack holes
// Print orientation: Upside down (Collar on bed, Sleeve rising)

// --- Dimensions (mm) ---
$fn = 128; // High resolution for smooth curves and precise holes

// Collar (Base)
$collar_outer_diameter = 13.0;
$collar_thickness = 1.5;
$collar_inner_diameter = 10.8; // Matches sleeve outer diameter for flush fit

// Sleeve Body
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5;
$sleeve_body_height = $sleeve_total_height - $collar_thickness; // 20.0 mm

// Bore (Hole)
$bore_diameter = 6.2;

// --- Construction ---

// 1. Create the Collar (Base)
// Lies on XY plane from z=0 to z=1.5
collar = translate([0, 0, 0])
    cylinder(
        h = $collar_thickness,
        d1 = $collar_outer_diameter,
        d2 = $collar_inner_diameter,
        $fn = $fn
    );

// 2. Create the Sleeve Body
// Rises from top of collar (z=1.5) to z=21.5
// Outer diameter matches collar inner diameter
sleeve_body = translate([0, 0, $collar_thickness])
    cylinder(
        h = $sleeve_body_height,
        d1 = $sleeve_outer_diameter,
        d2 = $sleeve_outer_diameter,
        $fn = $fn
    );

// 3. Create the Bore (Hole)
// Runs through full height (0 to 21.5)
// Must extend slightly past the top and bottom faces to ensure clean cutting
bore = translate([0, 0, -0.1]) // Extend 0.1mm past bottom (z=0)
    cylinder(
        h = $sleeve_total_height + 0.2, // Total height + 0.1mm past top
        d = $bore_diameter,
        $fn = $fn
    );

// --- Final Assembly ---
// Union the solid parts, then subtract the bore
difference() {
    union() {
        collar;
        sleeve_body;
    }
    bore;
}