import { useBackend, useLocalState } from '../../backend';
import { Stack } from '../../components';
import { createSetPreference, PreferencesMenuData } from './data';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';
import { FeatureChoicedServerData } from './preferences/features/base';
import { MainFeature, PreferenceList } from './Base';

export const AppearancePage = (context, parentContext) => {
  const { act, data } = useBackend<PreferencesMenuData>(parentContext);
  const [currentClothingMenu, setCurrentClothingMenu] = useLocalState<
    string | null
  >(parentContext, 'currentClothingMenu', null);

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        const currentSpeciesData =
          serverData &&
          serverData.species[data.character_preferences.misc.species];

        const mainFeatures = [
          ...Object.entries(data.character_preferences.appearance).filter(
            ([featureName]) => {
              if (!currentSpeciesData) {
                return false;
              }

              return (
                currentSpeciesData.enabled_features.indexOf(featureName) !== -1
              );
            }
          ),
        ];

        return (
          <Stack vertical ml="5px" fill>
            <Stack.Item
              fill
              width="100%"
              style={{
                background: 'rgba(0, 0, 0, 0.5)',
                padding: '4px',
              }}
              overflowX="hidden"
              overflowY="scroll">
              <Stack wrap>
                {mainFeatures.map(([clothingKey, clothing]) => {
                  const catalog =
                    serverData &&
                    (serverData[clothingKey] as FeatureChoicedServerData & {
                      name: string;
                    });

                  return (
                    catalog && (
                      <Stack.Item
                        key={clothingKey}
                        mt={0.5}
                        pr={2}
                        pb={1}
                        ml={0}>
                        <MainFeature
                          catalog={catalog}
                          currentValue={clothing}
                          isOpen={currentClothingMenu === clothingKey}
                          handleClose={() => {
                            setCurrentClothingMenu(null);
                          }}
                          handleOpen={() => {
                            setCurrentClothingMenu(clothingKey);
                          }}
                          handleSelect={createSetPreference(act, clothingKey)}
                        />
                      </Stack.Item>
                    )
                  );
                })}
              </Stack>
            </Stack.Item>

            <Stack.Item height="100%">
              <Stack vertical fill>
                <PreferenceList
                  act={act}
                  preferences={data.character_preferences.appearance_list}
                />
              </Stack>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};
