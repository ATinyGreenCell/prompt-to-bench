// Lab funnel design parameters
$fn = 64;

// Dimensions in millimeters
spout_od = 10.0;           // outer diameter of spout
spout_bore = 6.8;          // inner bore diameter (wall thickness 1.6 mm)
spout_length = 20.0;       // length of spout from z=0 to z=20
cone_start_z = 20.0;       // start of cone at z=20
cone_end_z = 50.0;        // end of cone at z=50
cone_start_od = 10.0;     // outer diameter at z=20
cone_end_od = 60.0;       // outer diameter at z=50
wall_thickness = 1.6;     // wall thickness throughout

// Create the spout (cylinder with inner hole)
spout = translate([0, 0, 0]) 
  difference() {
    // Outer spout cylinder
    cylinder(h=spout_length, r=spout_od/2, f=0.1);
    
    // Inner bore (hole) for liquid flow
    cylinder(h=spout_length, r=spout_bore/2, f=0.1);
  };

// Create the cone part (widens from z=20 to z=50)
// The cone has outer diameter from 10 mm at z=20 to 60 mm at z=50
// So it's 30 mm long, with radius increasing from 5.0 to 30.0 mm

// Build the cone as a linear taper using a difference between two cylinders:
// 1. A large cylinder from z=20 to z=50 with radius 30.0 at z=50
// 2. A small cylinder from z=20 to z=50 with radius 5.0 at z=20
// This creates a cone with inner radius 5.0 at z=20 and 30.0 at z=50

// First, create the full cone (outer surface)
cone_outer = translate([0, 0, cone_start_z]) 
  cylinder(h=cone_end_z - cone_start_z, r=cone_end_od/2, f=0.1);

// Create the inner core (small cylinder) with constant radius 5.0 at z=20
// This will be subtracted to form the cone wall
// The inner core is a cylinder from z=20 to z=50 with radius 5.0
inner_core = translate([0, 0, cone_start_z]) 
  cylinder(h=cone_end_z - cone_start_z, r=cone_start_od/2, f=0.1);

// The cone is the difference between the outer and inner cylinder
cone = difference() {
  cone_outer;
  inner_core;
};

// Final part is the spout plus the cone
// The spout is from z=0 to z=20, the cone from z=20 to z=50
// They are joined at z=20

// Combine spout and cone
funnel = union() {
  spout;
  cone;
};

// Final output
module lab_funnel() {
  funnel;
}

lab_funnel();