import { FeatureColorInput, Feature, FeatureChoiced, FeatureDropdownInput, FeatureNumberInput, CheckboxInput } from './base';

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

export const feature_vampire_status: Feature<string> = {
  name: 'Vampire status',
  component: FeatureDropdownInput,
};

export const heterochromatic: Feature<string> = {
  name: 'Heterochromatic (Right Eye) color',
  component: FeatureColorInput,
};

export const ipc_antenna_color: Feature<string> = {
  name: 'Synth Antenna Color',
  component: FeatureColorInput,
};

export const synth_screen_color: Feature<string> = {
  name: 'Synth Screen Color',
  component: FeatureColorInput,
};

export const ipc_head_color: Feature<string> = {
  name: 'Synth Head Color',
  component: FeatureColorInput,
};

export const ipc_chassis_color: Feature<string> = {
  name: 'Synth Chassis Color',
  component: FeatureColorInput,
};

export const feature_hair_opacity: Feature<number> = {
  name: 'Hair Opacity',
  component: FeatureNumberInput,
};

export const feature_hair_opacity_toggle: Feature<boolean> = {
  name: 'Custom Hair Opacity',
  component: CheckboxInput,
};
