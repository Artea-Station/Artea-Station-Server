import { StatelessComponent } from 'inferno';
import { Box, Icon, Stack, StyleableSection, Tooltip } from '../../components';
import { PreferencesMenuData, Quirk } from './data';
import { useBackend, useLocalState } from '../../backend';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

const getValueClass = (value: number): string => {
  if (value > 0) {
    return 'positive';
  } else if (value < 0) {
    return 'negative';
  } else {
    return 'neutral';
  }
};

const QuirkList = (props: {
  quirks: [
    string,
    Quirk & {
      failTooltip?: string;
    }
  ][];
  onClick: (quirkName: string, quirk: Quirk) => void;
}) => {
  return (
    // Stack is not used here for a variety of IE flex bugs
    <Box
      className="PreferencesMenu__Quirks__QuirkList"
      width="100%"
      maxHeight="23rem"
      style={{
        'display': 'flex',
        'flex-wrap': 'wrap',
        'justify-content': 'center',
      }}>
      {props.quirks.map(([quirkKey, quirk]) => {
        const className = 'PreferencesMenu__Quirks__QuirkList__quirk';

        const child = (
          <Box
            className={className}
            key={quirkKey}
            role="button"
            tabIndex="1"
            width="50%"
            onClick={() => {
              props.onClick(quirkKey, quirk);
            }}>
            <Stack fill>
              <Stack.Item
                align="stretch"
                style={{
                  'margin-left': 0,
                }}
              />

              <Stack.Item
                grow
                style={{
                  'margin-left': 0,

                  // Fixes an IE bug for text overflowing in Flex boxes
                  'min-width': '0%',
                }}>
                <Stack vertical fill>
                  <Stack.Item
                    className={`${className}--${getValueClass(quirk.value)}`}
                    style={{
                      'border-bottom': '1px solid black',
                      'padding': '2px',
                    }}>
                    <Stack
                      fill
                      style={{
                        'font-size': '1.2em',
                      }}>
                      <Stack.Item grow basis="content">
                        <Box
                          inline
                          width="2.8em"
                          style={{
                            'text-align': 'center',
                          }}>
                          <Icon fontSize="1.6em" name={quirk.icon} />
                        </Box>
                        <b>{quirk.name}</b>
                      </Stack.Item>

                      <Stack.Item>
                        <b>{quirk.value}</b>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>

                  <Stack.Item
                    color="#aaa"
                    grow
                    basis="content"
                    style={{
                      'margin-top': 0,
                      'padding': '3px',
                    }}>
                    {quirk.description}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Box>
        );

        if (quirk.failTooltip) {
          return <Tooltip content={quirk.failTooltip}>{child}</Tooltip>;
        } else {
          return child;
        }
      })}
    </Box>
  );
};

const StatDisplay: StatelessComponent<{ color }> = (props) => {
  return (
    <Box
      backgroundColor="#eee"
      bold
      color={props.color}
      fontSize="1.1em"
      px={0.5}
      inline>
      {props.children}
    </Box>
  );
};

