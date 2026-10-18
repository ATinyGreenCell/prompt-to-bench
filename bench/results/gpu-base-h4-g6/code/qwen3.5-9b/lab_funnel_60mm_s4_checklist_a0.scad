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
    // 1. The outer shell (Union of Spout and Cone)
    union() {
        // Spout: Cylinder from z=0 to z=20
        translate([0, 0, 0]) 
            cylinder(h = spout_h, d = spout_od);
        
        // Cone: From z=20 to z=50
        // We use a cone shape and translate it to start at z=20
        translate([0, 0, 20]) 
            cone(d1 = cone_bottom_od, d2 = cone_top_od, h = cone_h);
    }
    
    // 2. The inner void (Difference to cut out the hole)
    // We need to cut out the spout bore and the cone bore.
    // Since the cone widens, we can model the inner void as a single tapered cylinder
    // that matches the inner dimensions at the junction and top.
    
    // Inner void: Tapered cylinder from z=0 to z=50
    // At z=0, diameter is spout_id.
    // At z=20, diameter is cone_bottom_id.
    // At z=50, diameter is cone_top_id.
    
    // We construct this void by extruding a polygon profile or using a cone.
    // Since the slope changes at z=20, we use a union of two cylinders/cones for the void
    // to ensure the cut is perfect, or simply one long tapered cone if the slopes align.
    // Let's check slopes:
    // Spout slope: 0 (vertical)
    // Cone outer slope: (60-10)/30 = 1.66
    // Cone inner slope: (53.4-6.8)/30 = 1.55
    // The inner void is a vertical cylinder for the first 20mm, then a cone.
    
    union() {
        // Void Spout: Vertical cylinder from z=0 to z=20
        translate([0, 0, 0]) 
            cylinder(h = spout_h, d = spout_id);
        
        // Void Cone: From z=20 to z=50
        translate([0, 0, 20]) 
            cone(d1 = cone_bottom_id, d2 = cone_top_id, h = cone_h);
    }
}