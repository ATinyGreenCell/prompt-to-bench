// Built by bench/smallmodels/features/compiler.py from a list of features.
$fn = 64;
union() {
    translate([-10, -10, 0]) linear_extrude(height = 8) polygon([[0, 0], [50, 0], [50, 4], [0, 4]]);
    translate([-10, 10, 0]) linear_extrude(height = 8) polygon([[0, 12], [60, 12], [60, 16], [0, 16]]);
  }