export const QuirksPage = (props, context) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);

  const [selectedQuirks, setSelectedQuirks] = useLocalState(
    context,
    `selectedQuirks_${data.active_slot}`,
    data.selected_quirks
  );

  return (
    <ServerPreferencesFetcher
      render={(data) => {
        if (!data) {
          return <Box>Loading quirks...</Box>;
        }

        const {
          max_positive_quirks: maxPositiveQuirks,
          quirk_blacklist: quirkBlacklist,
          quirk_info: quirkInfo,
        } = data.quirks;

        const quirks = Object.entries(quirkInfo);
        quirks.sort(([_, quirkA], [__, quirkB]) => {
          if (quirkA.value === quirkB.value) {
            return quirkA.name > quirkB.name ? 1 : -1;
          } else {
            return quirkA.value - quirkB.value;
          }
        });

        let balance = 0;
        let positiveQuirks = 0;

        for (const selectedQuirkName of selectedQuirks) {
          const selectedQuirk = quirkInfo[selectedQuirkName];
          if (!selectedQuirk) {
            continue;
          }

          if (selectedQuirk.value > 0) {
            positiveQuirks += 1;
          }

          balance += selectedQuirk.value;
        }

        const getReasonToNotAdd = (quirkName: string) => {
          const quirk = quirkInfo[quirkName];

          if (quirk.value > 0) {
            if (positiveQuirks >= maxPositiveQuirks) {
              return "You can't have any more positive quirks!";
            } else if (balance + quirk.value > 0) {
              return 'You need a negative quirk to balance this out!';
            }
          }

          const selectedQuirkNames = selectedQuirks.map((quirkKey) => {
            return quirkInfo[quirkKey].name;
          });

          for (const blacklist of quirkBlacklist) {
            if (blacklist.indexOf(quirk.name) === -1) {
              continue;
            }

            for (const incompatibleQuirk of blacklist) {
              if (
                incompatibleQuirk !== quirk.name &&
                selectedQuirkNames.indexOf(incompatibleQuirk) !== -1
              ) {
                return `This is incompatible with ${incompatibleQuirk}!`;
              }
            }
          }

          return undefined;
        };

        const getReasonToNotRemove = (quirkName: string) => {
          const quirk = quirkInfo[quirkName];

          if (balance - quirk.value > 0) {
            return 'You need to remove a positive quirk first!';
          }

          return undefined;
        };

        return (
          <Stack vertical fill>
            <Stack.Item width="100%">
              <StyleableSection
                title={
                  <>
                    {'Available Quirks'}
                    <Box inline style={{ 'float': 'right' }}>
                      <Box inline>Positive Quirks:</Box>
                      {'  '}
                      <Box
                        inline
                        color={positiveQuirks < maxPositiveQuirks && 'good'}>
                        {positiveQuirks} / {maxPositiveQuirks}
                      </Box>
                    </Box>
                  </>
                }
                scrollable>
                <QuirkList
                  onClick={(quirkName, quirk) => {
                    if (getReasonToNotAdd(quirkName) !== undefined) {
                      return;
                    }

                    setSelectedQuirks(selectedQuirks.concat(quirkName));

                    act('give_quirk', { quirk: quirk.name });
                  }}
                  quirks={quirks
                    .filter(([quirkName, _]) => {
                      return selectedQuirks.indexOf(quirkName) === -1;
                    })
                    .map(([quirkName, quirk]) => {
                      return [
                        quirkName,
                        {
                          ...quirk,
                          failTooltip: getReasonToNotAdd(quirkName),
                        },
                      ];
                    })}
                />
              </StyleableSection>
            </Stack.Item>

            <Stack.Item width="100%">
              <StyleableSection
                title={
                  <>
                    {'Current Quirks'}
                    <Box inline style={{ 'float': 'right' }}>
                      <Box inline>Quirk Points:</Box>
                      {'  '}
                      <Box inline color={balance < 0 && 'good'}>
                        {balance}
                      </Box>
                    </Box>
                  </>
                }
                scrollable>
                <QuirkList
                  onClick={(quirkName, quirk) => {
                    if (getReasonToNotRemove(quirkName) !== undefined) {
                      return;
                    }

                    setSelectedQuirks(
                      selectedQuirks.filter(
                        (otherQuirk) => quirkName !== otherQuirk
                      )
                    );

                    act('remove_quirk', { quirk: quirk.name });
                  }}
                  quirks={quirks
                    .filter(([quirkName, _]) => {
                      return selectedQuirks.indexOf(quirkName) !== -1;
                    })
                    .map(([quirkName, quirk]) => {
                      return [
                        quirkName,
                        {
                          ...quirk,
                          failTooltip: getReasonToNotRemove(quirkName),
                        },
                      ];
                    })}
                />
              </StyleableSection>
            </Stack.Item>
          </Stack>
        );
      }}
    />
  );
};
