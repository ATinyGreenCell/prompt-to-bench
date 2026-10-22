// negative: a module that is defined but never instantiated builds nothing
// expect-reject-line: end
module plate() { cube([20, 30, 5]); }
