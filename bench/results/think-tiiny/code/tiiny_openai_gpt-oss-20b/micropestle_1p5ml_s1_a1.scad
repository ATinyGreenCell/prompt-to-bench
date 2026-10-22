$fn = 64; // resolution for curved surfaces

// Dimensions
handle_d = 8;          // diameter of the handle
handle_r = handle_d/2;
handle_h = 45;         // height of the handle

cone_base_d = 8;       // diameter at the base of the cone
cone_base_r = cone_base_d/2;
cone_top_d = 3;        // diameter at the tip of the cone
cone_top_r = cone_top_d/2;
cone_h = 17;           // height of the cone

sphere_d = 3;         // diameter of the spherical tip
sphere_r = sphere_d/2;
sphere_z = 62;         // z‑coordinate of the sphere centre

groove_centers = [10,15,20,25]; // z‑positions of the grooves
groove_depth = 1;      // depth of each groove
groove_width = 2;     // width of each groove in z

// Handle with circumferential grooves
handle = difference() {
    cylinder(r=handle_r, h=handle_h);
    for (c = groove_centers) {
        translate([0,0,c]) difference() {
            cylinder(r=handle_r+0.01, h=groove_width); // outer radius extended slightly
            cylinder(r=handle_r-groove_depth, h=groove_width); // inner radius
        }
    }
};

// Final part: handle + cone + sphere
union() {
    handle;
    translate([0,0,handle_h]) cylinder(r1=cone_base_r, r2=cone_top_r, h=cone_h);
    translate([0,0,sphere_z]) sphere(r=sphere_r);
};