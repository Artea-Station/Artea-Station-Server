import { CheckboxInput, Feature, FeatureDropdownInput } from '../base';

export const erp_status: Feature<string> = {
  name: 'ERP Status',
  description: 'Whether you want to ERP, and the dom/sub role you prefer.',
  component: FeatureDropdownInput,
};

export const be_victim: Feature<boolean> = {
  name: 'Be Victim',
  description:
    'Whether you want to be a potential victim for direct antagonising. This does not protect you from antagonists, just objectives targeting you.',
  component: CheckboxInput,
};
