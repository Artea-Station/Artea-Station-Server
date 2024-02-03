#define COOLANT_INPUT_GATE airs[1]
#define MODERATOR_INPUT_GATE airs[2]
#define COOLANT_OUTPUT_GATE airs[3]

#define RBMK_TEMPERATURE_OPERATING 800
#define RBMK_TEMPERATURE_HOT 920
#define RBMK_TEMPERATURE_CRITICAL 1040 //At this point the entire ship/station is alerted to a meltdown. This may need altering
#define RBMK_TEMPERATURE_MELTDOWN 1230

#define RBMK_NO_COOLANT_TOLERANCE 5 //How many process()ing ticks the reactor can sustain without coolant before slowly taking damage

#define RBMK_PRESSURE_OPERATING 1000 //PSI
#define RBMK_PRESSURE_CRITICAL 1469.59 //PSI

#define RBMK_MAX_CRITICALITY 3 //No more criticality than N for now.

#define RBMK_POWER_FLAVOURISER 1000 //To turn those KWs into something usable
