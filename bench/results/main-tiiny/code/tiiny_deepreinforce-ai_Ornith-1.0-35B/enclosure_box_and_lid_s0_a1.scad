// --- Dimensions ---
// Outer box width (X)
box_w = 70;
// Outer box depth (Y)
box_d = 50;
// Outer box height (Z)
box_h = 30;
// Wall thickness
wall_t = 2;
// Floor thickness
floor_t = 2;
// Lid plate thickness
lid_plate_t = 2;
// Lip wall thickness
lip_t = 1.5;
// Lip height
lip_h = 4;
// Lip outer width
lip_ow = 65.6;
// Lip outer depth
lip_od = 45.6;
// Clearance on each side
clearance = 0.2;
// Gap between parts on bed
gap = 10;

// --- Derived ---
// Inner width/depth of box
box_iw = box_w - 2 * wall_t;
box_id = box_d - 2 * wall_t;

// Lip inner width/depth (matches box inner minus clearance)
lip_iw = lip_ow - 2 * lip_t;
lip_id = lip_od - 2 * lip_t;

// Box center offset (box sits on -X side)
box_cx = -(box_w + gap / 2);
box_cy = 0;

// Lid center offset (lid sits on +X side)
lid_cx = (box_w + gap / 2);
lid_cy = 0;

// --- Part 1: Box ---
// Box sits on XY plane, builds upward
translate([box_cx, box_cy, 0]) {
    // Floor
    union() {
        // Outer shell (box_w x box_d x box_h)
        // minus inner cavity (box_iw x box_id x (box_h - floor_t))
        // plus floor slab
        difference() {
            // Full outer block
            cube([box_w, box_d, box_h], center = false);
            // Inner cavity (starts at floor_t, goes to top)
            translate([wall_t, wall_t, floor_t]) {
                cube([box_iw, box_id, box_h - floor_t + 0.01], center = false);
            }
        }
    }
}

// --- Part 2: Lid (printed upside down, so lip points down) ---
// Lid plate lies on bed (z=0), lip extends downward (-Z)
translate([lid_cx, lid_cy, 0]) {
    difference() {
        // Plate + lip combined
        union() {
            // Plate (70 x 50 x 2)
            cube([box_w, box_d, lid_plate_t], center = false);
            // Lip (extends downward from plate bottom)
            translate([
                (box_w - lip_ow) / 2,
                (box_d - lip_od) / 2,
                -lip_h
            ]) {
                cube([lip_ow, lip_od, lip_h], center = false);
            }
        }
        // Hollow out the lip interior (so it's a wall, not solid)
        translate([
            (box_w - lip_iw) / 2,
            (box_d - lip_id) / 2,
            -lip_h + 0.01
        ]) {
            cube([lip_iw, lip_id, lip_h + 0.01], center = false);
        }
    }
}