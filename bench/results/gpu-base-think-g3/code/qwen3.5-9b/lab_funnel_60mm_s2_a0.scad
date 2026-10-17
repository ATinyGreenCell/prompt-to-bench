// Dimensions
    spout_od = 10;
    spout_id = 6.8;
    spout_height = 20;
    funnel_top_od = 60;
    funnel_bottom_od = 10;
    funnel_top_z = 50;
    funnel_bottom_z = 20;
    wall_thickness = 1.6;
    fn = 64;

    // Derived dimensions
    spout_outer_r = spout_od / 2;
    spout_inner_r = spout_id / 2;
    cone_bottom_outer_r = funnel_bottom_od / 2;
    cone_top_outer_r = funnel_top_od / 2;
    cone_bottom_inner_r = spout_inner_r;
    cone_top_inner_r = (funnel_top_od - 2 * wall_thickness) / 2;

    // Z offsets for void extension (Rule 5)
    void_extension = 0.05;

    difference() {
        // Outer Solid
        union() {
            // Spout
            translate([0, 0, 0])
                cylinder(h = spout_height, r = spout_outer_r, $fn = fn);
            
            // Cone
            translate([0, 0, spout_height])
                cylinder(h = funnel_top_z - funnel_bottom_z, 
                         r1 = cone_bottom_outer_r, 
                         r2 = cone_top_outer_r, 
                         $fn = fn);
        }

        // Inner Void (Cutting Shape)
        // Extend past z=0 and z=50 to ensure no coplanar faces
        union() {
            // Inner Spout Void
            translate([0, 0, -void_extension])
                cylinder(h = spout_height + 2 * void_extension, 
                         r = spout_inner_r, 
                         $fn = fn);
            
            // Inner Cone Void
            translate([0, 0, spout_height - void_extension])
                cylinder(h = (funnel_top_z - funnel_bottom_z) + 2 * void_extension, 
                         r1 = cone_bottom_inner_r, 
                         r2 = cone_top_inner_r, 
                         $fn = fn);
        }
    }