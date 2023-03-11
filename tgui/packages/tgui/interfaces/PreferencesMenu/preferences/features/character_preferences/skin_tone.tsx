import { sortBy } from 'common/collections';
import { Box, Stack } from '../../../../../components';
import { CheckboxInput, Feature, FeatureChoicedServerData, FeatureColorInput, FeatureValueProps, StandardizedDropdown } from '../base';

type HexValue = {
  lightness: number;
  value: string;
};

type SkinToneServerData = FeatureChoicedServerData & {
  display_names: NonNullable<FeatureChoicedServerData['display_names']>;
  to_hex: Record<string, HexValue>;
};

const sortHexValues = sortBy<[string, HexValue]>(
  ([_, hexValue]) => -hexValue.lightness
);

export const skin_tone: Feature<string, string, SkinToneServerData> = {
  name: 'Skin tone',
  component: (props: FeatureValueProps<string, string, SkinToneServerData>) => {
    const { handleSetValue, serverData, value } = props;

    if (!serverData) {
      return null;
    }

    return (
      <StandardizedDropdown
        choices={sortHexValues(Object.entries(serverData.to_hex)).map(
          ([key]) => key
        )}
        displayNames={Object.fromEntries(
          Object.entries(serverData.display_names).map(([key, displayName]) => {
            const hexColor = serverData.to_hex[key];

            return [
              key,
              <Stack align="center" fill key={key}>
                <Stack.Item>
                  <Box
                    style={{
                      background: hexColor.value,
                      'box-sizing': 'content-box',
                      'height': '11px',
                      'width': '11px',
                    }}
                  />
                </Stack.Item>

                <Stack.Item grow>{displayName}</Stack.Item>
              </Stack>,
            ];
          })
        )}
        onSetValue={handleSetValue}
        value={value}
      />
    );
  },
};

export const skin_color: Feature<string> = {
  name: 'Skin color',
  component: FeatureColorInput,
};

export const use_skin_tone: Feature<boolean> = {
  name: 'Use skin tones',
  component: CheckboxInput,
};
