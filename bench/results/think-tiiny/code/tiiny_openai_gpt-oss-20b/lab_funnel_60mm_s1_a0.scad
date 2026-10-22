$fn = 64;

// Dimensions (mm)
spout_outer_d = 10;          // Outer diameter of spout
spout_length = 20;           // Length of spout
wall_thickness = 1.6;        // Wall thickness everywhere
spout_inner_d = spout_outer_d - 2*wall_thickness; // Bore diameter of spout

funnel_outer_base_d = spout_outer_d; // Base diameter of funnel (matches spout outer)
funnel_outer_top_d = 60;            // Rim diameter of funnel
funnel_length = 30;                 // Length of funnel (from z=20 to z=50)

funnel_inner_base_d = funnel_outer_base_d - 2*wall_thickness; // Bore base diameter
funnel_inner_top_d = funnel_outer_top_d - 2*wall_thickness;   // Bore rim diameter

// Outer solid (spout + funnel)
outer = union() {
    // Spout cylinder
    cylinder(h=spout_length, d=spout_outer_d, center=false);
    // Funnel cone
    translate([0,0,spout_length]) {
        cylinder(h=funnel_length, d1=funnel_outer_base_d, d2=funnel_outer_top_d, center=false);
    }
}

// Bore solid (to be subtracted)
inner = union() {
    // Spout bore cylinder (extends slightly beyond faces)
    translate([0,0,-0.01]) {
        cylinder(h=spout_length+0.02, d=spout_inner_d, center=false);
    }
    // Funnel bore cone (extends slightly beyond faces)
    translate([0,0,spout_length-0.01]) {
        cylinder(h=funnel_length+0.02, d1=funnel_inner_base_d, d2=funnel_inner_top_d, center=false);
    }
}

// Final funnel: outer minus bore
difference() {
    outer;
    inner;
}