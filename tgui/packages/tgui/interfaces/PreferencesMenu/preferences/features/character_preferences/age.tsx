import { Feature, FeatureNumberInput } from '../base';

export const age: Feature<number> = {
  name: 'Age',
  description:
    "The age of your character. If you're a synth, this reflects the target age for your intelligence to simulate.",
  component: FeatureNumberInput,
};
