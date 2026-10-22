// 8-tube PCR strip holder for ice bucket
// Profile in YZ plane, extruded 84 mm along X, centred on x = 0.

// Dimensions (mm)
wall_thickness        = 12.0;   // ice bucket wall thickness
inner_leg_y_min       = 0.0;    // inner leg: y = 0
inner_leg_y_max       = 4.0;    // inner leg: y = 4
outer_leg_y_min       = 16.5;   // outer leg: y = 16.5
outer_leg_y_max       = 20.5;   // outer leg: y = 20.5
leg_z_min             = 0.0;    // legs start at z = 0
leg_z_max             = 50.0;   // legs end at z = 50
bridge_z_min          = 46.0;   // bridge starts at z = 46
bridge_z_max          = 50.0;   // bridge ends at z = 50
ledge_z_min           = 0.0;    // ledge starts at z = 0
ledge_z_max           = 6.0;    // ledge thickness = 6 mm
ledge_y_min           = -30.0;  // ledge extends to y = -30
ledge_y_max           = 0.0;    // ledge ends at y = 0
hole_diameter         = 6.4;    // tube hole diameter
hole_spacing_x        = 9.0;    // hole spacing along X
hole_y                = -15.0;  // hole centre y
hole_z_centre         = 3.0;    // hole centre z (mid of ledge)
extrude_length        = 84.0;   // extrusion along X
fn_curves             = 64;     // resolution for curved shapes

// Build the YZ profile (union of legs + bridge + ledge)
profile = union(
    // Inner leg: y 0..4, z 0..50
    translate([0, inner_leg_y_min, leg_z_min])
        cube([1, inner_leg_y_max - inner_leg_y_min, leg_z_max - leg_z_min]),
    // Outer leg: y 16.5..20.5, z 0..50
    translate([0, outer_leg_y_min, leg_z_min])
        cube([1, outer_leg_y_max - outer_leg_y_min, leg_z_max - leg_z_min]),
    // Bridge: y 0..20.5, z 46..50
    translate([0, 0, bridge_z_min])
        cube([1, outer_leg_y_max, bridge_z_max - bridge_z_min]),
    // Ledge: y -30..0, z 0..6
    translate([0, ledge_y_min, ledge_z_min])
        cube([1, ledge_y_max - ledge_y_min, ledge_z_max - ledge_z_min])
);

// Extrude along X, centred on x = 0
holder = linear_extrude(extrude_length, center = true) profile;

// 8 vertical through-holes in the ledge, 9 mm apart along X, centred
// Holes extend 0.5 mm past the top and bottom faces of the ledge.
hole_cut = union(
    for (i = 0; i < 8; i++) {
        x_pos = (i - 3.5) * hole_spacing_x;
        translate([x_pos, hole_y, hole_z_centre - (ledge_z_max - ledge_z_min)/2 - 0.5])
            cylinder(
                h = (ledge_z_max - ledge_z_min) + 1.0,
                d = hole_diameter,
                $fn = fn_curves
            )
    }
);

// Final part: holder minus holes
difference() {
    holder;
    hole_cut;
}