// Adapter Sleeve for 0.2 mL PCR tube in 1.5 mL rack
// Print orientation: Upside down (Collar on bed)

// Dimensions (mm)
$fn = 128; // High resolution for smooth cylinders

// Collar (Base)
d_collar_outer = 13.0;
h_collar = 1.5;

// Sleeve Body
d_body_outer = 10.8;
h_body_total = 21.5;
h_body = h_body_total - h_collar; // Height of the cylindrical part above collar

// Bore
d_bore = 6.2;

// Overhang compensation for cutting (Rule 5)
// The bore needs to extend slightly past the collar top and body bottom to ensure clean cuts
cut_overhang = 0.2;

// --- Construction ---

// 1. Create the Collar (Base)
// Lies on XY plane at z=0
collar = translate([0, 0, 0])
    cylinder(h = h_collar, r = d_collar_outer / 2, $fn = $fn);

// 2. Create the Sleeve Body
// Rises from the top of the collar (z = h_collar) to z = h_body_total
// Outer diameter is d_body_outer
// Bore is d_bore
body = translate([0, 0, h_collar])
    cylinder(h = h_body, r = d_body_outer / 2, $fn = $fn);

// 3. Create the Bore (Hole)
// Runs through the full height.
// To ensure it cuts cleanly through the collar and body without coplanar faces:
// Top cut starts at z = h_collar - cut_overhang
// Bottom cut ends at z = h_body_total + cut_overhang
bore = translate([0, 0, h_collar - cut_overhang])
    cylinder(h = h_body_total + (2 * cut_overhang), r = d_bore / 2, $fn = $fn);

// --- Assembly ---
// Union the solid parts, then subtract the bore
final_part = union(
    collar,
    body
) - bore;

// Center the part on the origin in X and Y as requested
translate([0, 0, 0]) final_part;