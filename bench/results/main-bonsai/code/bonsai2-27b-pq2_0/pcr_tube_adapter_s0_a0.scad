// Adapter sleeve: 0.2 mL PCR tube in a 1.5 mL tube rack hole
// Print orientation: collar on the bed (z=0..1.5), sleeve rises to z=21.5

$fn = 64;

// Named dimensions (mm)
collar_diameter = 13.0;    // outer diameter of the bed-side collar
collar_thickness = 1.5;    // collar height (z = 0 to 1.5)
sleeve_outer_diameter = 10.8; // outer diameter of the sleeve body
sleeve_top_z = 21.5;       // top of the sleeve body
bore_diameter = 6.2;       // through-bore diameter, open at both ends
cut_overhang = 0.05;       // cutting shapes extend past faces to avoid coplanar faces

// Derived values
collar_radius = collar_diameter / 2;
sleeve_radius = sleeve_outer_diameter / 2;
bore_radius = bore_diameter / 2;

// Build the solid: collar + sleeve body, then subtract the through-bore
union() {
    // Collar: flat disc on the bed
    cylinder(h = collar_thickness, d = collar_diameter, center = false);

    // Sleeve body: from top of collar up to z = 21.5
    translate([0, 0, collar_thickness])
        cylinder(h = sleeve_top_z - collar_thickness, d = sleeve_outer_diameter, center = false);
}

// Subtract the straight through-bore (open at both ends)
difference() {
    union() {
        cylinder(h = collar_thickness, d = collar_diameter, center = false);
        translate([0, 0, collar_thickness])
            cylinder(h = sleeve_top_z - collar_thickness, d = sleeve_outer_diameter, center = false);
    }

    // Bore: extends 0.05 mm past both open ends
    translate([0, 0, -cut_overhang])
        cylinder(h = sleeve_top_z + 2 * cut_overhang, d = bore_diameter, center = false);
}