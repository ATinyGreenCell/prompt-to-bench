// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints standing upright along Z, centred on origin.

$fn = 128;

// Dimensions
z_start = 0;
z_8mm_end = 20;
z_collar_start = 20;
z_collar_end = 25;
z_5mm_end = 41;

// 8mm Tubing Barbs (z = 0 to 20)
// Two stacked barbs, each 10mm tall.
// Profile: OD grows 7.5 -> 9.5, then steps back to 7.5.
barb_8_height = 10;
barb_8_bottom_od = 7.5;
barb_8_top_od = 9.5;
barb_8_step_od = 7.5;

// 5mm Tubing Barbs (z = 25 to 41)
// Two stacked barbs, each 8mm tall.
// Profile: OD shrinks 6.5 -> 5.0, then steps back to 6.5.
barb_5_height = 8;
barb_5_bottom_od = 6.5;
barb_5_top_od = 5.0;
barb_5_step_od = 6.5;

// Common features
bore_diameter = 3;
collar_diameter = 12;

// Generate the 8mm barb profile points for rotate_extrude
// We need the profile from z=0 to z=20.
// Barb 1: z=0 to 10. Barb 2: z=10 to 20.
// Each barb: OD grows linearly, then steps.
// Since we are extruding a 2D profile around Z, the profile is (radius, z).
// We define the profile from z=0 to z=20.

// Barb 1 (z=0 to 10):
// Radius starts at barb_8_bottom_od/2.
// At z=10, radius is barb_8_top_od/2.
// Then step down to barb_8_step_od/2 at z=10.
// Barb 2 (z=10 to 20):
// Radius starts at barb_8_step_od/2.
// At z=20, radius is barb_8_top_od/2.

// Construct the list of points for the 8mm section
// Format: [radius, z]
profile_8mm = [
    [barb_8_bottom_od / 2, 0],
    [barb_8_top_od / 2, barb_8_height],
    [barb_8_step_od / 2, barb_8_height],
    [barb_8_step_od / 2, 2 * barb_8_height],
    [barb_8_top_od / 2, 2 * barb_8_height]
];

// Generate the 5mm barb profile points for rotate_extrude
// Section z=25 to z=41.
// Barb 1: z=25 to 33. Barb 2: z=33 to 41.
// Each barb: OD shrinks linearly, then steps.
// Barb 1 (z=25 to 33):
// Radius starts at barb_5_bottom_od/2.
// At z=33, radius is barb_5_top_od/2.
// Then step down to barb_5_step_od/2 at z=33.
// Barb 2 (z=33 to 41):
// Radius starts at barb_5_step_od/2.
// At z=41, radius is barb_5_top_od/2.

profile_5mm = [
    [barb_5_bottom_od / 2, 25],
    [barb_5_top_od / 2, 25 + barb_5_height],
    [barb_5_step_od / 2, 25 + barb_5_height],
    [barb_5_step_od / 2, 25 + 2 * barb_5_height],
    [barb_5_top_od / 2, 25 + 2 * barb_5_height]
];

difference() {
    union() {
        // 8mm Barbs Section (z=0 to 20)
        // Using rotate_extrude to build the 3D shape from the (radius, z) profile
        rotate_extrude() polygon(profile_8mm);

        // Collar Section (z=20 to 25)
        // This is a cylinder of diameter 12 from z=20 to z=25
        translate([0, 0, 20]) cylinder(h = 5, d = collar_diameter);

        // 5mm Barbs Section (z=25 to 41)
        // Using rotate_extrude to build the 3D shape from the (radius, z) profile
        translate([0, 0, 25]) rotate_extrude() polygon(profile_5mm);
    }

    // Bore through the entire length
    // The bore needs to extend slightly past the part to ensure clean cutting
    translate([0, 0, -1]) cylinder(h = z_5mm_end + 2, d = bore_diameter);
}