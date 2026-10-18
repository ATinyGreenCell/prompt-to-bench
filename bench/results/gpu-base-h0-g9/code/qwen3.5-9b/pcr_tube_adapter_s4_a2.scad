// Adapter Sleeve for 0.2mL PCR Tube in 1.5mL Rack
// Print Orientation: Upside down (Collar on bed)
// Units: mm

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate holes

// Collar (Base)
$collar_od = 13.0;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_od = 10.8;
$sleeve_total_height = 21.5;
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// Bore
$bore_diameter = 6.2;

// --- Construction ---

// 1. Create the Collar (Base)
// Lies on XY plane from z=0 to z=1.5
collar = translate([0, 0, 0])
    cylinder(h = $collar_thickness, r = $collar_od / 2, $fn = $fn);

// 2. Create the Sleeve Body
// Rises from top of collar (z=1.5) to z=21.5
// Outer diameter 10.8mm, Inner bore 6.2mm
sleeve_body = translate([0, 0, $collar_thickness])
    cylinder(h = $sleeve_body_height, r = $sleeve_od / 2, $fn = $fn);

// 3. Create the Bore
// Runs through the full height (0 to 21.5)
bore = translate([0, 0, 0])
    cylinder(h = $sleeve_total_height, r = $bore_diameter / 2, $fn = $fn);

// --- Final Assembly ---
// Union the solid parts, then subtract the bore
part = union(
    collar,
    sleeve_body
);

final_part = difference()
    part,
    bore
;

// Display the final part
final_part;