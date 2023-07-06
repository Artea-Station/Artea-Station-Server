import { Feature, FeatureShortTextInput } from '../base';

export const bad_touch_message: Feature<string> = {
  name: 'Bad Touch Message',
  description:
    'The message others will see when you are hugged or headpat. Format: "Name{ seems to really dislike being touched!"}',
  component: FeatureShortTextInput,
};
