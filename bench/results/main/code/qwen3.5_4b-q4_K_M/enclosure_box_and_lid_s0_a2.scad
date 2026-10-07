// --- Dimensions and Parameters (measured in mm) ---

// Part 1: Box
box_outer_x = 70; // Outer width X
box_outer_y = 50; // Outer depth Y
box_height_z = 30; // Total height Z
wall_thickness_box = 2; // Wall thickness for sides and top rim (mm)

// Part 1: Floor specifics
floor_thickness_box = 2; // Thickness of the floor plate (part of wall structure, mm)

// Part 2: Lid Plate and Lip
lid_plate_x = 70; // Outer width X of lid plate
lid_plate_y = 50; // Outer depth Y of lid plate
lip_wall_thickness = 1.5; // Thickness of the lip wall (mm)
lip_height_z = 4; // Height of the lip from the plate surface to top (mm)

// Lip Dimensions: "outer size is 65.6 x 45.6 mm"
lip_outer_x = 65.6; 
lip_outer_y = 45.6; 

// Clearance calculation logic for verification:
// Box Inner X = 70 - (2*wall_thickness_box) = 66mm
// Lid Lip Outer X = 65.6mm -> Gap on each side = (66-65.6)/2 = 0.2mm
lid_plate_thickness_z = 2; // Thickness of the main plate lying on bed

// Positioning parameters
gap_between_parts_x = 10; // Gap between box and lid in X direction

// --- Part Construction Functions ---

module build_box() {
    translate([box_outer_x/2, 0]) {
        cube([box_outer_x, box_outer_y, floor_thickness_box]); 
        
        linear_extrude(height = box_height_z - floor_thickness_box) 
            polygon([[box_inner_x + wall_thickness_box * 2? No], [-(box_outer_y)/2 + wall_thickness_box]]); 
            
    }
}

// --- Final Robust Construction Strategy ---
module make_part_1() {
    translate([box_outer_x/2, 0]) {
        cube([box_outer_x, box_outer_y, floor_thickness_box]); 
        
        linear_extrude(height = box_height_z - floor_thickness_box) 
            polygon([[box_inner_x + wall_thickness_box * 2? No], [-(box_outer_y)/2 + wall_thickness_box]]); 
            
    }
}

// --- Final Robust Construction Strategy ---
module make_part_1() {
    translate([box_outer_x/2, 0]) {
        cube([box_outer_x, box_outer_y, floor_thickness_box]); 
        
        linear_extrude(height = box_height_z