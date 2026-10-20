// Lab Funnel Dimensions
// All dimensions in millimetres

// Spout dimensions
spout_od = 10;        // Outer diameter of the straight spout
spout_length = 20;    // Length of the straight spout (z=0 to z=20)
wall_thickness = 1.6; // Wall thickness everywhere

// Cone dimensions
cone_bottom_od = 10;  // Outer diameter at the bottom of the cone (z=20)
cone_top_od = 60;     // Outer diameter at the rim of the cone (z=50)
cone_height = 30;     // Height of the cone (z=20 to z=50)
total_height = 50;    // Total height of the funnel

// Derived dimensions
spout_id = spout_od - 2 * wall_thickness; // Inner diameter of the spout
cone_bottom_id = cone_bottom_od - 2 * wall_thickness; // Inner diameter at cone bottom
cone_top_id = cone_top_od - 2 * wall_thickness;       // Inner diameter at cone top

// Safety margin for boolean operations
margin = 0.05;

// Build the spout (cylinder from z=0 to z=20)
spout_outer = cylinder(h=spout_length + margin, d=spout_od, center=false, $fn=64);
spout_inner = cylinder(h=spout_length + margin, d=spout_id, center=false, $fn=64);

// Build the cone (frustum from z=20 to z=50)
// The cone sits on top of the spout.
// Bottom radius (at z=20)
r_bottom = cone_bottom_od / 2;
// Top radius (at z=50)
r_top = cone_top_od / 2;

// Inner frustum for the cone
// Bottom inner radius
r_bottom_inner = cone_bottom_id / 2;
// Top inner radius
r_top_inner = cone_top_id / 2;

// Create the outer cone shape
// We use linear_extrude or a frustum. OpenSCAD doesn't have a direct frustum primitive,
// so we use a cylinder with different top/bottom radii.
cone_outer = cylinder(h=cone_height + margin, d1=cone_bottom_od, d2=cone_top_od, center=false, $fn=64);

// Create the inner void for the cone
// The inner void starts at z=20 (top of spout) and goes to z=50.
// However, the spout's inner void is already defined. We need to subtract the cone's inner void.
// The cone's inner void is a frustum from z=20 to z=50.
cone_inner = cylinder(h=cone_height + margin, d1=cone_bottom_id, d2=cone_top_id, center=false, $fn=64);

// Combine the spout and cone into a single solid
funnel_solid = union() {
    translate([0, 0, 0]) spout_outer;
    translate([0, 0, spout_length]) cone_outer;
};

// Subtract the inner voids
// Spout inner void: cylinder from z=0 to z=20
spout_void = translate([0, 0, 0]) cylinder(h=spout_length + margin, d=spout_id, center=false, $fn=64);

// Cone inner void: frustum from z=20 to z=50
cone_void = translate([0, 0, spout_length]) cylinder(h=cone_height + margin, d1=cone_bottom_id, d2=cone_top_id, center=false, $fn=64);

// Final part: Solid minus voids
funnel = difference() {
    funnel_solid;
    spout_void;
    cone_void;
};

// Render the final part
render() {
    translate([0, 0, 0]) funnel;
}