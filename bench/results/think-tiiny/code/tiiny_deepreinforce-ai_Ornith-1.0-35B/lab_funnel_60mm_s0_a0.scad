// Lab funnel dimensions
spout_od = 10;              // Spout outer diameter (mm)
wall_thickness = 1.6;       // Wall thickness (mm)
spout_bore = spout_od - 2 * wall_thickness; // Spout bore diameter (mm)
cone_bottom_od = 10;        // Cone bottom outer diameter (mm)
cone_top_od = 60;           // Cone top outer diameter (mm)
cone_bottom_bore = cone_bottom_od - 2 * wall_thickness; // Cone bottom bore diameter (mm)
cone_top_bore = cone_top_od - 2 * wall_thickness;       // Cone top bore diameter (mm)
spout_height = 20;          // Spout height (mm)
funnel_total_height = 50;   // Total funnel height (mm)
cone_height = funnel_total_height - spout_height; // Cone height (mm)

// Outer shapes
spout = cylinder(r=spout_od/2, h=spout_height, $fn=64);
cone = cylinder(r1=cone_bottom_od/2, r2=cone_top_od/2, h=cone_height, $fn=64);

// Inner bore (truncated cone to maintain constant wall thickness)
bore = cylinder(r1=spout_bore/2, r2=cone_top_bore/2, h=funnel_total_height + 0.1, $fn=64);

// Combine outer shapes and subtract bore
funnel = union(spout, cone);
result = difference(funnel, bore);