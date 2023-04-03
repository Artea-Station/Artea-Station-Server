import { Feature, FeatureShortTextInput, FeatureTextInput } from '../base';

export const preview_inspection_text: Feature<string> = {
  name: 'Preview Inspection Text',
  description: 'The short text someone sees about your character on examine.',
  component: FeatureShortTextInput,
};

export const broad_inspection_text: Feature<string> = {
  name: 'Broad Inspection Text',
  description:
    "A longer text description of your character's overall hard to conceal attributes, like height.",
  component: FeatureTextInput,
};

export const face_inspection_text: Feature<string> = {
  name: 'Face Inspection Text',
  description:
    "A longer text description of your character's face. Hidden when your eyes/face are obscured.",
  component: FeatureTextInput,
};

export const head_inspection_text: Feature<string> = {
  name: 'Head Inspection Text',
  description:
    "A longer text description of your character's head. Hidden when your head is obscured.",
  component: FeatureTextInput,
};

export const body_inspection_text: Feature<string> = {
  name: 'Body Inspection Text',
  description:
    "A longer text description of your character's body. Hidden when your body is obscured (nearly always).",
  component: FeatureTextInput,
};

export const arms_inspection_text: Feature<string> = {
  name: 'Arms Inspection Text',
  description:
    "A longer text description of your character's arms. Hidden when your arms are obscured.",
  component: FeatureTextInput,
};

export const legs_inspection_text: Feature<string> = {
  name: 'Legs Inspection Text',
  description:
    "A longer text description of your character's legs. Hidden when your legs are obscured.",
  component: FeatureTextInput,
};

export const ooc_notes: Feature<string> = {
  name: 'OOC Notes',
  description: 'Stuff that you want to say about yourself OOCly!',
  component: FeatureTextInput,
};
