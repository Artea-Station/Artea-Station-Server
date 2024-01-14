//Helpers
///Moves the icon of the device based on the piping layer and on the direction
#define PIPING_LAYER_SHIFT(T, PipingLayer) \
	if(T.dir & (NORTH|SOUTH)) { \
		T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	} \
	if(T.dir & (EAST|WEST)) { \
		T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;\
	}

///Moves the icon of the device based on the piping layer and on the direction, the shift amount is dictated by more_shift
#define PIPING_FORWARD_SHIFT(T, PipingLayer, more_shift) \
	if(T.dir & (NORTH|SOUTH)) { \
		T.pixel_y += more_shift * (PipingLayer - PIPING_LAYER_DEFAULT);\
	} \
	if(T.dir & (EAST|WEST)) { \
		T.pixel_x += more_shift * (PipingLayer - PIPING_LAYER_DEFAULT);\
	}

///Moves the icon of the device based on the piping layer on both x and y
#define PIPING_LAYER_DOUBLE_SHIFT(T, PipingLayer) \
	T.pixel_x = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_X;\
	T.pixel_y = (PipingLayer - PIPING_LAYER_DEFAULT) * PIPING_LAYER_P_Y;

///Calculate the thermal energy of the selected gas (J)
#define THERMAL_ENERGY(gas) (gas.temperature * gas.getHeatCapacity())

// Orphaned LINDA helper. Important for cryo and a couple of other temperature fuckery machines.

/* Fetch the energy transferred when two gas mixtures's temperature equalize.
 *
 * To equalize two gas mixtures, we simply pool the energy and divide it by the pooled heat capacity.
 * T' = (W1+W2) / (C1+C2)
 * But if we want to moderate this conduction, maybe we can calculate the energy transferred
 * and multiply a coefficient to it instead.
 * This is the energy transferred:
 * W = T' * C1 - W1
 * W = (W1+W2) / (C1+C2) * C1 - W1
 * W = (W1C1 + W2C1) / (C1+C2) - W1
 * W = ((W1C1 + W2C1) - (W1 * (C1+C2))) / (C1+C2)
 * W = ((W1C1 + W2C1) - (W1C1 + W1C2)) / (C1+C2)
 * W = (W1C1 - W1C1 + W2C1 - W1C2) / (C1+C2)
 * W = (W2C1 - W1C2) / (C1+C2)
 * W = (T2*C2*C1 - T1*C1*C2) / (C1+C2)
 * W = (C1*C2) * (T2-T1) / (C1+C2)
 *
 * W: Energy involved in the operation
 * T': Combined temperature
 * T1, C1, W1: Temp, heat cap, and thermal energy of the first gas mixture
 * T2, C2, W2: Temp, heat cap, and thermal energy of the second gas mixture
 *
 * Not immediately obvious, but saves us operation time.
 *
 * We put a lot of parentheses here because the numbers get really really big.
 * By prioritizing the division we try to tone the number down so we dont get overflows.
 *
 * Arguments:
 * * temperature_delta: T2 - T1. [/datum/gas_mixture/var/temperature]
 * If you have any moderating (less than 1) coefficients and are dealing with very big numbers
 * multiply the temperature_delta by it first before passing so we get even more breathing room.
 * * heat_capacity_one:  gasmix one's [/datum/gas_mixture/proc/heat_capacity]
 * * heat_capacity_two: gasmix two's [/datum/gas_mixture/proc/heat_capacity]
 * Returns: The energy gained by gas mixture one. Negative if gas mixture one loses energy.
 * Honestly the heat capacity is interchangeable, just make sure the delta is right.
 */
#define CALCULATE_CONDUCTION_ENERGY(temperature_delta, heat_capacity_one, heat_capacity_two)\
	((temperature_delta) * ((heat_capacity_one) * ((heat_capacity_two) / ((heat_capacity_one) + (heat_capacity_two)))))
