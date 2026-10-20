// Adapter sleeve: 0.2 mL PCR tube into 1.5 mL tube rack hole
// Dimensions measured with calipers

// Collar (lies on bed, z=0 to 1.5)
collar_dia = 13;
collar_thick = 1.5;

// Sleeve body (rises from collar to z=21.5)
sleeve_od = 10.8;
sleeve_height = 21.5;

// Bore (straight through full height, open both ends)
bore_dia = 6.2;

// Resolution for curved shapes
$fn = 64;

// Build the part in print orientation: collar on bed, sleeve rising up
union() {
    // Collar: cylinder on the bed
    translate([0, 0, 0])
        cylinder(h = collar_thick, r = collar_dia / 2, center = false);

    // Sleeve body: starts at top of collar (z = collar_thick)
    translate([0, 0, collar_thick])
        cylinder(h = sleeve_height - collar_thick, r = sleeve_od / 2, center = false);
}

// Subtract the bore: extends slightly past top and bottom to avoid coplanar faces
difference() {
    // (The union above is implicitly the first operand of difference)
    // Bore hole: extends 1 mm below z=0 and 1 mm above z=sleeve_height
    translate([0, 0, -1])
        cylinder(h = sleeve_height + 2, r = bore_dia / 2, center = false);
}