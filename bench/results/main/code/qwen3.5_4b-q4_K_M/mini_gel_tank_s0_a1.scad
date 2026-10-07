// Buffer tank for mini horizontal gel-electrophoresis box
$fn = 64; // Polygon resolution for smooth curves/holes and round holes

// --- Dimensions (measured with calipers) ---
outer_width_x = 120;   // X dimension in mm
inner_height_y = 70;   // Y dimension in mm
tank_depth_z = 40;     // Z depth of tank in mm

wall_thickness = 3;    // Thickness of walls/floor in mm
floor_thickness = wall_thickness; // Floor is part of the structure, same thickness as walls

// Platform dimensions (measured with calipers)
platform_length_x = 60;   // Length along X axis in mm
platform_z_offset_from_floor = 13; // Height of top surface above floor (z=13 relative to bottom face)

// Electrode hole specifications
hole_diameter = 2;        // Diameter in mm
electrode_height_z = 30; // Z position for the horizontal cut through side walls

// --- Geometry Calculations ---
tank_inner_width_y = inner_height_y - (wall_thickness * 2); // Inner width available inside tank

// Platform dimensions relative to outer box center
platform_outer_length_x = platform_length_x + wall_thickness * 2; // Full length including thickness if placed flush, but we place it centered on the floor area. 
                            // Actually, let's define the platform block directly in its local space and translate later for clarity.

// --- Modules ---

module build_tank_body() {
    // Create a hollow rectangular box (open top) with walls of 'wall_thickness'
    // We use difference to cut out the inner volume from an outer solid
    
    // Outer bounding box
    o_x = outer_width_x; 
    o_y = inner_height_y; 
    o_z = tank_depth_z + wall_thickness; // Height includes floor and top rim (though open)

    translate([0, -o_y/2, 0]) {
        difference() {
            cube([o_x, o_y, o_z], center=false);
            
            // Cut out the inner volume to create walls/floor
            i_x = outer_width_x - wall_thickness * 2; 
            i_y = tank_inner_width_y + (wall_thickness * 2) - 0.1; // Slightly larger than exact inner width for clean cut? No, just use calculated inner dims minus epsilon for difference logic if needed, but here we define the hole explicitly below or rely on simple subtraction.
            
            // Simpler approach: Define walls as extrusions from floor up to top rim height (tank_depth_z) + wall_thickness
            // Floor is at z=0. Walls go from z=wall_thickness to z=tank_depth_z+wall_thickness? 
            // Let's stick to the prompt: 3mm walls, 3mm floor.
            
            // Constructive Solid Geometry approach for box:
            // Start with a solid block of outer dimensions and height (tank_depth_z + wall_thickness)
            // Subtract an inner rectangular prism defined by inner width/depth and tank depth
            
            cube([o_x, o_y, o_z], center=false);
            
            // Inner void definition
            i_w = i_x; 
            i_h = tank_inner_width_y - 0.1; // Slightly smaller to ensure clean cut if walls are defined separately? No, let's just subtract the inner volume directly from outer.
            // Wait, standard box: Outer dims minus (2*thickness) gives Inner dims exactly.
            
            cube([i_x, i_h, tank_depth_z], center=false); 
        }
    }
}

