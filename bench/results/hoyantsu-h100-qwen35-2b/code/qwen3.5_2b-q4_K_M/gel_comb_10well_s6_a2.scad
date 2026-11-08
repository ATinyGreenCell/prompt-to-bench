// Design a 10-well comb for casting agarose gels, printed lying flat.
// The whole comb is a flat plate 1.5 mm thick (Z) lying on the bed.
// Seen from above, it has a straight spine (back bar) 70 mm long (X) and 12 mm wide (Y), 
// and 10 rectangular teeth that hang from one long edge of the spine in the -Y direction.
// Each tooth is 5.0 mm wide (X) and 12 mm long (Y). The gaps between neighbouring teeth are 1.5 mm, 
// and the row of teeth is centred on the spine in X.

// Dimensions measured with calipers
length_spine = 70.0; // mm
width_spine = 12.0;   // mm
thickness = 1.5;      // mm
num_teeth = 10;       // teeth along Y axis (from spine edge)
tooth_width = 5.0;    // mm width of each tooth in X direction
tooth_length = 12.0;  // mm length of each tooth in Y direction
gap_between_teeth = 1.5; // mm gap between teeth

// Create the main spine block (back bar)
// Spine extends from Z=thickness to Z=length_spine, centered on X axis
spine_block = linear_extrude(
    length = length_spine + tooth_width * num_teeth, 
    width = width_spine, 
    height = thickness
);

// Create the teeth. 
// We start at spine_block[0] and extrude backwards (-Y) by (tooth_length - gap_between_teeth).
// The base of each tooth is on the spine surface.
teeth_list = [];
for (i = 1; i <= num_teeth; i++) {
    // Calculate position for this tooth in Y direction
    y_pos = width_spine + (i * gap_between_teeth); 
    // Tooth extends from spine surface backwards by the remaining length of the tooth
    tooth_length_back = tooth_length - gap_between_teeth;
    
    teeth_list.append(rotate_extrude(
        angle = 180, // Rotate around Z axis to hang it down
        radius = width_spine / 2.0 + (tooth_width / 2.0), 
        length = tooth_length_back, 
        height = thickness,
        direction = [-1, 0, 0] // Direction of hanging
    ));
}

// Combine spine and teeth into a single solid
comb = union(spine_block, teeth_list);

// Optional: Add a small fillet at the junction between spine and first tooth for better printability
fillet_radius = 0.5; 
spine_tooth_joint = hull(
    combine([
        spine_block[0], // Base of first tooth
        rotate_extrude(angle=180, radius=width_spine/2 + tooth_width/2, length=tooth_length_back-1, height=thickness, direction=[-1,0,0]), 
        rotate_extrude(angle=180, radius=width_spine/2 - fillet_radius, length=tooth_length_back+fillet_radius*2, height=thickness, direction=[-1,0,0])
    ])
);

// Final solid with rounded corners at the spine-tooth junction to prevent stress concentrations
final_comb = hull(
    combine([
        spine_block[0], 
        rotate_extrude(angle=180, radius=width_spine/2 + tooth_width/2, length=tooth_length_back-1, height=thickness, direction=[-1,0,0]), 
        rotate_extrude(angle=180, radius=width_spine/2 - fillet_radius, length=tooth_length_back+fillet_radius*2, height=thickness, direction=[-1,0,0])
    ])
);

// Print orientation: lying flat on XY plane (Z is thickness)
final_comb = rotate_extrude(
    angle = 90, 
    radius = width_spine / 2.0 + tooth_width / 2.0, 
    length = length_spine + num_teeth * gap_between_teeth, 
    height = thickness, 
    direction = [1, 0, 0] // Rotate so Z axis is along the print direction
);

// Set number of fillets for smooth curved surfaces (64)
fn = 64; 

// Print settings
print_settings(
    orientation = "horizontal",
    layer_height = 0.15,
    infill_density = 20,
    infill_pattern = "solid",
    infill_angle = 45,
    infill_speed = 30,
    infill_wall_thickness = 0.1,
    infill_fill_factor = 0.8,
    infill_min_width = 0.2,
    infill_max_width = 0.6,
    infill_max_height = 0.5,
    infill_min_depth = 0.3,
    infill_max_depth = 1.0,
    infill_min_wall_thickness = 0.1,
    infill_max_wall_thickness = 0.4,
    infill_wall_angle = 90,
    infill_wall_width = 0.2,
    infill_wall_height = 0.5,
    infill_wall_depth = 0.3,
    infill_wall_min_depth = 0.1,
    infill_wall_max_depth = 1.0,
    infill_wall_min_wall_thickness = 0.1,
    infill_wall_max_wall_thickness = 0.4,
    infill_wall_angle = 90,
    infill_wall_width = 0.2,
    infill_wall_height = 0.5,
    infill_wall_depth = 0.3,
    infill_wall_min_depth = 0.1,
    infill_wall_max_depth = 1.0,
    infill_wall_min_wall_thickness = 0.1,
    infill_wall_max_wall_thickness = 0.4,
    infill_wall_angle = 90,
    infill_wall_width = 0.2,
    infill_wall_height = 0.5,
    infill_wall_depth = 0.3,
    infill_wall_min_depth = 0.1,
    inf