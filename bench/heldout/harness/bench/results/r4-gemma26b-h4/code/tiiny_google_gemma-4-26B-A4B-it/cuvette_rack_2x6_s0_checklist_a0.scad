// Open-sided cuvette rack for twelve 12.5mm square cuvettes.
// Designed for FDM printing, standing on the base.

// --- Dimensions ---
base_x      = 112.0;    // Length of base plate (X)
base_y      = 44.0;     // Width of base plate (Y)
base_z      = 3.0;      // Thickness of base plate (Z)

deck_x      = 112.0;    // Length of deck plate (X)
deck_y      = 44.0;     // Width of deck plate (Y)
deck_z_min  = 22.0;     // Bottom of deck plate (Z)
deck_z_max  = 25.0;     // Top of deck plate (Z)

wall_end_t  = 3.0;      // Thickness of end walls (X-direction)
wall_rib_t  = 2.5;      // Thickness of internal ribs (X-direction)
wall_depth  = 44.0;     // Depth of walls (Y-direction)
wall_height = 25.0;     // Total height of walls (Z)

hole_size   = 13.0;     // Size of cuvette holes (X and Y)
hole_pitch  = 18.0;     // Center-to-center spacing of holes (X and Y)
rows        = 2;        // Number of rows (Y)
cols        = 6;        // Number of columns (X)

$fn = 64;

// --- Calculations ---
// Centering the holes on the deck
// For 6 holes with 18mm pitch, the span is (6-1)*18 = 90mm.
// To center 90mm on 112mm: (112 - 90)/2 = 11mm offset from edge.
// However, the prompt specifies "18 mm centre-to-centre... and centred on the deck".
// We calculate the start position based on the pitch and number of items.

hole_offset_x = (cols - 1) * hole_pitch / 2;
hole_offset_y = (rows - 1) * hole_pitch / 2;

// --- Geometry ---

module wall_rib(x_pos, thickness) {
    translate([x_pos, -wall_depth/2, 0])
        cube([thickness, wall_depth, wall_height]);
}

// Main Body Construction
union() {
    // Base Plate
    translate([-base_x/2, -base_y/2, 0])
        cube([base_x, base_y, base_z]);

    // Deck Plate
    translate([-deck_x/2, -deck_y/2, deck_z_min])
        cube([deck_x, deck_y, deck_z_max - deck_z_min]);

    // End Walls (Flush with short ends)
    // Left end wall
    translate([-base_x/2, -base_y/2, 0])
        cube([wall_end_t, base_y, wall_height]);
    // Right end wall
    translate([base_x/2 - wall_end_t, -base_y/2, 0])
        cube([wall_end_t, base_y, wall_height]);

    // Internal Ribs
    // Ribs at x = -36, -18, 0, 18, 36
    for (rx = [-36, -18, 0, 18, 36]) {
        // We use a small offset to ensure the rib is centered on the coordinate
        // Since the cube is drawn from [0,0,0], we translate to [pos - t/2]
        translate([rx - wall_rib_t/2, -wall_depth/2, 0])
            cube([wall_rib_t, wall_depth, wall_height]);
    }
}

// Subtract Holes from the Deck
difference() {
    // We wrap the whole thing in a difference to cut holes through the deck
    // But to keep the code clean, we only apply the difference to the deck part.
    // Since OpenSCAD is declarative, we'll structure the final assembly below.
}

// Final Assembly with Holes
difference() {
    // The entire solid object
    union() {
        // Base
        translate([-base_x/2, -base_y/2, 0])
            cube([base_x, base_y, base_z]);
        // Deck
        translate([-deck_x/2, -deck_y/2, deck_z_min])
            cube([deck_x, deck_y, deck_z_max - deck_z_min]);
        // End Walls
        translate([-base_x/2, -base_y/2, 0])
            cube([wall_end_t, base_y, wall_height]);
        translate([base_x/2 - wall_end_t, -base_y/2, 0])
            cube([wall_end_t, base_y, wall_height]);
        // Ribs
        for (rx = [-36, -18, 0, 18, 36]) {
            translate([rx - wall_rib_t/2, -wall_depth/2, 0])
                cube([wall_rib_t, wall_depth, wall_height]);
        }
    }

    // Holes (Cutting through the deck)
    // We extend the hole height to ensure it cuts through the deck completely
    for (i = [0 : cols - 1]) {
        for (j = [0 : rows - 1]) {
            translate([
                (i * hole_pitch) - hole_offset_x, 
                (j * hole_pitch) - hole_offset_y, 
                deck_z_min - 1
            ])
                cube([hole_size, hole_size, (deck_z_max - deck_z_min) + 2]);
        }
    }
}