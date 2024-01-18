import { FeatureColorInput, Feature, FeatureChoiced, FeatureDropdownInput, FeatureNumberInput, CheckboxInput, FeatureTriColorInput } from './base';

export const eye_color: Feature<string> = {
  name: 'Eye color',
  component: FeatureColorInput,
};

export const facial_hair_color: Feature<string> = {
  name: 'Facial hair color',
  component: FeatureColorInput,
};

export const facial_hair_gradient: FeatureChoiced = {
  name: 'Facial hair gradient',
  component: FeatureDropdownInput,
};

export const facial_hair_gradient_color: Feature<string> = {
  name: 'Facial hair gradient color',
  component: FeatureColorInput,
};

export const hair_color: Feature<string> = {
  name: 'Hair color',
  component: FeatureColorInput,
};

export const hair_gradient: FeatureChoiced = {
  name: 'Hair gradient',
  component: FeatureDropdownInput,
};

export const hair_gradient_color: Feature<string> = {
  name: 'Hair gradient color',
  component: FeatureColorInput,
};

export const feature_human_ears: FeatureChoiced = {
  name: 'Ears',
  component: FeatureDropdownInput,
};

export const feature_human_tail: FeatureChoiced = {
  name: 'Tail',
  component: FeatureDropdownInput,
};

export const feature_lizard_legs: FeatureChoiced = {
  name: 'Legs',
  component: FeatureDropdownInput,
};

export const feature_lizard_spines: FeatureChoiced = {
  name: 'Spines',
  component: FeatureDropdownInput,
};

export const feature_lizard_tail: FeatureChoiced = {
  name: 'Tail',
  component: FeatureDropdownInput,
};

export const feature_mcolor: Feature<string> = {
  name: 'Mutant color',
  component: FeatureColorInput,
};

export const underwear_color: Feature<string> = {
  name: 'Underwear color',
  component: FeatureColorInput,
};

export const undershirt_color: Feature<string> = {
  name: 'Undershirt Color',
  component: FeatureColorInput,
};

export const socks_color: Feature<string> = {
  name: 'Socks Color',
  component: FeatureColorInput,
};

export const feature_vampire_status: Feature<string> = {
  name: 'Vampire status',
  component: FeatureDropdownInput,
};

export const heterochromatic: Feature<string> = {
  name: 'Heterochromatic (Right Eye) color',
  component: FeatureColorInput,
};

export const synth_antenna_color: Feature<string> = {
  name: 'Synth Antenna Color',
  component: FeatureTriColorInput,
};

export const synth_screen_color: Feature<string> = {
  name: 'Synth Screen Color',
  component: FeatureTriColorInput,
};

export const synth_head_color: Feature<string> = {
  name: 'Synth Head Color',
  component: FeatureTriColorInput,
};

export const synth_chassis_color: Feature<string> = {
  name: 'Synth Chassis Color',
  component: FeatureTriColorInput,
};

export const feature_hair_opacity: Feature<number> = {
  name: 'Hair Opacity',
  component: FeatureNumberInput,
};

export const feature_hair_opacity_toggle: Feature<boolean> = {
  name: 'Custom Hair Opacity',
  component: CheckboxInput,
};

export const tail_human_color: Feature<string> = {
  name: 'Tail Color',
  component: FeatureTriColorInput,
};

export const ears_color: Feature<string> = {
  name: 'Ears Color',
  component: FeatureTriColorInput,
};

export const horns_color: Feature<string> = {
  name: 'Horns Color',
  component: FeatureTriColorInput,
};

export const lizard_frills_color: Feature<string> = {
  name: 'Frills Color',
  component: FeatureTriColorInput,
};

export const lizard_snout_color: Feature<string> = {
  name: 'Snout Color',
  component: FeatureTriColorInput,
};

export const lizard_tail_color: Feature<string> = {
  name: 'Tail Color',
  component: FeatureTriColorInput,
};

export const lizard_spines_color: Feature<string> = {
  name: 'Spines Color',
  component: FeatureTriColorInput,
};

export const body_markings_color: Feature<string> = {
  name: 'Body Markings Color',
  component: FeatureTriColorInput,
};
