// Rack for six 50 mL conical (Falcon-type) tubes.
// Print orientation: Flat plate on bed (z=0), walls rising to z=70.
// After printing, flip over so walls are on the bed and tubes hang down.

// Plate dimensions
L     = 130; // Length (X)
W     = 90;  // Width (Y)
t     = 4;   // Plate thickness (Z)

// Hole specifications
n_holes = 6;
hole_d  = 30.5; // Diameter

// Grid layout
row_spacing = 40; // Centre-to-centre Y
col_spacing = 40; // Centre-to-centre X

// Wall specifications
wall_h = 70; // Height of walls from plate top (z=4)
wall_t = 4;  // Thickness of walls (Y)

// Derived positions
// The plate is centred on the origin.
// X range: -65 to +65
// Y range: -45 to +45
// Plate top surface is at z = t.

$fn = 64;

// Define the main body (Plate + Walls)
module rack_body() {
    // 1. The flat plate, centred on origin
    translate([0, 0, 0]) cube([L, W, t]);

    // 2. The two side walls
    // Left wall (at Y = -W/2)
    translate([0, -W/2, 0]) cube([L, wall_t, wall_h + t]);
    // Right wall (at Y = +W/2)
    translate([0, W/2, 0]) cube([L, wall_t, wall_h + t]);
}

// Define the holes
module holes() {
    // Calculate positions relative to the plate top (z=t)
    // We subtract t from the Z coordinate of the cutting cylinder so it starts at the plate surface
    // and goes down (negative Z) to cut through.
    
    // Y positions for 3 rows: -40, 0, 40 (centred on Y=0)
    y_pos = [-40, 0, 40];
    // X positions for 3 cols: -40, 0, 40 (centred on X=0)
    x_pos = [-40, 0, 40];

    for (y = y_pos) {
        for (x = x_pos) {
            // Cut a cylinder through the plate and walls
            // The cylinder must extend slightly past the plate thickness to ensure clean cut
            // and past the wall height.
            translate([x, y, t]) 
                cylinder(h = wall_h + t + 1, d = hole_d);
        }
    }
}

difference() {
    union() {
        rack_body();
    }
    holes();
}