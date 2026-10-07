// --- Dimensions and Parameters (measured in mm) ---

// Part 1: Box
box_outer_x = 70;
box_outer_y = 50;
box_height_z = 30;
wall_thickness_box = 2; // Wall thickness for sides, top rim
floor_thickness_box = 2; // Floor is solid (part of wall)

// Part 2: Lid Plate and Lip
lid_plate_x = 70;
lid_plate_y = 50;
lip_wall_thickness = 1.5;
lip_height_z = 4;
lip_outer_x = 65.6; // Inner dimension to slide into box (box is 70, wall is 2 -> inner width 66? No, user specified outer size of lip)
// Let's re-read carefully: "outer size is 65.6 x 45.6 mm". 
// Box internal dimensions: X = 70 - 2*2 = 66; Y = 50 - 2*2 = 46.
// User wants clearance of 0.2mm on each side for the lip to slide in? Or does "outer size" refer to the outer boundary of the lip itself relative to its own center, and it fits into the box opening with clearance?
// If Box Inner is 66x46. Lip Outer is 65.6x45.6. 
// Gap X = (66 - 65.6) / 2 = 0.2mm. Correct.
// Gap Y = (46 - 45.6) / 2 = 0.2mm. Correct.

lid_plate_thickness_z = 2; // Thickness of the plate lying on bed

// Positioning
gap_between_parts_x = 10;
box_center_y_offset = box_outer_y / 2; // Center Y for both parts (symmetric)
lip_inner_radius_factor = lip_outer_x / 45.6 * 37.8? No, just use linear dimensions directly as they are rectangular slots/holes usually not circular in this context unless specified "round". 
// Wait, the prompt says: "so it slides into the box opening with 0.2 mm clearance on each side."
// This implies a rectangular fit for X and Y based on the outer size of the lip (65.6x45.6) fitting inside the box inner void (66x46).

// --- Variables for Geometry Construction ---

// Box Inner Dimensions
box_inner_x = box_outer_x - 2 * wall_thickness_box; // 70 - 4 = 66
box_inner_y = box_outer_y - 2 * wall_thickness_box; // 50 - 4 = 46

// Lip Positioning relative to its own center (which is centered on the plate)
lip_center_x_offset_from_plate_edge = lip_outer_x / 2; 
lip_center_y_offset_from_plate_edge = box_inner_y / 2 + 1.5? No, let's calculate absolute positions later in code using variables for clarity.

// --- Part Construction Functions (Inline or Block level) ---

// We will build the parts as separate bodies and union them at the end with translation.
// Orientation: Both rest on XY plane (Z=0), building up +Z.
// Box is centered at origin? No, user says "Place the lid on the +X side of the box". 
// So we place the BOX first at center (or slightly offset to make room for gap?), then LID next to it.
// Let's put the BOX centered at X=0, Y=box_center_y_offset.
// Then the LID will be placed such that its left edge is 10mm from the right edge of the box? 
// Or center-to-center distance = BoxWidth + Gap? Usually "side by side with a gap" implies touching faces separated by gap.
// Let's assume: Right face of Box at X=35 (half width). Left face of Lid starts at 35+10 = 45.

module build_box() {
    // Construct the box from bottom up to avoid Z-fighting issues with simple difference, 
    // though union is safer for complex shapes. Let's use a single block approach or careful unions.
    
    // Floor (solid)
    translate([0, 0, -floor_thickness_box]) cube([box_outer_x, box_outer_y, floor_thickness_box]);

    // Walls and Top Rim
    // We can construct the walls as extrusions from the bottom up to height Z=30.
    
    // Back Wall (Y = max)
    translate([0, box_outer_y/2 + wall_thickness_box/2, 0]) 
        linear_extrude(height = floor_thickness_box * 1.5) polygon([[box_inner_x, -wall_thickness_box], [box_inner_x+floor_thickness_box*3, -wall_thickness_box]]);
    
    // Actually simpler: Build the box as a hollow shell using difference or just solid blocks if walls are uniform? 
    // Walls are not uniform (top rim is 2mm thick too). Let's build it as a single block with holes cut out.
    // Base Block
    translate([0, 0, -floor_thickness_box]) cube([box_outer_x, box_outer_y, floor_thickness_box]);

    // Cut the interior void to create walls and open top? 
    // If we cut a hole of size (70-2*wall) x (50-2*wall), that creates 4 vertical walls.
    // But wait, if I just subtract a box from another box at Z=30 height...
    
    // Let's try the "build up" method to ensure no z-fighting and clean topology for FDM support removal logic later (though not requested).
    
    // 1. Floor slab
    translate([box_outer_x/2, box_inner_y/2 - wall_thickness_box + floor_thickness_box? No]) 
        cube([box_outer_x, box_outer_y, floor_thickness_box]);

    // Let's simplify: The user wants a specific geometry.
    // Outer 70x50x30. Walls 2mm. Floor 2mm (which is part of the wall thickness). Top open.
    
    // Method A: Union of blocks
    // Bottom plate
    translate([box_outer_x/2, box_inner_y/2 - floor_thickness_box + wall_thickness_box? No]) 
        cube([box_outer_x, box_outer_y, 30]); 
    
    // Cut out the inside to make walls. The cutout goes from Z=wall_thickness (floor) up to Z=30.
    // Inner dimensions: X = 70 - 4 = 66. Y = 50 - 4 = 46.
    
    translate([box_outer_x/2, box_inner_y/2 + wall_thickness_box? No]) 
        difference() {
            cube([box_outer_x, box_outer_y, floor_thickness_box]); // Floor
            
            // Walls and Top Rim construction via extrusion from bottom up to Z=30 is tricky with simple cubes.
            // Let's do: Full block minus inner void (which creates walls) MINUS top lid? No, open top means we don't cut the whole way through at the very end or just leave it as a shell.
            
            // Correct approach for "Open Top Box":
            // 1. Create solid base + side walls up to Z=30.
            // 2. Do not create a lid block (open top).
        }

    // Let's rebuild the box logic cleanly:
    
    // Base plate at Z=-floor_thickness_box? No, let's set origin of part at bottom-left-front corner or center-bottom-center. 
    // User says "rests on XY plane". So lowest point is Z=0.
    
    translate([box_outer_x/2, box_inner_y/2 + wall_thickness_box - floor_thickness_box]) {
        cube([box_outer_x, box_outer_y, 30]); 
        
        difference() {
            // Cut the inner void to create walls and open top? 
            // If I cut a hole from Z=wall up to Z=30, it leaves an open top.
            translate([box_inner_x/2 + wall_thickness_box - floor_thickness_box, box_inner_y/2 + wall_thickness_box]) {
                cube([box_outer_x-4*wall_thickness_box? No], [box_inner_x, box_inner_y, 30-wall_thickness_box]); 
            }
        }
    }

    // Let's restart the Box construction logic to be absolutely sure.
    
    module make_open_top_box() {
        translate([box_outer_x/2, box_outer_y/2 - floor_thickness_box + wall_thickness_box]) {
            cube([box_outer_x, box_outer_y, 30]); 
            
            // Cut out the inside volume from Z=wall up to Z=30. 
            // The cutout starts at height = wall_thickness (since we want walls of that thickness).
            // Wait, if floor is 2mm thick and side walls are 2mm thick...
            // Total height needed for sides: 30 - 2(floor) + 2(rim)? No. 
            // The box has a bottom plate (floor) and vertical walls rising from it to