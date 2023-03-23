import { Feature, FeatureDropdownInput } from '../base';

export const ooc_notes: Feature<string> = {
  name: 'OOC Notes',
  description: 'Stuff that you want to say about yourself OOCly!',
  component: FeatureDropdownInput,
};
