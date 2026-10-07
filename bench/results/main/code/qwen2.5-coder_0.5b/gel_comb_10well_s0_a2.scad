// Define variables for the dimensions of the comb
$Z = 1.5; // Thickness of the comb
$X = 70; // Length of the back bar (X)
$Y = 12; // Width of the back bar (Y)
$T = 10; // Number of teeth

// Define variables for the position and orientation of the comb
$pos = [0, 0, $Z]; // Position in the bed
$rot = [0, 0, 0]; // Rotation in the XY plane

// Define variables for the size of each tooth
$T ToothWidth = 5.0; // Width of each tooth (X)
$T ToothHeight = 12.0; // Height of each tooth (Y)

// Define variables for the position and orientation of each tooth
$toothPos = [0, $T ToothHeight / 2, $pos[2]]; // Position in the back bar

// Define variables for the size of each gap between neighbouring teeth
$GapWidth = 1.5; // Width of each gap (X)
$GapHeight = 1.5; // Height of each gap (Y)

// Define variables for the position and orientation of each gap
$gapPos = [0, $GapHeight / 2, $toothPos[2]]; // Position in the back bar

// Define variables for the size of each row of teeth
$rowWidth = $X; // Width of each row (X)
$rowHeight = $Y; // Height of each row (Y)

// Define variables for the position and orientation of each row
$rowPos = [0, 0, $pos[2]]; // Position in the back bar

// Define variables for the size of each slot
$slotWidth = $T ToothWidth / 2; // Width of each slot (X)
$slotHeight = $Y; // Height of each slot (Y)

// Define variables for the position and orientation of each slot
$slotPos = [0, $slotHeight / 2, $rowPos[2]]; // Position in the back bar

// Define variables for the size of each groove
$grooveWidth = $GapWidth; // Width of each groove (X)
$grooveHeight = $Y; // Height of each groove (Y)

// Define variables for the position and orientation of each groove
$groovePos = [0, $grooveHeight / 2, $slotPos[2]]; // Position in the back bar

// Define variables for the size of each hole
$holeWidth = $T ToothWidth; // Width of each hole (X)
$holeHeight = $Y; // Height of each hole (Y)

// Define variables for the position and orientation of each hole
$holePos = [0, $holeHeight / 2, $rowPos[2]]; // Position in the back bar

// Define variables for the size of each hole grid
$holeGridWidth = $T ToothWidth; // Width of each hole grid (X)
$holeGridHeight = $Y; // Height of each hole grid (Y)

// Define variables for the position and orientation of each hole grid
$holeGridPos = [0, $holeGridHeight / 2, $rowPos[2]]; // Position in the back bar

// Define variables for the size of each slot grid
$slotGridWidth = $T ToothWidth; // Width of each slot grid (X)
$slotGridHeight = $Y; // Height of each slot grid (Y)

// Define variables for the position and orientation of each slot grid
$slotGridPos = [0, $slotGridHeight / 2, $rowPos[2]]; // Position in the back bar

// Define variables for the size of each groove grid
$grooveGridWidth = $GapWidth; // Width of each groove grid (X)
$grooveGridHeight = $Y; // Height of each groove grid (Y)

// Define variables for the position and orientation of each groove grid
$grooveGridPos = [0, $grooveGridHeight / 2, $slotPos[2]]; // Position in the back bar

// Define variables for the size of each hole grid
$holeGridWidth = $T ToothWidth; // Width of each hole grid (X)
$holeGridHeight = $Y; // Height of each hole grid (Y)

// Define variables for the position and orientation of each hole grid
$holeGridPos = [0, $holeGridHeight / 2, $rowPos[2]]; // Position in the back bar

// Define variables for the size of each slot grid
$slotGridWidth = $T ToothWidth; // Width of each slot grid (X)
$slotGridHeight = $Y; // Height of each slot grid (Y)

// Define variables for the position and orientation of each slot grid
$slotGridPos = [0, $slotGridHeight / 2, $rowPos[2]]; // Position in the back bar

// Define variables for the size of each groove grid
$grooveGridWidth = $GapWidth; // Width of each groove grid (X)
$grooveGridHeight = $Y; // Height of each groove grid (Y)

// Define variables for the position and orientation of each groove grid
$grooveGridPos = [0, $grooveGridHeight / 2, $slotPos[2]]; // Position in the back bar

// Define variables for the size of each hole grid
$holeGridWidth = $T ToothWidth; // Width of each hole grid (X)
$holeGridHeight = $Y; // Height of