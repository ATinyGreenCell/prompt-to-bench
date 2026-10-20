// Lab funnel dimensions
spout_od = 10
wall_thickness = 1.6
spout_bore = spout_od - 2 * wall_thickness
cone_bottom_od = 10
cone_top_od = 60
cone_bottom_bore = cone_bottom_od - 2 * wall_thickness
cone_top_bore = cone_top_od - 2 * wall_thickness
spout_height = 20
funnel_total_height = 50
cone_height = funnel_total_height - spout_height

// Outer shapes
spout = cylinder(r=spout_od/2, h=spout_height, $fn=64)
cone = cylinder(r1=cone_bottom_od/2, r2=cone_top_od/2, h=cone_height, $fn=64)

// Inner bore (truncated cone to maintain constant wall thickness)
bore = cylinder(r1=spout_bore/2, r2=cone_top_bore/2, h=funnel_total_height + 0.1, $fn=64)

// Combine outer shapes and subtract bore
difference(union(spout, cone), bore)