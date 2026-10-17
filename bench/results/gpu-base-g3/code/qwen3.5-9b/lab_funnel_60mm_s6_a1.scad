// Lab Funnel Design
// Units: millimetres
// Orientation: Upright, wide opening at top, rests on XY plane at z=0.

// --- Dimensions ---
// Spout (Tube)
$spout_outer_diameter = 10;
$spout_inner_diameter = 6.8; // 10 - 2*1.6
$spout_length = 20;

// Cone (Funnel Body)
$cone_bottom_diameter = 10; // Matches spout outer diameter
$cone_top_diameter = 60;
$cone_height = 30; // From z=20 to z=50

// Wall Thickness
$wall_thickness = 1.6;

// Resolution for smooth curves
$fn = 128;

// --- Helper Functions ---

// Creates a hollow cylinder (tube)
module hollow_cylinder(outer_d, inner_d, height) {
    difference() {
        cylinder(h = height, d = outer_d, $fn = $fn);
        cylinder(h = height, d = inner_d, $fn = $fn);
    }
}

// Creates a hollow cone (frustum)
// bottom_d: diameter at the smaller end (attached to spout)
// top_d: diameter at the larger end (rim)
// height: vertical height of the cone
module hollow_cone(bottom_d, top_d, height) {
    difference() {
        // Outer Cone
        rotate_extrude(angle = 360) {
            // Define the profile for the outer wall
            // We use a polygon with two points: bottom radius and top radius
            // The extrusion happens along the Z axis relative to the profile
            // Since we are rotating, the profile is in the XZ plane (or XY if we rotate differently, 
            // but standard rotate_extrude assumes the profile is in the plane perpendicular to the axis of rotation).
            // Actually, rotate_extrude rotates around the Z axis. The profile must be in the XZ plane? 
            // No, rotate_extrude rotates the profile around the Z axis. The profile is usually defined in the XY plane 
            // but extruded along Z? No.
            // Correct logic: rotate_extrude rotates the profile around the Z axis. The profile is a 2D shape in the XZ plane? 
            // No, OpenSCAD's rotate_extrude rotates the profile around the Z axis. The profile is defined in the XY plane? 
            // Let's stick to the standard: rotate_extrude rotates the profile around the Z axis. 
            // The profile is a 2D shape. If we want a cone, the profile is a line from (0, r_bottom) to (height, r_top) in the XZ plane? 
            // No, rotate_extrude rotates the profile around the Z axis. The profile is in the XZ plane? 
            // Actually, the simplest way is to define the profile in the XZ plane and rotate it? 
            // No, rotate_extrude rotates the profile around the Z axis. The profile is in the XY plane? 
            // Let's use the standard pattern: 
            // rotate_extrude(angle=360) { linear_extrude(height=height) polygon(...) } -> This is wrong.
            
            // Correct pattern for a cone using rotate_extrude:
            // The profile is a line segment in the XZ plane? No.
            // The profile is a line segment in the XY plane? No.
            // The profile is a line segment in the XZ plane, and we rotate it around the Z axis? 
            // No, rotate_extrude rotates the profile around the Z axis. The profile is in the XZ plane? 
            // Let's try this: 
            // rotate_extrude(angle=360) { 
            //     polygon(points=[[0, bottom_d/2], [height, top_d/2]]) 
            // }
            // This will rotate the line segment around the Z axis. The line segment is in the XZ plane? 
            // No, the points are [x, y]. So [0, bottom_d/2] is on the Y axis. [height, top_d/2] is at x=height, y=top_d/2.
            // Rotating this around the Z axis creates a cone.
            
            polygon(points = [
                [0, bottom_d/2],
                [height, top_d/2]
            ], coords = [X, Y]);
        }
        
        // Inner Cone (Hole)
        rotate_extrude(angle = 360) {
            inner_bottom = bottom_d - $wall_thickness * 2;
            inner_top = top_d - $wall_thickness * 2;
            
            polygon(points = [
                [0, inner_bottom/2],
                [height, inner_top/2]
            ], coords = [X, Y]);
        }
    }
}

// --- Main Assembly ---
// The funnel rests on the XY plane at z=0.
// The spout runs from z=0 to z=20.
// The cone sits on top of the spout, from z=20 to z=50.

translate([0, 0, 0]) {
    // 1. Build the Spout (Tube)
    hollow_cylinder(outer_d = $spout_outer_diameter, 
                    inner_d = $spout_inner_diameter, 
                    height = $spout_length);

    // 2. Build the Cone (Funnel Body)
    // Sits on top of the spout.
    // Bottom diameter (at z=20) = 10
    // Top diameter (at z=50) = 60
    // Height = 30
    hollow_cone(bottom_d = $cone_bottom_diameter, 
                top_d = $cone_top_diameter, 
                height = $cone_height);
}