module build_platform() {
    // Platform is solid raised block in the middle of the bottom chamber(s).
    // It spans full inner width (Y), length 60mm along X.
    // Top surface at z = tank_depth_z + wall_thickness - floor_thickness? 
    // Prompt says: "top is 10 mm above the inner floor". Inner floor is effectively the base of the chamber.
    // If we consider the bottom face of the whole assembly as Z=0 (floor), then inner floor is at Z=wall_thickness? Or Z=0 if it's a tray sitting on something else? 
    // "3 mm walls and a 3 mm floor". Usually implies the tank sits on its own base.
    // Let's assume the bottom face of the assembly is Z=0 (the outer corner). The inner floor surface for liquid would be at Z = wall_thickness + some clearance? Or just Z=wall_thickness if it's flush with walls inside? 
    // Prompt: "top is 10 mm above the inner floor".
    // Let's assume the "inner floor" of the chamber (where gel sits) is at a specific height. 
    // If we build the tank such that the bottom outer corner is Z=0, then the inside bottom surface is at Z = wall_thickness + 3mm? Or just Z=wall_thickness if walls are thick enough to hold liquid depth?
    // Let's assume standard: Floor thickness = Wall thickness. So inner floor plane is at Z = wall_thickness (if we ignore a tiny gap for seal) or slightly higher. 
    // However, the prompt says "top is 10 mm above the inner floor". 
    // If Inner Floor is at Z = tank_depth_z + wall_thickness - platform_height? No.
    
    // Let's define coordinates relative to the bottom face of the assembly (Z=0).
    // The chamber depth is tank_depth_z. So liquid fills from Z ~ 3mm up to Z ~ 40+3mm? 
    // Actually, let's simplify: The "inner floor" for the gel tray is a surface inside the box.
    // Let's place the inner bottom face at Z = wall_thickness + (some small gap) or just assume the walls are thick enough that liquid sits on top of them? No, usually there is a base plate. 
    // Given "3 mm floor", let's assume the solid block forms the floor and sides.
    // Inner surface height from bottom outer face = wall_thickness + (gap for seal?) or just wall_thickness if we consider the inner void starts at that level.
    // Let's assume the liquid sits on a plane 10mm below the platform top. 
    // If Platform Top is at Z_p, then Liquid Floor is at Z_p - 10.
    
    // Re-reading: "top is 10 mm above the inner floor (at z = 13)".
    // This implies the coordinate system has the inner floor at a specific Z relative to something? 
    // Or does it mean the absolute Z in our model should be such that Inner Floor is at some value and Platform Top is at 13?
    // "rests on the XY plane at z = 0". So bottom of tank is Z=0.
    // If floor thickness is 3mm, then inner surface starts at Z=3mm (assuming no extra base plate). 
    // Then Inner Floor level = 3mm + gap? Or just 3mm? Let's assume the "inner floor" refers to the bottom-most liquid contact point inside.
    // If Platform Top is at z=13, and it is 10mm above inner floor -> Inner Floor must be at Z = 13 - 10 = 3mm. 
    // This matches perfectly with a 3mm thick wall/floor starting from the bottom (Z=0).
    
    platform_z_absolute = 13; 
    
    translate([-(platform_length_x/2), -(tank_inner_width_y)/2, tank_depth_z + wall_thickness - floor_thickness]) { 
        // Wait, where is this placed? The prompt says "in the middle of the tank... spans full inner width".
        // It divides bottom into two chambers. So it sits on top of the liquid level (or slightly above).
        // If Inner Floor is at Z=3mm, and Platform Top is at Z=13mm. 
        // The platform must be supported by something? Or does it float in air inside the tank walls? 
        // "solid raised platform... divides bottom". It implies physical support from below or just a divider structure.
        // Since we are printing FDM, and no glue is mentioned for internal supports (unless printed), let's assume it sits on top of the liquid level which is supported by the chamber floor? No, that doesn't make sense physically unless there's a base plate under the gel tray. 
        // Maybe the "inner floor" IS the bottom of the tank walls, and the platform rests ON IT (so we need to print supports or assume it floats).
        // Given constraints: Build exactly what is described. If no support structure is mentioned for the platform itself other than being a solid block, I will model it as a floating divider at Z=13 relative to bottom of tank? 
        // Or perhaps the "inner floor" implies there IS a base plate inside? No, just walls and floor thickness given.
        
        // Let's assume the user wants a physical part where the platform is attached or supported by the side walls if possible, OR it's just a block at Z=13 relative to bottom of tank (Z=0). 
        // If I place it floating in air inside the box, it won't be printable without supports unless connected.
        // However, often these trays are placed on top of the buffer