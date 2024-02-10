/// The max nominal operating temperature.
#define RBMK_TEMPERATURE_OPERATING 800
/// The max hot operating temperature.
#define RBMK_TEMPERATURE_HOT 920
/// The max tmperature the reactor can take before starting to take damage. The station will be alerted above this number.
#define RBMK_TEMPERATURE_CRITICAL 1040
/// The max temperature the reactor can take before turning itself into slag.
#define RBMK_TEMPERATURE_MELTDOWN 1230

/// How many process()ing ticks the reactor can sustain without coolant before slowly taking damage
#define RBMK_NO_COOLANT_TOLERANCE 5

/// The max kpa the reactor can take in coolant before getting mad.
#define RBMK_PRESSURE_OPERATING 1000
/// The max kpa the reactor can take in coolant before detonating.
#define RBMK_PRESSURE_CRITICAL 1500

/// To turn the normally low number into usable power.
#define RBMK_POWER_SANIFIER 10000

/// The base fuel consumption if the fuel is at or below room temp.
#define RBMK_BASE_FUEL_CONSUMPTION 2
/// The minimum coolant moles required for any cooling to take place.
#define RBMK_MINIMUM_COOLANT_CONSUMPTION 15
