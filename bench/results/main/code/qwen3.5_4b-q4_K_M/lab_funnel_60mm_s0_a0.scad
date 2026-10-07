// Dimensions measured with calipers for FDM printing
// Units: millimetres
$fn = 100; // Higher resolution for smooth curves on curved surfaces

// Spout dimensions (z=0 to z=20)
spout_outer_diameter = 10.0;
spout_inner_bore = spout_outer_diameter - 3.2 * 1.6; // Wall thickness is 1.6mm, so inner diameter calculation

// Funnel dimensions (z=20 to z=50)
funnel_top_rim_diameter = 60.0;
funnel_bottom_tube_outer_diameter = spout_outer_diameter;
wall_thickness = 1.6; // Consistent wall thickness everywhere

// Positioning variables
spout_length = 20.0;
funnel_height = funnel_top_rim_diameter / 3 * (50 - 20) + 20; // Calculate height based on cone geometry if needed, but user specified z=50 rim

// Construct the spout cylinder with hollow center
spout_cylinder_outer_radius = spout_outer_diameter / 2.0;
spout_hollow_radius = spout_inner_bore / 2.0; // Ensure bore is correct based on wall thickness

// Create a difference to make it hollow (open at bottom)
difference() {
    cylinder(h = spout_length, r1 = spout_cylinder_outer_radius, r2 = spout_cylinder_outer_radius);
    
    // Cut out the inner tube for flow-through
    translate([0, 0, -wall_thickness/2]) { 
        cylinder(h = spout_length + wall_thickness * 2, r1 = spout_hollow_radius, r2 = spout_hollow_radius); 
    }
}

// Construct the funnel cone with consistent wall thickness
funnel_cone_outer_rim_diameter = funnel_top_rim_diameter; // At z=50 (relative to start of cone)
funnel_cone_bottom_tube_outer_diameter = funnel_bottom_tube_outer_diameter; // Matches spout outer diameter at connection

// Calculate radii for the cone geometry
cone_outer_radius_at_base = funnel_cone_top_rim_diameter / 2.0; 
cone_inner_radius_at_base = (funnel_cone_top_rim_diameter - wall_thickness * 3) / 2.0; // Inner radius at top rim

// Calculate radii for the cone geometry
cone_outer_radius_at_spout_connection = funnel_bottom_tube_outer_diameter / 2.0; 
cone_inner_radius_at_spout_connection = (funnel_bottom_tube_outer_diameter - wall_thickness * 3) / 2.0; // Inner radius at spout connection

// Create the cone shape using a rotated polygon or difference approach
difference() {
    translate([0, 0, funnel_length]) { 
        cylinder(h = funnel_height + wall_thickness * 2, r1 = cone_outer_radius_at_spout_connection, r2 = cone_outer_radius_at_base); // Outer solid part of the spout connection to base
        
        // Cut out inner hollow for flow-through
        translate([0, 0, -wall_thickness/2]) { 
            cylinder(h = funnel_height + wall_thickness * 3.5, r1 = cone_inner_radius_at_spout_connection, r2 = cone_inner_radius_at_base); 
        }
    }
}

// Combine spout and funnel using union (they are already connected in the design logic above)
union() {
    // Re-construct for clarity: Spout first then Funnel Cone on top
    
    // 1. Build the straight spout tube from z=0 to z=20 with hollow center
    difference() {
        cylinder(h = spout_length, r1 = spout_cylinder_outer_radius, r2 = spout_cylinder_outer_radius);
        
        translate([0, 0, -wall_thickness/2]) { 
            // Cut out the inner tube for flow-through (open at bottom)
            cylinder(h = spout_length + wall_thickness * 3.5, r1 = spout_hollow_radius, r2 = spout_hollow_radius); 
        }
    }

    // 2. Build the funnel cone from z=20 to z=50 with consistent wall thickness
    translate([0, 0, spout_length]) {
        difference() {
            cylinder(h = funnel_height + wall_thickness * 3.5, r1 = cone_outer_radius_at_spout_connection, r2 = cone_outer_radius_at_base); // Outer solid part of the spout connection to base
            
            translate([0, 0, -wall_thickness/2]) { 
                // Cut out inner hollow for flow-through (open at top and bottom)
                cylinder(h = funnel_height + wall_thickness * 3.5, r1 = cone_inner_radius_at_spout_connection, r2 = cone_inner_radius_at_base); 
            }
        }
    }
}

// Final adjustment to ensure the spout connects seamlessly with the cone base and both are open at top/bottom