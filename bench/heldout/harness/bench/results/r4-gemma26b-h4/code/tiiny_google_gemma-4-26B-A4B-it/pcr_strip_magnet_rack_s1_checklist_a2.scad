// Magnetic Bead Rack for 8-tube strip
// Corrected tube seat geometry to match exact Z-heights and diameters

// --- Dimensions ---
L = 80.0;            // Block length (X)
W = 24.0;            // Block width (Y)
H = 20.0;            // Block height (Z)

tube_count = 8;      // Number of tubes
tube_spacing = 9.0;  // Center-to-center distance of tubes
tube_top_d = 6.4;    // Diameter of tube at top
tube_bot_d = 3.0;    // Diameter of tube at bottom
tube_z_top = 20.0;   // Top face of block
tube_z_mid = 12.0;   // Transition point from cylinder to cone
tube_z_bot = 2.0;    // Bottom of the conical part

mag_len = 60.4;      // Magnet length (X)
mag_wid = 3.3;       // Magnet width (Y)
mag_h   = 10.2;      // Magnet height (Z)
mag_y_offset = 6.0;  // Y offset for magnet centers

$fn = 64;

// --- Geometry Construction ---

difference() {
    // Main Block
    translate([-L/2, -W/2, 0])
        cube([L, W, H]);

    // Tube Seats
    for (i = [0 : tube_count - 1]) {
        let(x_pos = (i - (tube_count - 1) / 2) * tube_spacing) {
            // 1. Cylindrical part: from Z=12 to Z=20
            // Height = 20 - 12 = 8
            translate([x_pos, 0, tube_z_mid])
                cylinder(h = tube_z_top - tube_z_mid + 0.01, d = tube_top_d);
            
            // 2. Conical part: from Z=2 to Z=12
            // Height = 12 - 2 = 10
            // d1 is bottom (at Z=2), d2 is top (at Z=12)
            translate([x_pos, 0, tube_z_bot])
                cylinder(h = tube_z_mid - tube_z_bot + 0.01, d1 = tube_bot_d, d2 = tube_top_d);
        }
    }

    // Magnet Pockets
    // Centered at y = -6 and y = 6. Open at bottom (z=0).
    for (sy = [-mag_y_offset, mag_y_offset]) {
        translate([-mag_len/2, sy - mag_wid/2, -0.1])
            cube([mag_len, mag_wid, mag_h + 0.1]);
    }
}