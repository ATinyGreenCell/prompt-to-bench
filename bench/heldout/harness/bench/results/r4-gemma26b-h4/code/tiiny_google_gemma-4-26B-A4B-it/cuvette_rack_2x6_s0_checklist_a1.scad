// Open-sided cuvette rack for twelve 12.5mm square cuvettes.
// Corrected to ensure a single manifold body and holes only in the deck.

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
hole_offset_x = (cols - 1) * hole_pitch / 2;
hole_offset_y = (rows - 1) * hole_pitch / 2;

// --- Geometry ---

module walls_and_base() {
    // Base Plate
    translate([-base_x/2, -base_y/2, 0])
        cube([base_x, base_y, base_z]);

    // End Walls (Flush with short ends)
    // Left end wall
    translate([-base_x/2, -base_y/2, 0])
        cube([wall_end_t, base_y, wall_height]);
    // Right end wall
    translate([base_x/2 - wall_end_t, -base_y/2, 0])
        cube([wall_end_t, base_y, wall_height]);

    // Internal Ribs
    for (rx = [-36, -18, 0, 18, 36]) {
        translate([rx - wall_rib_t/2, -wall_depth/2, 0])
            cube([wall_rib_t, wall_depth, wall_height]);
    }
}

module deck_only() {
    translate([-deck_x/2, -deck_y/2, deck_z_min])
        cube([deck_x, deck_y, deck_z_max - deck_z_min]);
}

// Final Assembly
// We use union to join base/walls, then union the deck, 
// then difference the holes ONLY from the deck.
union() {
    walls_and_base();
    
    // The deck is handled separately to allow hole subtraction without affecting walls/base
    difference() {
        deck_only();
        
        // Holes (Cutting through the deck)
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                translate([
                    (i * hole_pitch) - hole_offset_x, 
                    (j * hole_pitch) - hole_offset_y, 
                    deck_z_min - 0.1 // Ensure it cuts through the bottom of the deck
                ])
                    cube([hole_size, hole_size, (deck_z_max - deck_z_min) + 0.2]);
            }
        }
    }
}