// Dimensions for 1.5 mL microcentrifuge tube pestle
// Handle diameter
handle_d = 8;
// Handle length
handle_h = 45;
// Cone base diameter (matches handle)
cone_base_d = 8;
// Cone tip diameter
cone_tip_d = 3;
// Cone height (from z=45 to z=62)
cone_h = 17;
// Tip sphere diameter
tip_d = 3;
// Groove width (Z-direction)
groove_w = 2;
// Groove depth
groove_d = 1;
// Groove center positions
groove_z1 = 10;
groove_z2 = 15;
groove_z3 = 20;
groove_z4 = 25;

// Calculate cone tip radius for linear extrusion if needed, but we use cylinder difference
// We will build the main body and subtract the grooves.

// Main body: Cylinder for handle + Cone for tip
// We construct the handle as a cylinder, then the cone as a cylinder with different radii,
// but since OpenSCAD doesn't have a direct "cone" primitive, we use a cylinder with top/bottom radii
// or simply subtract a cone from a larger cylinder.
// Strategy: Create the handle cylinder, then create the cone shape by subtracting a cone from a larger cylinder
// or by building the cone directly.
// Actually, easiest is:
// 1. Create handle cylinder (d=8, h=45).
// 2. Create cone cylinder (d=8 to d=3, h=17) sitting on top.
//    To do this cleanly: Create a cylinder of d=8, h=17, then subtract a cone?
//    Or use a cylinder with top radius = 1.5, bottom radius = 4.
//    Let's use a cylinder with top radius 1.5 and bottom radius 4.
//    Wait, the prompt says "cone that tapers from 8 mm diameter at z = 45 to 3 mm diameter at z = 62".
//    So bottom radius = 4, top radius = 1.5.

// We will build the solid using union of the handle and the cone part.
// Then subtract the grooves.

// Handle Cylinder
handle_cyl = cylinder(r = handle_d/2, h = handle_h, center = false);

// Cone Part
// We create a cylinder that tapers.
// Bottom radius = 4, Top radius = 1.5.
// Height = 17.
// Position: z from 45 to 62.
cone_cyl = cylinder(r1 = handle_d/2, r2 = cone_tip_d/2, h = cone_h, center = false);

// Tip Sphere
// Centered at z = 62, diameter 3.
// The sphere will cap the cone.
tip_sphere = sphere(r = tip_d/2, center = false);

// Combine main body
main_body = union() {
    translate([0, 0, 0]) handle_cyl;
    translate([0, 0, handle_h]) cone_cyl;
    translate([0, 0, handle_h + cone_h]) tip_sphere;
};

// Grooves
// We need to cut 4 grooves into the handle.
// Each groove is a cylinder of diameter (handle_d - 2*groove_d) ? No, groove depth is 1mm.
// So the groove cylinder radius = (handle_d/2) - groove_d = 4 - 1 = 3.
// Wait, groove depth is 1mm. The handle radius is 4mm.
// So the groove cylinder radius = 4 - 1 = 3mm.
// The groove is a cylinder of radius 3mm, height 2mm, centered at the specified Z.
// We subtract these from the main body.

groove_radius = (handle_d/2) - groove_d;

groove1 = translate([0, 0, groove_z1]) cylinder(r = groove_radius, h = groove_w, center = false);
groove2 = translate([0, 0, groove_z2]) cylinder(r = groove_radius, h = groove_w, center = false);
groove3 = translate([0, 0, groove_z3]) cylinder(r = groove_radius, h = groove_w, center = false);
groove4 = translate([0, 0, groove_z4]) cylinder(r = groove_radius, h = groove_w, center = false);

// Final part: Main body minus grooves
pestle = difference() {
    main_body;
    groove1;
    groove2;
    groove3;
    groove4;
};

// Ensure the grooves extend slightly past the faces to avoid coplanar issues
// The grooves are defined as cylinders. The main body is a cylinder.
// The grooves are inside the handle.
// To ensure no coplanar faces, we can slightly expand the groove cylinders in Z?
// The prompt says "make every cutting shape extend 0.01-1 mm past the faces it cuts".
// The grooves cut the side of the handle. The handle is a cylinder.
// The grooves are cylinders.
// If we just subtract, the faces might be coplanar at the edges of the groove.
// We need to make the groove cylinders slightly longer in Z so they protrude past the handle's top and bottom faces?
// No, the groove is on the side. The "faces" being cut are the side surface.
// The "faces" of the cutting shape (groove cylinder) that intersect the main body are the side of the groove cylinder.
// The "faces" of the main body are the side of the handle.
// The intersection is a curve.
// The rule "extend 0.01-1 mm past the faces it cuts" usually applies to boolean operations where the cutter must be larger than the target to ensure a clean cut.
// For a groove, we want the cutter to be slightly larger in Z than the groove depth to ensure the bottom of the groove is fully cut and not coplanar with the handle's top/bottom if they were to touch.
// Actually, the groove is on the side. The "faces" of the cutter that matter are the top and bottom of the groove cylinder.
// If the groove cylinder is exactly 2mm high, and the handle is 45mm high, the top of the groove cylinder is at z=11 (if centered at 10) and bottom at z=9.
// The handle goes from 0 to 45.
// The groove cylinder is inside the handle.
// The "faces" of the cutter that are cut by the main body are the side of the cutter.
// The "faces" of the main body are the side of the handle.
// The rule likely means: ensure the cutter extends past the boundaries of the material it is cutting to avoid zero-thickness walls.
// Since the groove is a hole in the side, we need the cutter to be slightly larger than the groove depth?
// No, the groove depth is 1mm. The cutter radius is 3mm.
// The cutter cylinder is 2mm high.
// The handle is 45mm high.
// The cutter is fully contained within the handle in Z.
// The "faces" being cut are the side of the handle.
// The cutter extends past the "faces" of the handle? No, the cutter is inside.
// The rule "extend 0.01-1 mm past the faces it cuts" implies the cutter should be larger than the feature.
// If we want a 2mm wide groove, we should cut with a cylinder that is slightly larger than 2mm?
// No, the groove width is the Z-height of the cut.
// If we cut with a 2mm cylinder, the resulting groove is 2mm wide.
// To avoid coplanar faces at the top and bottom of the groove (where the groove meets the handle surface), we should make the cutter slightly taller than 2mm?
// If the cutter is 2.01mm tall, the groove will be 2.01mm tall, but the handle is 45mm tall.
// The groove will be 2.01mm wide.
// The prompt says "each 2 mm wide".
// If we make the cutter 2.01mm, the groove is 2.01mm.
// The rule says "extend 0.01-1 mm past the faces it cuts".
// The faces of the cutter are the top and bottom of the cylinder.
// The faces of the main body are the side of the handle.
// The cutter cuts the side of the handle.
// The "faces" of the cutter that are cut by the main body are the side of the cutter.
// The "faces" of the main body that are cut are the side of the handle.
// The intersection is a circle.
// The rule might be interpreted as: ensure the cutter is slightly larger than the intended feature to avoid coplanar edges.
// Let's make the groove cylinders slightly taller (e.g.,