// Dimensions
knob_diameter = 30;
knob_height = 15;
bore_diameter = 6.2;
bore_depth = 12;
bore_flat_distance = 4.7;
groove_diameter = 2;
groove_count = 18;
pointer_width = 1.5;
pointer_depth = 1;

// Main cylinder
knob = cylinderh([knob_diameter / 2, knob_height]);

// D-shaped blind bore
bore = cylinderh([bore_diameter / 2, bore_depth]);
bore_cutout = cylinderh([bore_diameter / 2 - bore_flat_distance / 2, bore_depth + 0.01]);
bore = differencebore(bore, bore_cutout);

// Grip grooves
grooves = unionfor(i = [0:groove_count - 1]) (
    rotate_extrudeconvex($fn = 64) (
        translatez(knob_height / 2) (
            rotatez(i * 360 / groove_count) (
                cylinderh([groove_diameter / 2, 0.01])
            )
        )
    )
);

// Pointer groove
pointer = cylinderh([pointer_width / 2, pointer_depth]);
pointer = rotate_extrudeconvex($fn = 64) (
    translatez(knob_height / 2 - pointer_depth / 2) (
        cylinderh([pointer_width / 2, 0.01])
    )
);

// Final model
model = unionbore(knob, bore, grooves, pointer);
model = differencebore(model, bore_cutout);

// Render the model
render(model);