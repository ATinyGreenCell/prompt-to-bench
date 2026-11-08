// Sowing Template for 90 mm Petri Dish
// Dimensions in millimeters

// Define the main disc dimensions and thickness
disc_diameter = 85.0; // mm
disc_thickness = 2.0; // mm

// Grid parameters
grid_rows = 7;
grid_cols = 7;
hole_diameter = 3.0; // mm
center_spacing = 9.0; // mm (centre-to-centre)

// Notch dimensions on +Y side
notch_width = 10.0; // mm (X direction)
notch_depth = 4.0; // mm (Y direction, measured from rim)

// Create the main disc as a hollow cylinder
main_disc = cylinder(
    height = disc_thickness,
    radius = disc_diameter / 2.0,
    holes = {
        x = [disc_diameter/2 - hole_diameter/2], // Inner radius for holes
        y = [-hole_diameter/2]
    }
);

// Create the notched rim on the +Y side (Right side of the disc)
// The notch is cut into the outer surface.
notch_part = linear_extrude(
    height = disc_thickness, // Extrude along Z to match main_disc height
    width = notch_width,     // Width in X direction
    depth = notch_depth      // Depth in Y direction (measured from rim)
);

// Combine the parts into a single solid using union
final_part = union([main_disc, notch_part]);

// Center the part on the origin (0, 0, 0)
translate([0, 0, disc_thickness / 2]) final_part;

// Set number of fillets for smooth edges if desired, though not strictly required by prompt
fn = 64; // Default OpenSCAD setting for curved surfaces

print("Sowing template generated successfully.");