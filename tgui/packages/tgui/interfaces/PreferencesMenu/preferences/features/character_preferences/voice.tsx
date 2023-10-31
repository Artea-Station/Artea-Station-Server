import { FeatureChoiced, FeatureDropdownInput, FeatureDropdownInputWithSoundPreviewMe, FeatureDropdownInputWithSoundPreviewSay } from '../base';

export const emote_voice: FeatureChoiced = {
  name: 'Emote Voice',
  description: 'Used for emotes, like *scream.',
  component: FeatureDropdownInput,
};

export const say_voice: FeatureChoiced = {
  name: 'Say Voice',
  description: 'Used for when you talk.',
  component: FeatureDropdownInputWithSoundPreviewSay,
};

export const me_sound: FeatureChoiced = {
  name: 'Me Sound',
  description: 'Used for when you use use *me.',
  component: FeatureDropdownInputWithSoundPreviewMe,
};
