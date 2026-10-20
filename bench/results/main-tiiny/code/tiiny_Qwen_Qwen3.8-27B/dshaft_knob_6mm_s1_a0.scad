// Replacement knob for a 6 mm D-shaft hotplate stirrer
// Print orientation: hotplate-facing side down on the bed (z = 0), builds +Z.

// ---- Dimensions (mm) ----
knob_dia       = 30;   // outer cylinder diameter
knob_h         = 15;   // knob height
knob_r         = knob_dia / 2;

bore_d         = 6.2;  // D-bore circle diameter
bore_r         = bore_d / 2;
bore_flat      = 4.7;  // distance from flat side to opposite side of circle
bore_depth     = 12;   // blind bore depth from bottom face

groove_d       = 2;    // grip groove half-cylinder diameter
groove_r       = groove_d / 2;
groove_n       = 18;   // number of grip grooves

ptr_w          = 1.5;  // pointer groove width
ptr_d          = 1;    // pointer groove depth

// ---- Derived ----
// Flat is on the +X side; distance from flat to opposite (-X) side = bore_flat
flat_x         = bore_flat - bore_r;   // x position of the flat plane

// ---- Base knob ----
$fn = 64;

knob = cylinder(h = knob_h, d = knob_dia, $fn = 64);

// ---- D-shaped blind bore (cut from bottom, 12 mm deep) ----
// Circle + flat on +X side, extruded 12 mm up from z = 0
d_bore = linear_extrude(height = bore_depth, convexity = 10)
    difference(
        circle(r = bore_r, $fn = 64),
        translate([flat_x, 0]) square([1, 1], center = false)  // cut everything x >= flat_x
    );

// ---- Grip grooves: 18 half-cylinders centred on the outer surface ----
// Each groove is a full cylinder of radius groove_r whose centre sits on the
// knob's outer radius; the inner half bites into the knob, the outer half is
// outside and harmless.
grip_grooves = for (i = [0:groove_n-1])
    rotate([0, 0, i * 360 / groove_n])
        translate([knob_r, 0, 0])
            cylinder(h = knob_h, d = groove_d, $fn = 32);

// ---- Pointer groove on top face (1.5 wide, 1 deep, centre to edge, +X side) ----
// A box 1.5 wide (Y), 1 deep (Z), long enough to reach the edge, cut from top.
ptr_groove = translate([-0.01, -ptr_w/2, knob_h - ptr_d])
    cube([knob_r + 0.01, ptr_w, ptr_d + 0.01]);

// ---- Final part ----
difference(
    knob,
    d_bore,
    grip_grooves,
    ptr_groove
);