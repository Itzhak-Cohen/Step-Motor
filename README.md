# Step-Motor Control System in Verilog
This project demonstrates a fully functional Step-Motor control system designed in Verilog using the Quartus environment. The system includes multiple features to control the motor's behavior such as an on-switch, directional control, step-size selection (full/half), speed control, and a quarter-circle movement mode. Detailed simulations for each feature are provided in the accompanying lab report.

Features
The following features are implemented in the design:

1. On-Switch
The motor is turned on or off using an external on-switch.
When the motor is off, it remembers its last operational state, ensuring that other features like step size and direction remain consistent when the motor is turned on again.
2. Direction Control
Allows the user to change the rotational direction of the step motor between clockwise (CW) and counterclockwise (CCW).
The direction can be toggled at any time, even during operation.
3. Step-Size Selection (Full/Half)
Two operational step sizes are supported - both with the same speed:
Full Step: The motor moves in full steps.
Half Step: The motor moves in half steps for finer control and smoother motion.
The step-size can be selected dynamically using a control switch.
4. Speed Selection
A speed control feature allows the user to choose between different motor speeds, ranging from 10 to 60 rotations per minute. The design supports multiple speed modes, providing versatility in movement precision and performance. The selected speed is displayed on a pair of 7-segment LEDs on the FPGA.
6. Quarter-Circle Button
This special mode allows the motor to perform a 90-degree (quarter-circle) rotation.
The quarter-circle button can only be used when the motor is off, but it will respect the previously set direction, speed, and step size when activated.
7. Lab Simulations
For each feature, there are relevant simulations to verify correct functionality.
The lab report contains detailed waveforms and results for the following:
Motor starting and stopping using the on-switch.
Changing the motor direction.
Switching between full-step and half-step modes.
Speed control verification.
Quarter-circle operation in both CW and CCW directions.
