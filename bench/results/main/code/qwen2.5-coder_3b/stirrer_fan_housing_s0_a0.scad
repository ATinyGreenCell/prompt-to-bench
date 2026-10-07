// Define dimensions
$fn = 64; // Number of facets for curved surfaces

// Outer size of the housing
const outerX = 90;
const outerY = 90;

// Thicknesses
const topPlateThickness = 2;
const wallThickness = 2.5;

// Fan mounting holes
const fanHoleDiameter = 4.5;
const fanHolePatternSize = 71.5;
const fanHoleSpacing = sqrt(2) * fanHolePatternSize / 2; // Square root of 2 for diagonal spacing

// Power cable notch dimensions
const powerCableNotchWidth = 12;
const powerCableNotchDepth = 8;

// Create the housing
difference() {
  // Outer box
  cube([outerX, outerY, wallThickness * 4 + topPlateThickness], center=true);

  // Top plate
  translate([0, 0, topPlateThickness]) {
    cube([outerX, outerY, topPlateThickness], center=true);
  }

  // Fan mounting holes
  for (i = [0:3]) {
    const holePosition = fanHolePatternSize / 2 - fanHoleSpacing * i;
    translate([holePosition, holePosition, wallThickness + topPlateThickness]) {
      cylinder(r=fanHoleDiameter/2, h=wallThickness + topPlateThickness, center=true);
    }
  }

  // Power cable notch
  translate([outerX / 2 - powerCableNotchWidth / 2, outerY / 2 - powerCableNotchDepth / 2, wallThickness * 4]) {
    linear_extrude(height=powerCableNotchDepth) {
      square([powerCableNotchWidth, powerCableNotchDepth], center=true);
    }
  }

  // Cut out the notch in one of the walls
  translate([outerX / 2 - wallThickness / 2, outerY / 2 - wallThickness / 2, wallThickness * 4]) {
    linear_extrude(height=powerCableNotchDepth) {
      square([wallThickness, powerCableNotchDepth], center=true);
    }
  }

  // Cut out the notch in the opposite wall
  translate([outerX / 2 - wallThickness / 2, outerY / 2 - wallThickness / 2, wallThickness * 4 + topPlateThickness]) {
    linear_extrude(height=powerCableNotchDepth) {
      square([wallThickness, powerCableNotchDepth], center=true);
    }
  }
}