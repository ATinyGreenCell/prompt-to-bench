// Sowing Template Design for 90 mm Petri Dish
// All dimensions in millimeters.

// Define the main disc parameters
disc_diameter = 85;   // Total diameter of the base disc
disc_thickness = 2;  // Thickness of the disc
rim_width = 10;      // Width of the orientation notch on +Y side
rim_depth = 4;       // Depth of the notch into the rim

// Define the grid parameters
grid_rows = 7;       // Number of rows in the hole pattern
grid_cols = 7;       // Number of columns in the hole pattern
hole_diameter = 3;   // Diameter of each through-hole
spacing = 9;         // Centre-to-centre spacing between holes

// Define the orientation notch parameters
notch_width = rim_width;
notch_depth = rim_depth;

// Set number of features for smoothness in curved surfaces (holes)
fn = 64;

// Create a helper function to create a circular hole pattern using 'for' loop
create_hole_pattern() {
    // Start at the center and step outwards by spacing
    for (i = 0; i < grid_rows * grid_cols; i++) {
        // Calculate position of current hole relative to center
        // We use a linear_extrude with a small offset to ensure the hole is fully inside the disc before cutting, 
        // and then rotate it around the Z axis.
        
        // Determine if this is an even or odd row/column to handle wrapping correctly in for loops
        // However, since we are stepping outwards from center (0,0), simple math works:
        // x = spacing * i / (grid_rows * grid_cols) - (spacing/2)
        // y = spacing * j / (grid_rows * grid_cols) - (spacing/2)
        
        let(x = 0, y = 0);
        if ((i % 2 == 1 && i < grid_rows * grid_cols) || 
            (i % 2 == 0 && i > 0)) { // This logic is slightly complex for simple stepping. 
            // Simpler approach: Just iterate and calculate based on index, handling center carefully
        }
        
        // Let's use a simpler loop structure that iterates through indices directly
        // We will construct the hole geometry explicitly to avoid coordinate confusion
        
    }
}

// Better approach for grid holes using 'for' with explicit coordinates or simple math
create_hole_pattern() {
    let(x = 0, y = 0);
    
    // Iterate through all positions in a square grid centered at (0,0)
    // We can iterate i from -grid_cols/2 to +grid_cols/2 and j similarly
    
    for (i = -floor(grid_cols / 2.0); i <= floor(grid_cols / 2.0); i++) {
        for (j = -floor(grid_rows / 2.0); j <= floor(grid_rows / 2.0); j++) {
            // Calculate distance from center to current hole position
            let(dx = spacing * i, dy = spacing * j);
            
            // Create the circular hole extrusion
            // We use a small offset (0.5mm) so the cut starts slightly outside the theoretical center line 
            // and ends inside the disc edge, ensuring no overlap issues at boundaries.
            let(offset = 0.5);
            
            // Rotate the hole around Z axis to orient it correctly for printing
            rotate_extrude(
                angle = (i * 360 / grid_cols) + j * 360 / grid_rows, 
                height = disc_thickness - offset,
                radius = disc_diameter / 2.0 - offset,
                direction = 'Z',
                thickness = hole_diameter
            );
        }
    }
}

// Create the main body of the template (the flat disc)
main_body() {
    // Extrude the base disc from center to top
    linear_extrude(
        height = disc_thickness,
        radius = disc_diameter / 2.0,
        direction = 'Z',
        thickness = hole_diameter
    );
}

// Create the orientation notch on the +Y side (rim)
notch() {
    // The rim is at z = disc_thickness - offset (where offset is small to ensure it's inside the body)
    // Actually, since we built the body with thickness=hole_diameter, the top surface of the body 
    // starts at z = disc_thickness. We need to cut into this surface.
    
    // The notch sits on the rim. Rim width is 10mm. So it spans from x=-5 to x=5 (relative to center).
    // Depth is 4mm, so it goes from y=+5 to y=-1 (since total height of body is 2mm + offset? No.)
    
    // Let's re-evaluate geometry based on the prompt: "lying on the bed". 
    // Body thickness = 2mm. Notch depth = 4mm. This implies the notch goes through the entire 2mm body and into a backing plate or just cuts deep enough to define the shape.
    
    // To make this printable without overhangs, we usually add a small height for the notch area. 
    // However, prompt says "measured in from the rim". Let's assume the notch is cut into the existing 2mm body surface.
    // If the body is 2mm thick and the notch is 4mm deep, it will overhang significantly if we just extrude a cylinder of height 0.
    
    // Standard practice for these templates: The "body" usually has a backing plate or the user accepts the overhang. 
    // But to ensure it prints as a solid with no errors (as requested), we must add a small height to the notch area so it doesn't float off the Z=0 bed, OR assume the 2mm body is actually thicker in reality and we are just defining the cut.
    
    // Let's interpret "measured in from the rim" as: The physical depth of the hole is 4mm. 
    // To print this cleanly, we will add a small height (e.g., 0.5mm) to the notch area so it sits on the Z=0 bed.
    
    let(notch_height = 0.5); // Small height added for printing stability
    
    // Define the rectangular cutout shape in the rim plane (z = disc_thickness - notch_height)
    // The cut is centered on Y axis. Width = 10mm, Depth = 4mm.
    
    let(notch_x_start = -rim_width / 2);
    let(notch_y_start = -notch_depth);
    let(notch_y_end = rim_width + notch_depth); // Centered at y=0
    
    // Create a polygon (rectangle) for the cutout
    polygon(
        points = [
            notx = notx_start, 
            noty = noty_start, 
            notz = disc_thickness - notch_height;
            notx = notx_start + rim_width, 
            noty = noty_end, 
            notz = disc_thickness - notch_height;
        ],
        direction = 'Z',
        thickness = hole_diameter
    );
    
    // Add a small cylinder to the bottom of this cutout so it sits on the bed (Z=0)
    // This ensures no overhangs and clean support.
    let(notch_bottom_height = 0); 
    rotate_extrude(
        angle = 180, // Rotate 180 degrees to face down? No, we want it flat on Z=0.
        height = notch_bottom_height,
        radius = disc_diameter / 2.0 - notch_depth,
        direction = 'Z',
        thickness = hole_diameter
    );
}

// Final assembly: Union of the main body and the notch to form the complete template
template() {
    union(
        // Main body (the flat disc)
        main_body(),
        
        // Notch cutout on the rim
        notch()
    )
}

// Print orientation settings for FDM printing
print_settings() {
    print_settings = [
        'orientation' = ['Y', 'Z'],
        'material' = 'PLA',
        'layer_height' = 0.2,
        'min_width' = 30, // Ensure the template is wide enough for the printer to handle it if needed (though 85mm is fine)
    ];
}

// Print settings for support generation
print_settings_support() {
    print_settings_support = [
        'support' = ['Z', 'Y'],
        'material' = 'PLA',
        'min_width' = 30,
    ];
}