// 50 mL conical tube rack – printed upside-down, then flipped.
// Print orientation: flat plate on the bed (z = 0..4), walls rising +Z.
// After flipping: rack stands on the two walls; tubes pass through the holes.

// ---- Plate ----
plate_x = 130;   // plate length along X (mm)
plate_y = 90;    // plate width  along Y (mm)
plate_t = 4;     // plate thickness (mm)

// ---- Tube holes ----
hole_d  = 30.5;  // through-hole diameter (mm)
hole_r  = hole_d / 2;
pitch   = 40;    // centre-to-centre spacing in both X and Y (mm)

// ---- Side walls (run along the two long edges, i.e. along X) ----
wall_len  = 130; // wall length along X (mm)
wall_thk  = 10;  // wall thickness along Y (mm) – thick enough to bridge the gap
wall_h    = 70;  // wall height above z = 0 (mm)

// ---- Internal cross-brace (spans the gap between the two walls so the
//      plate top is a flat, supported surface and needs no bridging) ----
brace_thk = 10;  // brace thickness (mm)

$fn = 64;

// ------------------------------------------------------------------
// Base plate, centred on the origin in X and Y, sitting on z = 0.
// ------------------------------------------------------------------
module plate() { translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]); }

// ------------------------------------------------------------------
// Six through-holes: 2 rows (Y) x 3 columns (X), 40 mm pitch, centred.
// Cylinders extend 1 mm past each face of the 4 mm plate (z = -1..5)
// so no cut face is exactly coplanar with the plate faces.
// ------------------------------------------------------------------
module holes() { for (i = [-1, 0, 1], j = [-1, 1])
    translate([i * pitch, j * pitch, -1])
        cylinder(h = plate_t + 2, r = hole_r, $fn = $fn); }

// ------------------------------------------------------------------
// Two solid walls along the long edges, flush with the plate edges.
// Each wall: 130 (X) x 10 (Y) x 70 (Z), rising from z = 0 to z = 70.
// ------------------------------------------------------------------
module walls() { union()
    // wall on the +Y edge (flush with y = +plate_y/2)
    translate([-wall_len/2,  plate_y/2 - wall_thk, 0])
        cube([wall_len, wall_thk, wall_h]);
    // wall on the -Y edge (flush with y = -plate_y/2)
    translate([-wall_len/2, -plate_y/2, 0])
        cube([wall_len, wall_thk, wall_h]); }

// ------------------------------------------------------------------
// Internal cross-brace: a 10 mm-thick strip along X at the centre, plus
// a 10 mm-thick strip along Y, both rising from the plate to z = 70.
// The X strip spans the 70 mm gap between the walls, so the plate top
// is a flat, supported surface (no bridging / no supports needed).
// The Y strip is centred on the plate and clears the tube holes.
// ------------------------------------------------------------------
module brace() { union()
    translate([-wall_len/2, -brace_thk/2, 0])
        cube([wall_len, brace_thk, wall_h]);
    translate([-brace_thk/2, -plate_y/2, 0])
        cube([brace_thk, plate_y, wall_h]); }

// ------------------------------------------------------------------
// Final part: plate + walls + brace, with the six through-holes cut.
// ------------------------------------------------------------------
difference() {
    union() {
        plate();
        walls();
        brace();
    }
    holes();
}