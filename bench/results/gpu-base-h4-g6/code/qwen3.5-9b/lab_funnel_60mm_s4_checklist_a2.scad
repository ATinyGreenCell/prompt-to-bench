// Small lab funnel - straight spout with conical top, printed upright.
// Dimensions measured with calipers.

// Spout dimensions
spout_od = 10;
spout_id = 6.8;
spout_h  = 20;

// Cone dimensions
cone_bottom_od = 10;
cone_top_od    = 60;
cone_h         = 30; // from z=20 to z=50

// Wall thickness
wall = 1.6;

// Geometry helpers
$fn = 64;

// Calculate inner dimensions for the cone
cone_bottom_id = cone_bottom_od - 2 * wall;
cone_top_id    = cone_top_od - 2 * wall;

// Build the solid part
difference() {
    // 1. The outer shell (Single continuous profile extruded)
    // Profile points: [radius, height]
    // z=0 to z=20: radius = 5 (spout_od/2)
    // z=20 to z=50: radius grows from 5 to 30 (cone_top_od/2)
    translate([0, 0, 0])
        rotate_extrude($fn = 64)
            polygon([
                [spout_od/2, 0],
                [spout_od/2, spout_h],
                [cone_top_od/2, spout_h + cone_h],
                [cone_top_od/2, spout_h],
                [spout_od/2, 0]
            ]);
    
    // 2. The inner void (Single continuous profile extruded)
    // Profile points: [radius, height]
    // z=0 to z=20: radius = 3.4 (spout_id/2)
    // z=20 to z=50: radius grows from 3.4 to 26.7 (cone_top_id/2)
    translate([0, 0, 0])
        rotate_extrude($fn = 64)
            polygon([
                [spout_id/2, 0],
                [spout_id/2, spout_h],
                [cone_top_id/2, spout_h + cone_h],
                [cone_top_id/2, spout_h],
                [spout_id/2, 0]
            ]);
}