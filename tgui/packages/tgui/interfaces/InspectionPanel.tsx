import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Stack, Section, Button } from '../components';
import { Window } from '../layouts';

type InspectionData = {
  name: string;
  species: string;
  species_lore: [];
  inspection_data: Record<string, string>;
  ooc_notes: string[];
  show_ooc: BooleanLike;
};

export const InspectionPanel = (props, context) => {
  const { act, data } = useBackend<InspectionData>(context);
  const { name, species, species_lore, inspection_data, ooc_notes, show_ooc } =
    data;
  return (
    <Window title="Examine Panel" width={900} height={670}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow>
            <Stack fill vertical>
              <Stack.Item grow>
                <Section
                  scrollable
                  fill
                  title={name + "'s Flavor Text:"}
                  preserveWhitespace>
                  {Object.entries(inspection_data).map((entry) => {
                    const [key, data] = entry;
                    return (
                      data?.length > 0 && (
                        <>
                          <h4>
                            {(key.endsWith('_arm') && 'Arms') || // I could've made this prettier, but the tradeoff wouldn't really be worth it.
                              (key.endsWith('_leg') && 'Legs') ||
                              (key === 'eyes' && 'Face') ||
                              key.charAt(0).toUpperCase() + key.slice(1)}
                            :
                          </h4>
                          {data}
                          <br />
                          <br />
                        </>
                      )
                    );
                  })}
                </Section>
              </Stack.Item>
              <Button
                width="100%"
                style={{ 'text-align': 'center' }}
                onClick={() => act('toggle_ooc_info')}>
                {show_ooc ? 'Hide' : 'Show'} Extra Info
              </Button>
              {show_ooc === true && (
                <Stack.Item grow>
                  <Stack fill>
                    <Stack.Item grow basis={0}>
                      <Section
                        scrollable
                        fill
                        title="OOC Notes"
                        preserveWhitespace>
                        {ooc_notes}
                      </Section>
                    </Stack.Item>
                    <Stack.Item grow basis={0}>
                      <Section
                        scrollable
                        fill
                        title={species}
                        preserveWhitespace>
                        {Object.entries(species_lore).map((entry) => {
                          return (
                            <>
                              {entry[1]}
                              <br />
                              <br />
                            </>
                          );
                        })}
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
