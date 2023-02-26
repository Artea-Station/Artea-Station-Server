import { useBackend } from '../../backend';
import { Button, Stack } from '../../components';
import { PreferencesMenuData } from './data';
import { CharacterPreview } from './CharacterPreview';
import { PreferenceList } from './Base';

export const MiscPage = (context, parentContext) => {
  const { act, data } = useBackend<PreferencesMenuData>(parentContext);

  return (
    <Stack>
      <Stack.Item>
        <CharacterPreview height="300px" id={data.character_preview_view} />
        <Stack mt="1.5em">
          <Stack.Item ml="auto">
            <Button
              onClick={() => act('rotate', { dir: '90' })}
              fontSize="22px"
              icon="undo"
              tooltip="Rotate Left"
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item mr="auto">
            <Button
              onClick={() => act('rotate', { dir: '-90' })}
              fontSize="22px"
              icon="redo"
              tooltip="Rotate Right"
              tooltipPosition="top"
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack vertical ml="5px" width="100%">
        <Stack.Item height="100%">
          <Stack vertical fill>
            <PreferenceList
              act={act}
              preferences={data.character_preferences.misc_list}
            />
          </Stack>
        </Stack.Item>
      </Stack>
    </Stack>
  );
};
