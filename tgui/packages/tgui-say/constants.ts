/** Window sizes in pixels */
export enum WINDOW_SIZES {
  small = 50,
  medium = 70,
  large = 110,
  width = 281,
}

/** Line lengths for autoexpand */
export enum LINE_LENGTHS {
  small = 44,
  medium = 90,
}

/**
 * Radio prefixes.
 * Displays the name in the left button, tags a css class.
 */
export const RADIO_PREFIXES = {
  ':a ': 'Hive',
  ':b ': 'io',
  ':c ': 'Cmd',
  ':e ': 'Engi',
  ':m ': 'Med',
  ':n ': 'Sci',
  ':o ': 'AI',
  ':s ': 'Sec',
  ':t ': 'Synd',
  ':u ': 'Supp',
  ':v ': 'Svc',
  ':y ': 'CCom',
} as const;
