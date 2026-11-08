// Dimensions in millimeters
COLLAR_DIAMETER = 13.0; // mm
COLLAR_THICKNESS = 1.5; // mm
SLEEVE_OUTER_DIA = 10.8; // mm
BORE_DIAMETER = 6.2;     // mm
SLEEVE_HEIGHT = 21.5;    // mm

// Create the adapter sleeve part
adapter_sleeve = union(
    // The collar: sits on the bed (z=0), extends up to z=SLEEVE_HEIGHT, then is cut away by the bore
    cube(
        size=[COLLAR_DIAMETER, COLLAR_THICKNESS, SLEEVE_HEIGHT],
        origin=[0, 0, 0]
    ),
    
    // The bore: a hole running through the full height of the collar and sleeve body (z=0 to z=SLEEVE_HEIGHT)
    cylinder(
        size=[BORE_DIAMETER, SLEEVE_HEIGHT],
        origin=[COLLAR_DIAMETER / 2, COLLAR_THICKNESS / 2, 0] // Centered on the collar's center axis
    ),
    
    // The sleeve body: a hollow cylinder from z=1.5 to z=SLEEVE_HEIGHT with outer diameter SLEEVE_OUTER_DIA
    cylinder(
        size=[SLEEVE_OUTER_DIA, SLEEVE_HEIGHT],
        origin=[COLLAR_DIAMETER / 2, COLLAR_THICKNESS / 2, 0] // Starts at the collar's center axis
    )
);

// Print orientation: upside down (collar on bed)
adapter_sleeve = rotate_extrude(PI * 90, adapter_sleeve);