import { useBackend, useLocalState } from '../../backend';
import { Stack } from '../../components';
import { createSetPreference, PreferencesMenuData } from './data';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';
import { FeatureChoicedServerData } from './preferences/features/base';
import { MainFeature } from './Base';

export const ClothingPage = (context, parentContext) => {
  const { act, data } = useBackend<PreferencesMenuData>(parentContext);
  const [currentClothingMenu, setCurrentClothingMenu] = useLocalState<
    string | null
  >(parentContext, 'currentClothingMenu', null);

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
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
              <Stack height="100%" wrap>
                {Object.entries(data.character_preferences.clothing).map(
                  ([clothingKey, clothing]) => {
                    const catalog =
                      serverData &&
                      (serverData[clothingKey] as FeatureChoicedServerData & {
                        name: string;
                      });

                    return (
                      catalog && (
                        <Stack.Item key={clothingKey} mt={0.5} px={0.5}>
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
                            handleSelect={createSetPreference(
                              act,
                              clothingKey
                            )}
                          />
                        </Stack.Item>
                      )
                    );
                  }
                )}
              </Stack>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};
