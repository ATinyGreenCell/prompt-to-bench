// ---------------
// Parameters (mm)
dish_diameter   = 85;      // Petri dish outer diameter
dish_thickness  = 2;       // Dish thickness
hole_diameter   = 3;       // Through‑hole diameter
hole_spacing   = 9;       // Centre‑to‑centre spacing of holes
hole_grid       = 7;       // Number of holes per side (odd)
notch_width    = 10;      // Notch width (X direction)
notch_depth    = 4;       // Notch depth inward from rim (Y direction)
cut_extra       = 0.1;     // Extra length for cutting shapes (mm)

$fn = 64; // smoothness for cylinders and circles

// Derived values
dish_radius = dish_diameter/2;

// Main solid (disc)
disc = cylinder(h = dish_thickness, r = dish_radius, center = false);

// Hole grid (through‑holes)
hole = cylinder(h = dish_thickness + 2*cut_extra,
                r = hole_diameter/2,
                center = false);
hole_grid_shapes = union() {
    // grid indices run from -(hole_grid-1)/2 to +(hole_grid-1)/2
    for (i = -((hole_grid-1)/2); i <= ((hole_grid-1)/2); i = i + 1)
        for (j = -((hole_grid-1)/2); j <= ((hole