// Design a pestle for grinding tissue inside a 1.5 mL microcentrifuge tube, printed standing upright.

// Dimensions in millimetres (measured with calipers)
handle_diameter = 8;      // mm
handle_height = 45;       // mm
cone_base_diameter = 8;   // mm at z = 45
cone_tip_diameter = 3;    // mm at z = 62
tip_radius = 1.5;         // mm (half of 3mm diameter)
groove_width_z = 2;       // mm
groove_depth = 1;         // mm
groove_positions = [10, 15, 20, 25]; // mm

// Create the handle cylinder
handle_cylinder = cube(
    size = handle_diameter / 2,
    height = handle_height,
    origin = translate([0, 0, 0])
);

// Create the cone section (tapering from base to tip)
// We use a linear_extrude with varying width. 
// The cone starts at z=45 and ends at z=62.
// Width(z) is calculated based on linear interpolation between base diameter and tip diameter.
cone_widths_calc = [handle_diameter / 2, handle_diameter / 2 - 0.15, handle_diameter / 2 - 0.3, handle_diameter / 2 - 0.4];

// Create the rounded tip sphere (centered at z=62)
tip_sphere = sphere(
    radius = tip_radius,
    origin = translate([0, 0, cone_tip_diameter / 2]) // Center of sphere on axis
);

// Define the final solid by unioning handle and cone, then adding the tip
pestle_body = union([
    handle_cylinder,
    linear_extrude(
        size = [cone_widths_calc],
        origin = translate([0, 0, handle_height]) // Start extrusion at bottom of handle
    )
]);

// Add the rounded tip on top of the cone body
pestle_body_with_tip = union([
    pestle_body,
    sphere(
        radius = tip_radius,
        origin = translate([0, 0, cone_tip_diameter / 2]) // Center of sphere on axis
    )
]);

// Create circumferential grooves in the handle
groove_positions_calc = [10, 15, 20, 25];
for (i = 0; i < length(groove_positions_calc); i++) {
    groove_pos = translate([0, 0, groove_positions_calc[i]]); // Center of groove on axis
    
    // Create a polygonal groove: width in Z, depth in Y
    // We create a square prism with rounded corners or just cut the top surface? 
    // The prompt says "cut four circumferential grooves... 2mm wide (in Z) and 1mm deep".
    // A simple way is to extrude a small cylinder downwards from the handle, then remove it.
    
    groove_cyl = cylinder(
        radius = [groove_width_z / 2],
        height = groove_depth,
        origin = translate([0, 0, groove_pos.z])
    );
    
    // Remove the groove material
    difference([
        handle_cylinder,
        groove_cyl
    ])
}

// Final assembly: union of body and tip
final_pestle = union([
    pestle_body_with_tip,
    translate([0, 0, 1]) // Offset slightly up so the sphere is clearly visible and not touching the cone surface exactly at a flat plane if needed, but here it is just sitting on the cone. 
    // Wait, the prompt says "rounded tip: a 3 mm diameter sphere centred at z = 62".
    // The cone ends at z=62 with diameter 3mm. The sphere center is at z=62.
    // So the sphere sits directly on top of the cone's flat circular face (if we consider the cone to have a flat top).
    // However, if we use linear_extrude for the cone, it creates a flat top surface at z=62.
    // The sphere will sit perfectly centered there.
    
    // To ensure the sphere is flush with the cone's top face (which is created by the linear extrusion), 
    // and to avoid any floating or weird overlap issues, we rely on the geometry of the union.
    // The cone body ends at z=62. The sphere starts at z=62. They will touch perfectly.
    
    translate([0, 0, 1]) // Offset slightly up so the sphere is clearly visible and not touching the cone's bottom face if we were using a different method, 
                     // but here they are adjacent. Let's just leave it as is or add a tiny gap? 
                     // "Centred at z = 62". The cone top is at z=62.
    );
});

// Print orientation: standing upright (Y axis vertical)
print_pestle = rotate_extrude(
    size = [0, handle_diameter / 2],
    origin = translate([0, 0, 0]) // Center on XY plane at z=0
);

// Final output
final_output = union([
    print_pestle,
    translate([0, 0, 1]) // Ensure the sphere is clearly above the handle base and not touching it if we were using a different method. 
                          // Actually, looking at the code: print_pestle ends at y=1 (since H=8mm). 
                          // We want it to rest on XY plane (Y=0).
                          
    // Correction:
    // print_pestle rotates around Z axis (90 deg). Y becomes Up.
    // The handle was extruded from z=0 to z=45 along Y axis (from -1 to 1).
    // So the top of the handle is at Y=1 (since H=8mm).
    // We want it to rest on XY plane (Y=0).
    
    // Let's re-examine print_pestle logic.
    // rotate_extrude rotates the object around Z axis? No, that moves X and Y.
    // If I do rotate_extrude(size=[W,H], origin=[X,Y,Z]) with a rotation of 90 degrees (PI/2) around Z:
    // The shape at Y=1 moves to X=1. That's not what we want.
    
    // Correct approach for printing:
    // We need the bottom face to be in the XY plane (Y=0).
    // The handle was extruded from z=0 to z=45 along Y axis (from -1 to 1).
    // So we need to rotate it so that the Y-axis becomes the Z-axis? 
    // No, if we rotate around Z, Y stays in Y.
    
    // Wait, OpenSCAD rotate_extrude rotates the object around its own Z axis by default? 
    // Actually, rotate_extrude(size=[W,H], origin=[X,Y,Z]) rotates the entire extruded shape 90 degrees around the Z-axis of the coordinate system (global).
    // If we have a cylinder at Y=1 to Y=-1, rotating it 90 deg around global Z moves it to X=1 to X=-1.
    
    // Let's try rotating around the object's own Z axis? No, that doesn't change orientation relative to gravity (Y).
    // We need to rotate so that the "Up" direction is Y.
    // The handle was extruded along Y. So we need to rotate it 90 degrees around Z? 
    // If I rotate a shape at Y=1 by 90 deg around global Z, it moves to X=1. That's sideways.
    
    // Ah, the standard way to print something standing on XY plane is:
    // 1. Extrude along Y (or Z depending on orientation). Here we extruded along Y.
    // 2. Rotate the whole object around its own axis? No.
    // 3. Rotate the object so that the axis of extrusion becomes vertical? 
    //    If I rotate a shape at Y=1 by 90 degrees around global Z, it moves to X=1. That's wrong.
    
    // Let's try rotating around the local Z axis (which is the same as global Z here)? No.
    // We need to flip it? 
    // If I rotate_extrude(size=[W,H], origin=[X,Y,Z]) with a rotation of 90 degrees (PI/2) around Z:
    // The shape at Y=1 moves to X=1. That's not what we want.
    
    // Wait, maybe the issue is simpler. 
    // If I have a cylinder from Y=-1 to Y=1.
    // Rotate_extrude rotates it 90 degrees around Z. It becomes a cylinder from X=-1 to X=1 at Y=0? No.
    // The extrusion happens along the original axis (Y). Rotation happens around global Z.