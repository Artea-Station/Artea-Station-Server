import { useBackend } from '../../backend';
import { Stack } from '../../components';
import { PreferencesMenuData } from './data';
import { PreferenceList } from './Base';

export const ContentPage = (context, parentContext) => {
  const { act, data } = useBackend<PreferencesMenuData>(parentContext);

  return (
    <Stack height="100%">
      <PreferenceList
        act={act}
        preferences={data.character_preferences.content_list}
      />
    </Stack>
  );
};
