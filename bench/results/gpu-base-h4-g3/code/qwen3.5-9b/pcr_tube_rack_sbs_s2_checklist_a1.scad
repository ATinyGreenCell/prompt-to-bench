// 96-well PCR tube rack - ANSI/SLAS footprint with chamfered orientation mark.
// Dimensions in mm.

// Block dimensions
L     = 127.76; // Length (X)
W     = 85.48;  // Width (Y)
H     = 20;     // Height (Z)

// Hole specifications
n_cols = 12; // Columns along X
n_rows = 8;  // Rows along Y
hole_d = 6.2;
pitch_x = 9.0;
pitch_y = 9.0;

// Grid origin (A1 center) relative to block corner
origin_x = 14.38;
origin_y = 11.24;

// Chamfer specifications
chamfer_leg = 5.0;
chamfer_angle = 45;

$fn = 128;

// Calculate grid start positions to center the grid on the block
// The grid spans from origin to (origin + (n-1)*pitch)
grid_span_x = (n_cols - 1) * pitch_x;
grid_span_y = (n_rows - 1) * pitch_y;

// Center the grid on the block
center_offset_x = (L - grid_span_x) / 2;
center_offset_y = (W - grid_span_y) / 2;

// Actual start positions for the first hole (A1)
start_x = origin_x + center_offset_x;
start_y = origin_y + center_offset_y;

module rack() {
    // Main block
    translate([0, 0, 0]) cube([L, W, H]);

    // Chamfer at A1 corner (bottom-left-front in local coords, but we print on XY)
    // The user wants a chamfer on the vertical edge at the A1 corner.
    // A1 is at (start_x, start_y, 0).
    // We cut a wedge from the block.
    // The cut plane passes through (start_x + chamfer_leg, start_y, 0) and (start_x, start_y + chamfer_leg, 0)
    // and goes up to (start_x, start_y, H - chamfer_leg) effectively removing the corner.
    // Actually, a standard chamfer on a vertical edge removes material from the top corner down to the edge.
    // Let's define the cut volume.
    // The removed shape is a wedge at the top corner.
    // Base on Z=H plane: Square from (start_x, start_y) to (start_x+L, start_y+L) cut by line (X-start_x) + (Y-start_y) = L.
    // Height of cut: from Z = H - L up to Z = H.
    
    // Let's build the cutter.
    // It's a prism with a triangular cross section extruded along Z.
    // The triangle vertices on the XY plane (relative to start_x, start_y):
    // (0, 0) is the corner.
    // (L, 0) and (0, L) are the points on the faces.
    // The hypotenuse is x + y = L.
    // We want to remove the region x > 0, y > 0, x + y < L? No, that's the corner.
    // We want to remove the corner of the block.
    // The block occupies x >= start_x, y >= start_y.
    // The chamfer removes the region: x > start_x, y > start_y, (x - start_x) + (y - start_y) < L.
    // This region is a triangle with vertices (start_x, start_y), (start_x+L, start_y), (start_x, start_y+L).
    // Wait, if the leg is 5mm, the cut goes 5mm along X and 5mm along Y.
    // So the vertices of the removed triangle are (start_x, start_y), (start_x+5, start_y), (start_x, start_y+5).
    // The hypotenuse connects (start_x+5, start_y) and (start_x, start_y+5).
    // The cut depth is 5mm from the top (Z=H).
    
    // Let's define the cutter polygon.
    // We extrude a polygon along Z.
    // The polygon is in the X-Y plane? No, let's use a simpler approach.
    // Create a shape that is the intersection of the block and the cut plane.
    // Actually, let's just define the volume to subtract.
    // The volume is bounded by:
    // X > start_x
    // Y > start_y
    // Z > H - chamfer_leg
    // (X - start_x) + (Y - start_y) < chamfer_leg
    
    // We can model this as a cylinder with a specific polygon profile extruded?
    // Or just a polyhedron.
    // Let's use a polygon extruded along Z.
    // The profile is in the X-Y plane? No, the cut is diagonal.
    // Let's rotate the coordinate system or just define the points.
    // Points of the cut volume (to be subtracted):
    // Bottom face (at Z = H - chamfer_leg): Triangle (start_x, start_y), (start_x+L, start_y), (start_x, start_y+L).
    // Top face (at Z = H): Same triangle.
    // Wait, the chamfer is on the vertical edge.
    // The edge is at X=start_x, Y=start_y.
    // The chamfer removes the corner.
    // The cut surface is a plane.
    // The plane passes through (start_x+L, start_y, H), (start_x, start_y+L, H) and (start_x+L, start_y, 0)? No.
    // A 45 degree chamfer implies the plane is at 45 degrees to the faces.
    // The plane equation is (X - start_x) + (Y - start_y) = L.
    // This plane cuts the corner.
    // The material to remove is where (X - start_x) + (Y - start_y) < L AND X > start_x AND Y > start_y AND Z > H - L.
    // Wait, if the plane is (X-start_x) + (Y-start_y) = L, then at Z=H, the cut is the line connecting (start_x+L, start_y) and (start_x, start_y+L).
    // At Z = H - L, the cut should be the point (start_x, start_y)?
    // No, a chamfer on a vertical edge removes a wedge.
    // The wedge has a triangular base on the top face (Z=H) and tapers to a line or point?
    // Usually, a chamfer on a vertical edge removes a prism with a triangular cross-section along the edge?
    // No, a chamfer on a vertical edge removes a wedge that goes all the way down?
    // The prompt says "off the vertical edge".
    // Let's assume it cuts the top corner of the block at that edge.
    // The cut removes the region: X > start_x, Y > start_y, Z > H - chamfer_leg, AND (X - start_x) + (Y - start_y) < chamfer_leg.
    // This is a wedge with a triangular base on the top face and a line edge at the bottom?
    // No, if the condition is Z > H - chamfer_leg, then the cut is a prism of height chamfer_leg.
    // The cross section is the triangle defined by X > start_x, Y > start_y, (X - start_x) + (Y - start_y) < chamfer_leg.
    // This triangle has vertices (start_x, start_y), (start_x+chamfer_leg, start_y), (start_x, start_y+chamfer_leg).
    // The hypotenuse connects (start_x+chamfer_leg, start_y) and (start_x, start_y+chamfer_leg).
    // This creates a 45 degree chamfer on the top corner of the vertical edge.
    
    // Let's create the cutter shape.
    // It is a prism with a triangular base extruded along Z.
    // The base is in the XY plane.
    // Vertices of the base triangle (relative to start_x, start_y):
    // (0, 0), (chamfer_leg, 0), (0, chamfer_leg).
    // We need to extrude this along Z from H - chamfer_leg to H.
    // But we need to subtract it from the block.
    // The block is at Z=0 to Z=H.
    // The cutter should be at Z = H - chamfer_leg to Z = H.
    // The cutter shape:
    // translate([start_x, start_y, H - chamfer_leg]) {
    //     linear_extrude(chamfer_leg) polygon([[0, 0], [chamfer_leg, 0