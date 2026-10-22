$fn = 128; // High resolution for smooth cone and round holes

// --- Dimensions ---
// Spout (Tube)
$spout_outer_d = 10;
$spout_inner_d = 6.8; // 10 - 2*1.6
$spout_height = 20;

// Cone
$cone_bottom_d = 10; // Matches spout outer diameter
$cone_top_d = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// --- Construction ---

// 1. Create the Spout (Cylinder with hole)
// Outer cylinder
spout_outer = cylinder(
    h = $spout_height,
    r = $spout_outer_d / 2,
    center = [0, 0, $spout_height / 2],
    $fn = 64
);

// Inner cylinder (bore)
spout_inner = cylinder(
    h = $spout_height,
    r = $spout_inner_d / 2,
    center = [0, 0, $spout_height / 2],
    $fn = 64
);

// 2. Create the Cone (Linear Extrusion)
// The cone widens from 10mm (at z=20) to 60mm (at z=50).
// We define the profile at z=0 (bottom of cone) and z=1 (top of cone) for linear_extrude.
// Bottom radius: 5mm, Top radius: 30mm.
cone_profile = [
    [0, 0, 0],
    [$cone_bottom_d / 2, 0, 0],
    [0, 0, 0],
    [$cone_top_d / 2, 0, 1],
    [0, 0, 1],
    [0, 0, 0]
];

cone = linear_extrude(
    center = [0, 0, 0],
    scale = 1,
    twist = 0,
    convexity = 3,
    $fn = 64
)(cone_profile);

// 3. Assemble the Solid Funnel
// Union the spout and the cone. 
// The cone starts at z=0 in our local coords, but physically it sits on top of the spout.
// Since we are building upright from Z=0, the spout is 0-20, and the cone is 20-50.
// We need to translate the cone up by 20mm so its bottom aligns with the spout top.
funnel_base = union(
    spout_outer,
    spout_inner,
    translate([0, 0, $spout_height])(cone)
);

// 4. Cut the Holes
// We need to subtract the inner bore of the spout and the inner cone wall.
// To ensure clean cuts, we extend the cutting shapes slightly past the faces (Rule 5).

// Cut Spout Bore (extend 0.1mm past top and bottom)
cut_spout_bore = cylinder(
    h = $spout_height + 0.2,
    r = $spout_inner_d / 2,
    center = [0, 0, $spout_height / 2],
    $fn = 64
);

// Cut Cone Bore
// The cone bore goes from z=20 to z=50.
// Bottom radius at z=20: 5mm.
// Top radius at z=50: 30mm.
// We extend 0.1mm past the top and bottom faces of the cone section.
cut_cone_bore = linear_extrude(
    center = [0, 0, 0],
    scale = 1,
    twist = 0,
    convexity = 3,
    $fn = 64
)([
    [0, 0, 0],
    [$cone_bottom_d / 2, 0, 0],
    [0, 0, 0],
    [$cone_top_d / 2, 0, 1],
    [0, 0, 1],
    [0, 0, 0]
]);

// Translate the cone cut profile up by 20mm to match the funnel assembly
cut_cone_bore_final = translate([0, 0, $spout_height])(cut_cone_bore);

// Final Difference
funnel = difference(
    funnel_base,
    cut_spout_bore,
    cut_cone_bore_final
);

// Center the final part on the origin in X and Y (already done by construction)
// It rests on XY plane at z=0.
translate([0, 0, 0])(funnel);