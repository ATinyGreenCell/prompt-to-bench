$fn = 64;

// Dimensions in millimeters
collar_diameter = 13.0;   // Outer diameter of the collar base
collar_height = 1.5;        // Thickness of the collar (z=0 to 1.5)
sleeve_outer_diameter = 10.8; // Outer diameter of the sleeve body
total_height = 21.5;      // Full height of adapter (z=0 to 21.5)
bore_diameter = 6.2;      // Diameter of the central bore
hole_extension = 0.01;      // Extension beyond part faces for subtraction safety

// Calculate sleeve body height (from collar top to top of adapter)
sleeve_height = total_height - collar_height;

// Build collar (base, z=0 to collar_height)
collar = cylinder(d = collar_diameter, h = collar_height, center = false);

// Build sleeve body (z=collar_height to total_height)
sleeve = translate([0, 0, collar_height]) cylinder(d = sleeve_outer_diameter, h = sleeve_height, center = false);

// Build hole (extended for subtraction safety: 0.01mm below and above)
hole = translate([0, 0, -hole_extension]) cylinder(d = bore_diameter, h = total_height + 2 * hole_extension, center = false);

// Assemble adapter: collar + sleeve body, minus the hole
adapter = difference() {
    union() {
        collar;
        sleeve;
    }
    hole;
};

adapter;