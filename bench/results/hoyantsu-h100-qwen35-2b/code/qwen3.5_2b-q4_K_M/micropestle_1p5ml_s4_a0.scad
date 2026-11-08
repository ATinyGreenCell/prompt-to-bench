// Design a pestle for grinding tissue inside a 1.5 mL microcentrifuge tube, printed standing upright.

// Dimensions in millimeters (measured with calipers)
const mm = 1; // Conversion factor to mm if needed, though we are working directly in mm here
const fn = 64; // Number of segments for curved surfaces

// Define the handle dimensions and groove positions
const handle_diameter = 8.0;
const handle_height = 45.0;
const tip_z_start = 62.0;
const tip_tip_diameter = 3.0;
const tip_tip_radius = 1.5;

// Groove parameters: width (Z), depth (Z)
const groove_width = 2.0;
const groove_depth = 1.0;
const groove_positions = [10, 15, 20, 25]; // Z positions of the grooves in mm

// Create a helper function to create a circular polygon for holes or slots
// This ensures the shape is closed and centered on the origin (or specified point)
function make_circle(center_x = 0, center_y = 0, radius = 1.0, segments = fn) {
    var p = [];
    for (i = 0; i < segments; i++) {
        // Calculate angle in radians
        var theta = i * (2 * pi / segments);
        
        // Convert to cartesian coordinates relative to center
        var x_rel = radius * cos(theta);
        var y_rel = radius * sin(theta);
        
        // Add point to list
        p.push([center_x + x_rel, center_y + y_rel]);
    }
    
    return polygon(p);
}

// Create a circular hole (negative Z) or slot (positive Z) centered at z_pos with given dimensions
function make_circular_feature(center_z = 0, radius = 1.5, segments = fn, direction = -1) {
    var p = [];
    
    // We need to create a circle that extends past the center by 'direction' * radius
    // The total diameter is 2*radius, so we add radius in both directions from the center
    var start_z = center_z + (direction * radius);
    var end_z = center_z - (direction * radius);
    
    for (i = 0; i < segments; i++) {
        var theta = i * (2 * pi / segments);
        
        // Calculate angle in radians relative to the start point on the circle
        var theta_rel = theta - atan(start_z / end_z);
        
        // Convert back to cartesian coordinates relative to center_z
        var x_rel = radius * cos(theta_rel);
        var y_rel = radius * sin(theta_rel);
        
        // Add points: (center_x + x_rel, center_y + y_rel) and (end_z + x_rel, end_z + y_rel)
        p.push([center_x + x_rel, center_y + y_rel]);
        p.push([start_z + x_rel, start_z + y_rel]);
    }
    
    return polygon(p);
}

// Create a rounded tip (sphere-like shape at the bottom of the cone)
function make_tip(center_z = 0, radius = 1.5, segments = fn) {
    var p = [];
    
    // A sphere is defined by x^2 + y^2 + z^2 = r^2
    // We want a segment from center_z - radius to center_z + radius
    
    for (i = 0; i < segments; i++) {
        var theta = i * (2 * pi / segments);
        
        // Calculate angle relative to the start point on the circle
        var theta_rel = theta - atan(center_z / radius);
        
        // Convert back to cartesian coordinates relative to center_z
        var x_rel = radius * cos(theta_rel);
        var y_rel = radius * sin(theta_rel);
        
        p.push([center_x + x_rel, center_y + y_rel]);
    }
    
    return polygon(p);
}

// Main Construction
main() {
    // 1. Create the main body of the pestle (Cylinder)
    // Base diameter: 8mm, Height: 45mm
    var base_diameter = handle_diameter;
    var base_radius = base_diameter / 2;
    
    cylinder(
        radius = base_radius,
        height = handle_height,
        center_x = 0,
        center_y = 0,
        segments = fn
    );

    // 2. Create the tapered cone section
    // Tapers from diameter 8mm at z=45 to diameter 3mm at z=62
    var cone_base_diameter = handle_diameter;
    var cone_base_radius = base_radius;
    
    var cone_tip_diameter = tip_tip_diameter;
    var cone_tip_radius = tip_tip_radius;
    
    // The cone starts at z=45 and ends at z=62. 
    // We extrude from the top (z=45) downwards to z=62.
    linear_extrude(
        height = 17, // 62 - 45
        center_x = 0,
        center_y = 0,
        segments = fn
    );

    // 3. Create the rounded tip (Sphere)
    // Centered at z=62 with radius 1.5mm (3mm diameter / 2)
    sphere(
        radius = cone_tip_radius,
        center_x = 0,
        center_y = 0,
        segments = fn
    );

    // 4. Create the circumferential grooves on the handle
    // We create a hole in the negative Z direction (grinding side) or positive?
    // "For grip" usually implies indentations on the side facing the user's hand.
    // The pestle is standing upright, so the bottom is the grinding end.
    // Let's make grooves on the side of the handle (positive Z relative to base).
    
    for (i = 0; i < groove_positions.length; i++) {
        var z_pos = groove_positions[i];
        
        // Create a circular hole in the negative Z direction from the surface at z_pos
        // This creates an indentation on the side of the handle.
        make_circular_feature(
            center_z = z_pos, 
            radius = groove_width / 2 + cone_tip_radius, // Extend past tip slightly? No, just groove width/2
            segments = fn,
            direction = -1 // Negative Z means going down into the handle material
        );
    }

    // Note: The grooves are defined as holes in the negative Z. 
    // Since we extruded from z=45 downwards to z=62 for the cone tip, 
    // and the handle is below that (z < 45), these cuts will be on the side of the handle.
}