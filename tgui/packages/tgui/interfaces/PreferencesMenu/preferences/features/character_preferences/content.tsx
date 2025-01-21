import { CheckboxInput, Feature, FeatureDropdownInput } from '../base';

export const be_victim: Feature<boolean> = {
  name: 'Be Victim',
  description:
    'Whether you want to be a potential victim for direct antagonising. This does not protect you from antagonists, just objectives targeting you.',
  component: CheckboxInput,
};

export const content_brainwashing: Feature<string> = {
  name: 'Brainwashing',
  description: 'Whether you want to be, or are fine with being brainwashed.',
  component: FeatureDropdownInput,
};

export const content_borging: Feature<string> = {
  name: 'Borging',
  description:
    'Whether you want to be, or are fine with being borged. Mechanically enforced.',
  component: FeatureDropdownInput,
};

export const content_kidnapping: Feature<string> = {
  name: 'Kidnapping',
  description: 'Whether you want to be, or are fine with being kidnapped.',
  component: FeatureDropdownInput,
};

export const content_isolation: Feature<string> = {
  name: 'Isolation',
  description:
    'Whether you want to be, or are fine with being isolated. See being "gay baby jailed" for what this pertains to.',
  component: FeatureDropdownInput,
};

export const content_torture: Feature<string> = {
  name: 'Torture',
  description: 'Whether you want to be, or are fine with being tortured.',
  component: FeatureDropdownInput,
};

export const content_death: Feature<string> = {
  name: 'Death',
  description:
    'Whether you want to be, or are fine with being killed as part of an antag objective. Be aware that this does !!NOT!! protect antagonists from killing you as part of a broader plan, or in collateral. This just protects you from being a kill objective.',
  component: FeatureDropdownInput,
};

export const content_round_removal: Feature<string> = {
  name: 'Round Removal',
  description:
    'Whether you want to be, or are fine with being round removed by players. Do note that there are of course, certain situations which can result in round removals due to game mechanics, which cannot be helped in certain situations.',
  component: FeatureDropdownInput,
};

export const erp_status: Feature<string> = {
  name: 'ERP Status',
  description: 'Whether you want to ERP, and the dom/sub role you prefer.',
  component: FeatureDropdownInput,
};
