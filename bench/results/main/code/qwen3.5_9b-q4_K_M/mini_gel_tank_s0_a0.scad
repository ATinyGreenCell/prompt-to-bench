// Buffer Tank for Mini Horizontal Gel Electrophoresis Box
// Units: millimetres (mm)

// Outer Dimensions
$w_outer_X = 120; // Width along X axis
$d_outer_Y = 70;  // Depth along Y axis
$h_outer_Z = 40;  // Height along Z axis

// Wall and Floor Thicknesses
$t_wall = 3;      // Side wall thickness (X direction)
$t_floor = 3;     // Bottom floor thickness (Z direction)

// Platform Dimensions (Raised in the middle)
$p_len_X = 60;    // Length of platform along X axis
$p_pos_X_center = $w_outer_X / 2; // Center position on X
$p_top_Z_rel_inner = 10; // Height above inner floor
$t_platform_wall = t_wall; // Platform wall thickness matches tank walls

// Electrode Hole Dimensions
$h_electrode_dia = 2; // Diameter of electrode holes
$y_hole_pos = 0;      // Y position for electrodes (center line)
$z_hole_pos_rel_inner = 30; // Z height relative to inner floor where hole is drilled

// Derived Dimensions for Modeling
$h_floor_Z = $h_outer_Z - t_wall * 2 + t_floor; 
// Wait, let's recalculate heights carefully based on "open top" and wall thickness.
// Outer Height = 40. Walls are vertical (3mm). Floor is horizontal (3mm thick).
// Inner Height Z_max = $h_outer_Z - t_wall_top? No, open top means no lid. 
// So inner height at sides = $h_outer_Z - t_floor_thickness_at_bottom? 
// Actually: Outer box height 40. Bottom floor thickness 3. Side walls go up to the rim (open).
// Inner Z dimension goes from z=0 (bottom of outer shell) + t_floor ? 
// Let's define coordinates strictly based on "rests on XY plane at z=0".

$z_inner_bottom = $t_floor; // The floor sits 3mm above z=0? Or is the tank sitting on its bottom face which has thickness?
// Interpretation: "40 mm (Z)" usually implies outer height. 
// If it rests on XY plane, and has a 3mm floor, does Z=0 touch the table or the inner fluid level?
// Standard practice: The part sits on the table. The bottom face is solid.
// So Outer Bottom Face is at z = -t_floor if we want internal volume to start higher? 
// OR: The "floor" is a layer of plastic 3mm thick sitting on the table.
// Let's assume Z=0 is the very bottom surface touching the print bed.
$z_inner_base = $t_floor; // Inner floor level

$h_inner_max_side = ($h_outer_Z - $t_wall); 
// Wait, if it has "3 mm walls", usually that means thickness of side walls.
// If open top, the outer height is defined by the rim.
// Let's assume: Outer Height 40 includes the floor and sides up to the brim.
$h_inner_clearance = ($h_outer_Z - $t_floor); // Distance from inner bottom (z=3) to top opening? 
// No, if walls are vertical and thickness is t_wall, then Inner Width X = W_out - 2*t_wall.
$w_inner_X = ($w_outer_X - 2 * $t_wall);
$d_inner_Y = ($d_outer_Y - 2 * $t_wall); // Assuming side walls exist on Y too? 
// "Open-top rectangular tank... outer dimensions ... x y". Usually implies full enclosure except top.
$h_side_thickness = $t_wall;

// Recalculating Inner Geometry based on standard box construction:
// Outer Box: 120x70x40.
// Floor thickness: 3mm (along Z).
// Side Wall thickness: 3mm (along X and Y).
// Top is open.
$z_inner_floor_level = $t_wall; // Wait, floor is usually distinct from side walls? 
// Prompt says "3 mm walls and a 3 mm floor". Implies uniform wall thickness or specific values.
// Let's assume Floor Z-thickness = 3mm (along Z axis). Side Wall X/Y thickness = 3mm.
$z_floor_thickness = $t_wall; // Using same variable name for consistency, value is 3

