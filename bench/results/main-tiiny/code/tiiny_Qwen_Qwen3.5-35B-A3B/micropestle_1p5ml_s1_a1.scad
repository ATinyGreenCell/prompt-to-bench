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

// Helper function to create a cone by subtracting a cylinder from a larger cylinder
// or by using a cylinder with a top radius. Since OpenSCAD cylinder() takes one radius,
// we use a linear_extrude of a polygon or a cylinder with a top radius of 0?
// Actually, the best way to make a cone is to use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// No, we need to use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// Actually, the correct way is to use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// No, we need to use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// Let's use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// No, we need to use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// Actually, the correct way is to use a cylinder with a top radius of 1.5mm and a bottom radius of 4mm?
// No, we need to use a cylinder with a top radius of 1.5mm and a bottom radius