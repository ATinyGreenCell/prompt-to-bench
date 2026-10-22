// -------------------------------
// Parameters (mm)
dish_diameter   = 85;      // Petri dish outer diameter
dish_thickness  = 2;       // Dish thickness (z‑height)
hole_diameter   = 3;       // Through‑hole diameter
hole_spacing    = 9;       // Centre‑to‑centre spacing of holes
hole_grid       = 7;       // Number of holes per side (odd)
notch_width     = 10;      // Notch width (X direction)
notch_depth     = 4;       // Notch depth inward from rim (Y direction)
cut_extra       = 0.1;     // Extra length for cutting shapes (mm)

$fn = 64; // smoothness for cylinders and circles

// -------------------------------
// Derived values
dish_radius = dish_diameter/2;

// -------------------------------
// Main disc (solid)
disc = cylinder(h = dish_thickness, r = dish_radius, center = false);

// -------------------------------
// Grid of through‑holes
hole = cylinder(h = dish_thickness + 2*cut_extra,
                r = hole_diameter/2,
                center = false);

holes = union() {
    // indices run from -(hole_grid-1)/2 to +(hole_grid-1)/2
    for (i = -((hole_grid-1)/2); i <= ((hole_grid-1)/2); i = i + 1)
        for (j = -((hole_grid-1)/2); j <= ((hole_grid-1)/2); j = j + 1)
            translate([i*hole_spacing, j*hole_spacing, -cut_extra])
                hole;
};

// -------------------------------
// Orientation notch on +Y rim
// The notch cuts from the rim inward `notch_depth` along +Y,
// centered in X, and extends through the whole thickness.
notch = translate([
            -notch_width/2,
            dish_radius - notch_depth - cut_extra,
            -cut_extra
        ])
        cube([notch_width, notch_depth + 2*cut_extra, dish_thickness + 2*cut_extra]);

// -------------------------------
// Final part (disc with holes and notch removed)
final_part = difference() {
    disc,
    holes,
    notch
};

final_part;