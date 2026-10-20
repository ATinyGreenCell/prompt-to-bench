// Parameters (mm)
disc_diameter = 85;          // Overall disc diameter
disc_thickness = 2;          // Disc thickness
hole_diameter = 3;           // Through‑hole diameter
hole_spacing = 9;            // Centre‑to‑centre spacing of hole grid
hole_grid = 7;                // Number of holes per side (odd, centred)
notch_width = 10;             // Notch width in X direction
notch_depth = 4;              // Notch depth inward from rim (Y direction)
extra = 0.2;                  // Over‑travel for clean cuts (mm)

$fn = 64;                     // Resolution for circles/cylinders

// Main disc (cylinder) – rests on Z = 0
disc = cylinder(d = disc_diameter, h = disc_thickness);

// Final part: disc minus holes and notch
difference() {
    // Base disc
    disc;

    // Grid of through‑holes (union of cylinders)
    for (i = -(hole_grid-1)/2; i <= (hole_grid-1)/2; i = i + 1)
        for (j = -(hole_grid-1)/2; j <= (hole_grid-1)/2; j = j + 1)
            translate([i*hole_spacing, j*hole_spacing, -extra])
                cylinder(d = hole_diameter,
                         h = disc_thickness + 2*extra);

    // Orientation notch cut on +Y side
    translate([
        -notch_width/2,
        disc_diameter/2 - notch_depth,
        -extra
    ])
        cube([notch_width,
              notch_depth + extra,
              disc_thickness + 2*extra]);
}