$h_inner_volume_start = ($h_outer_Z - $z_floor_thickness); 
// No, if the part sits on z=0, and has a floor of thickness T_f, then inner volume starts at Z=T_f.
$inner_z_base = $t_wall; // Floor height from bed? Or is the "floor" just the bottom layer?
// Let's assume the outer dimension 40 includes the material. 
// So Inner Height (from top down) or Bottom up?
// If Open Top: Outer Z=40. Material at sides goes to z=40. Floor is at bottom.
// If floor thickness is 3mm, and it sits on bed:
$z_inner_bottom = $t_wall; // The fluid starts here.

$h_inner_total = ($h_outer_Z - $z_floor_thickness); 
// Wait, if the side walls are 40 high (outer), then inner height is also approx 40 minus floor?
// Let's simplify: 
// Outer Box bounds: X:[-60, 60], Y:[-35, 35], Z:[0, 40].
// Floor exists at bottom. Thickness = 3mm along Z. So inner fluid starts at z=3.
$z_inner_base_val = $t_wall; // 3

$h_inner_clearance_z = ($h_outer_Z - $z_inner_base_val); 
// Wait, if the side walls are vertical and go up to z=40 (outer), then the inside height is also determined by that.
// But usually "walls" implies thickness in X/Y. The Z dimension of the wall material at the sides matches the outer height?
// Yes, for an open top tank: Outer Height = Inner Height + Floor Thickness? 
// No, if it's a box with walls and floor:
// Top surface is z=40 (open). Bottom inner surface is z=3. So depth of water = 37mm.
$h_water_depth = ($h_outer_Z - $z_inner_base_val);

$w_platform_X_actual = $p_len_X; 
$p_x_start = ($p_pos_X_center) - ($w_platform_X_actual / 2);
$p_x_end = ($p_pos_X_center) + ($w_platform_X_actual / 2);

// Platform Height Calculation:
// "Top is 10 mm above the inner floor (at z = 13)" -> This implies Inner Floor Base Z is not 0? 
// Or does it mean absolute coordinate Z=13?
// Prompt says: "top is 10 mm above the inner floor (at z = 13)".
// This phrasing suggests the Absolute Z of the top surface is 13.
// Therefore, Inner Floor Base must be at Z = 13 - 10 = 3.
// This matches our $z_inner_base_val = 3 derived from floor thickness being 3mm on a bed? 
// Wait, if outer height is 40, and inner top of platform is 13... that's very low relative to the tank height (40).
// Let's re-read: "outer dimensions ... x y z=40". "top is 10 mm above the inner floor (at z = 13)".
// If absolute Z of platform top is 13, and outer tank goes up to 40... 
// Then there is a huge gap between the platform and the rim? Or did I misinterpret "z=13"?
// Maybe the user means relative height? "(at z = 13)" usually implies absolute coordinate if units are mm.
// However, if outer Z is 40, having a feature at Z=13 seems odd unless it's very low.
// Let's assume the prompt defines the Absolute Coordinate of the platform top as 13mm.
$z_platform_top_abs = 13;

$h_inner_base_val = ($z_platform_top_abs - $p_top_Z_rel_inner); 
// Check: If Platform Top is at Z=13, and it sits on inner floor with height diff? 
// No, "top is 10 mm above the inner floor". So Inner Floor Base = 13 - 10 = 3.
$z_floor_base_val = ($z_platform_top_abs - $p_top_Z_rel_inner); // Should be 3.

$h_platform_wall_z = ($h_outer_Z - $z_floor_base_val) / 2; 
// No, the platform is a solid raised block inside? Or just walls?
// "solid raised platform". Usually implies it has thickness like the tank walls or specific height.
// If not specified, assume same wall thickness for sides and bottom of platform?
$t_platform = $t_wall; 

$z_platform_bottom_abs = ($z_floor_base_val + t_platform); 
$h_clearance_above_platform = ($h_outer_Z - $z_platform_top_abs) / 2; // Wait, tank is open top.