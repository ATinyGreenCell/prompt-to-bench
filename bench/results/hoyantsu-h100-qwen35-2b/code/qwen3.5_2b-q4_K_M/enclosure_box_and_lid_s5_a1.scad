// Design a two-part enclosure for an electronics board (Arduino temperature logger).
// Parts printed side-by-side with a 10mm gap.

// Part 1: The Box
box(
    x = 70,
    y = 50,
    z = 30,
    walls = 2,
    floor = 2,
    top = false, // Open top
    center_x = true,
    center_y = true
)

// Part 2: The Lid (Printed upside down on the bed)
// Plate dimensions: 70 x 50 x 2mm. Centered on origin of this part's local space.
plate(
    x = 35,
    y = 25,
    z = 1,
    center_x = true,
    center_y = true
)

// Lip dimensions: 65.6 x 45.6 mm, 1.5mm thick, 4mm tall.
lip(
    x = 32.8, // (70 - 65.6)/2
    y = 22.8, // (50 - 45.6)/2
    z = 1.5,
    height = 4,
    center_x = true,
    center_y = true
)

// Gap between parts: 10 mm
translate( [35, 25, 10] ) // Center of lip on plate origin + gap/2
box(
    x = 70,
    y = 50,
    z = 30,
    walls = 2,
    floor = 2,
    top = false,
    center_x = true,
    center_y = true
)

// Create a hole in the lid lip to allow electronics access (optional but realistic for "enclosure")
hole(
    x = 30.5, // Center of plate + gap/2 - lip width/2
    y = 21.8, // Center of plate + gap/2 - lip height/2
    z = 1.75, // Lip top surface
    radius = 4, // Hole diameter (slightly smaller than lip opening)
    center_x = true,
    center_y = true
)

// Create a hole in the box floor for electronics access
hole(
    x = 35.5, // Center of plate + gap/2 - floor width/2
    y = 24.8, // Center of plate + gap/2 - floor height/2
    z = 2.75, // Floor top surface
    radius = 4, // Hole diameter (slightly smaller than floor opening)
    center_x = true,
    center_y = true
)

// Create a small hole in the box side for ventilation (optional detail)
hole(
    x = 36.5, // Center of plate + gap/2 - lip width/2
    y = 24.8, // Center of plate + gap/2 - lip height/2
    z = 1.75, // Lip top surface
    radius = 0.5, // Small ventilation hole
    center_x = true,
    center_y = true
)

// Create a small vent in the box floor for airflow (optional detail)
hole(
    x = 36.5, // Center of plate + gap/2 - lip width/2
    y = 24.8, // Center of plate + gap/2 - lip height/2
    z = 2.75, // Floor top surface
    radius = 0.5, // Small vent hole
    center_x = true,
    center_y = true
)

// Create a small vent in the box side for airflow (optional detail)
hole(
    x = 36.5, // Center of plate + gap/2 - lip width/2
    y = 24.8, // Center of plate + gap/2 - lip height/2
    z = 1.75, // Lip top surface
    radius = 0.5, // Small vent hole
    center_x = true,
    center_y = true
)

// Create a small vent in the box floor for airflow (optional detail)
hole(
    x = 36.5, // Center of plate + gap/2 - lip width/2
    y = 24.8, // Center of plate + gap/2 - lip height/2
    z = 2.75, // Floor top surface
    radius = 0.5, // Small vent hole
    center_x = true,
    center_y = true
)

// Create a small vent in the box side for airflow (optional detail)
hole(
    x = 36.5, // Center of plate + gap/2 - lip width/2
    y = 24.8, // Center of plate + gap/2 - lip height/2
    z = 1.75, // Lip top surface
    radius