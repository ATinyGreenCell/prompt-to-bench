// Design a snap-on clip for lab tubing.
// Units: millimetres (mm).

// Define dimensions based on caliper measurements
const mm = 1; // Conversion factor if needed, though we use direct numbers in mm

// Ring 1: Rod ring
// Inner diameter: 12.7 mm -> Radius r_in = 6.35 mm
// Wall thickness: 3 mm -> Outer radius r_out = 9.35 mm
// Centred at origin (0,0)
// Opening cut out of -X side: x < 0 and -5 < y < 5

// Ring 2: Tubing ring
// Inner diameter: 6 mm -> Radius r_in = 3 mm
// Wall thickness: 2 mm -> Outer radius r_out = 5 mm
// Centred at (15, 0)
// Opening cut out of +X side: x > 15 and -2.25 < y < 2.25

// Solid bridge connecting the two rings
// Width in Y direction: 6 mm -> Radius r_bridge = 3 mm
// Centred at (8, 0) to connect Ring 1's right side to Ring 2's left side

fn = 64; // High number of slices for smooth curved surfaces and holes

// --- Build Part ---

// Create the solid body by extruding the profile in XY plane
// We will use a union of two rings (Ring1 + Ring2) plus the bridge.
// Note: The prompt asks to build the part as an extrusion of a 2D profile.
// However, simply extruding a ring creates a hollow tube. 
// To hold tubing "next to" it while snapping on, we usually need a solid block or a specific shape.
// Re-reading: "a 10 mm tall extrusion (Z) of a 2-D profile".
// This implies the part is a flat plate with thickness Z=10mm.
// To make this printable and functional as described (holding tubing), we need to ensure the geometry holds.
// A simple union of Ring1, Ring2, and Bridge creates a solid block if they touch perfectly at boundaries.

// Let's construct the profile components first.

// Component 1: Rod Ring
// Inner radius 6.35, Outer radius 9.35
// Hole in -X side (x < 0) from y=-5 to y=5
// We use polygon for the hole to ensure clean edges and correct dimensions.

// Component 2: Tubing Ring
// Inner radius 3, Outer radius 5
// Hole in +X side (x > 15) from y=-2.25 to y=2.25

// Component 3: Bridge
// Radius 3, Centred at x=8, y=0

// Helper function to create a ring with an offset hole using polygons
// This ensures the cut-out is precise and doesn't overlap faces exactly (using epsilon)
function make_ring(r_in, r_out, center_x, center_y, wall_thickness = 1.5) {
    // Calculate outer radius for polygon
    var poly_r = r_out + wall_thickness;
    
    // Create a large square to define the bounding box of the ring
    var big_square = square(2 * poly_r);
    
    // Define the hole shape (polygon)
    // Hole is centered at center_x, center_y with radius r_in
    var hole_radius = r_in;
    var hole_center_x = center_x;
    var hole_center_y = center_y;
    
    // Create a polygon for the hole. 
    // We need to ensure the cut-out extends slightly past faces (0.01-1mm) as per rule 5.
    // To do this with polygons, we create a large square that encompasses the ring + hole offset,
    // then subtract it from the big_square.
    
    var total_offset = wall_thickness * 2; // Total width of material around hole
    var hole_box_x = center_x - (hole_radius + total_offset);
    var hole_box_y = center_y - (hole_radius + total_offset);
    var hole_box_z = hole_radius + total_offset; // Height of the box
    
    // Create a polygon for the hole
    var hole_poly = polygon([
        [hole_center_x, hole_center_y], 
        [hole_center_x + hole_box_z, hole_center_y], 
        [hole_center_x + hole_box_z, hole_center_y - hole_radius], 
        [hole_center_x, hole_center_y - hole_radius]
    ]);

    // Create a large square that covers the entire ring area plus the offset for cutting
    var cut_square = square([
        [center_x - total_offset, center_y - total_offset], 
        [center_x + total_offset, center_y + total_offset],
        [-hole_box_z, hole_box_z] // Height of the box
    ]);

    return difference(cut_square, big_square);
}

// --- Assembly ---

// 1. Rod Ring (Ring 1)
var ring1 = make_ring(6.35, 9.35, 0, 0, wall_thickness=3);

// 2. Tubing Ring (Ring 2)
var ring2 = make_ring(3, 5, 15, 0, wall_thickness=2);

// 3. Solid Bridge
var bridge = cube(6, 0, 0); // Width Y=6, Height Z=0, Depth X=0 (flat plate)

// Combine all parts into a single solid using union
part = union(ring1, ring2, bridge);

// Extrude the part to form the clip
var clip_height = mm; 
clip = extrude(clip_height);

// Final output
render(part); // Renders the final solid shape