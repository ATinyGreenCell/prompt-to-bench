// Dimensions in millimetres
$fn = 64;
D_rod = 12.7;      // Inner diameter of rod ring
W_rod_wall = 3;    // Wall thickness of rod ring
H_clip_height = 10; // Total height (Z) of extrusion

// Rod ring: centered at origin, cut on -X side
rod_cut = rotate([0, 90, 0], -90) *
         linear_extrude(height=H_clip_height) *
             polygon(points=[[-5, -5], [5, -5], [5, 5]]);

// Rod ring: cylinder minus cut
rod_ring = difference(
    cylinder(D=(D_rod + W_rod_wall*2), h=H_clip_height),
    translate([-W_rod_wall/2, 0, 0]) * rod_cut
);

// Tubing ring: offset to x = 15, cut on +X side
tubing_cut = rotate([0, 90, 0], -90) *
            linear_extrude(height=H_clip_height) *
                polygon(points=[[-2.25, -2.25], [2.25, -2.25], [2.25, 2.25]]);

tubing_ring = difference(
    cylinder(D=(6 + 4), h=H_clip_height),
    translate([D_rod/2 + W_rod_wall + 3 + (6+4)/2 + 1, 0, 0]) * tubing_cut
);

// Bridge: solid connection between rings
bridge = difference(
    cube(size=[6, H_clip_height, H_clip_height]),
    union(
        rotate([90, 0, 0], -45) * rod_cut,
        rotate([90, 0, 0], 45) * rod_cut
    )
);

// Final assembly: union of all parts with proper positioning
final_clip = difference(
    union(rod_ring, translate([D_rod/2 + W_rod_wall + 3, 0, 0]) * tubing_ring),
    translate([D_rod/2 + W_rod_wall + 15 - 6/2, 0, 0]) * bridge
);

// Extrude the profile to create a flat printable part
extruded_clip = linear_extrude(height=H_clip_height) final_clip;