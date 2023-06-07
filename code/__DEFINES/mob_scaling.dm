/// WARNING: Editing any of these numbers without discussion with maintainers beforehand will lead to your PR being denied.

/// The normal size for a mob to be.
#define MOB_SCALE_NORMAL 100

/// The minimum height (in pixels) someone can be without dwarfism.
#define MOB_SCALE_HEIGHT_MIN 10
/// The maximum height (in pixels) someone can be without gigantism.
#define MOB_SCALE_HEIGHT_MAX 100

/// The minimum width (in pixels) someone can be without dwarfism.
/// Intentionally very restrictive due to how easy it is to cause severe distortions when screwing with this number,
///  due to humanoids being *usually* drastically taller than they are wide.
#define MOB_SCALE_WIDTH_MIN 10
/// The maximum width (in pixels) someone can be without gigantism.
#define MOB_SCALE_WIDTH_MAX 100

#define MOB_SCALE_VALID_SIZES = list( \
	0.89, \
\
)
