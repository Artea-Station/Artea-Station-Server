import { Button, Divider, Popper, Stack } from '../../components';
import { Page } from './CharacterPreferenceWindow';
import { CharacterPreview } from './CharacterPreview';
import { useBackend, useLocalState } from '../../backend';
import { createSetPreference, PreferencesMenuData } from './data';
import { BigPageButton } from './PageButton';
import { MultiNameInput, NameInput } from './names';
import { Gender, GENDERS } from './preferences/gender';

const CharacterControls = (props: {
  handleRotate: (String) => void;
  handleFood: () => void;
  handleOpenSpecies: () => void;
  gender: Gender;
  setGender: (gender: Gender) => void;
  showGender: boolean;
}) => {
  return (
    <Stack>
      <Stack.Item>
        <Button
          onClick={() => props.handleRotate('90')}
          fontSize="22px"
          icon="undo"
          tooltip="Rotate Left"
          tooltipPosition="top"
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          onClick={() => props.handleRotate('-90')}
          fontSize="22px"
          icon="redo"
          tooltip="Rotate Right"
          tooltipPosition="top"
        />
      </Stack.Item>

      <Stack.Item>
        <Button
          onClick={props.handleFood}
          fontSize="22px"
          icon="drumstick-bite"
          tooltip="Edit Food Preferences"
          tooltipPosition="top"
        />
      </Stack.Item>

      <Stack.Item>
        <Button
          onClick={props.handleOpenSpecies}
          fontSize="22px"
          icon="paw"
          tooltip="Species"
          tooltipPosition="top"
        />
      </Stack.Item>

      {props.showGender && (
        <Stack.Item>
          <GenderButton
            gender={props.gender}
            handleSetGender={props.setGender}
          />
        </Stack.Item>
      )}
    </Stack>
  );
};

const GenderButton = (
  props: {
    handleSetGender: (gender: Gender) => void;
    gender: Gender;
  },
  context
) => {
  const [genderMenuOpen, setGenderMenuOpen] = useLocalState(
    context,
    'genderMenuOpen',
    false
  );

  return (
    <Popper
      options={{
        placement: 'right-end',
      }}
      popperContent={
        genderMenuOpen && (
          <Stack backgroundColor="white" ml={0.5} p={0.3}>
            {[Gender.Male, Gender.Female, Gender.Other, Gender.Other2].map(
              (gender) => {
                return (
                  <Stack.Item key={gender}>
                    <Button
                      selected={gender === props.gender}
                      onClick={() => {
                        props.handleSetGender(gender);
                        setGenderMenuOpen(false);
                      }}
                      fontSize="22px"
                      icon={GENDERS[gender].icon}
                      tooltip={GENDERS[gender].text}
                      tooltipPosition="top"
                    />
                  </Stack.Item>
                );
              }
            )}
          </Stack>
        )
      }>
      <Button
        onClick={() => {
          setGenderMenuOpen(!genderMenuOpen);
        }}
        fontSize="22px"
        icon={GENDERS[props.gender].icon}
        tooltip="Gender"
        tooltipPosition="top"
      />
    </Popper>
  );
};

export const IndexPage = (context, parentContext) => {
  const { act, data } = useBackend<PreferencesMenuData>(parentContext);
  const [currentPage, setCurrentPage] = useLocalState(
    parentContext,
    'currentPage',
    Page.Index
  );
  const [multiNameInputOpen, setMultiNameInputOpen] = useLocalState(
    parentContext,
    'multiNameInputOpen',
    false
  );

  return (
    <>
      {multiNameInputOpen && (
        <MultiNameInput
          handleClose={() => setMultiNameInputOpen(false)}
          handleRandomizeName={(preference) =>
            act('randomize_name', {
              preference,
            })
          }
          handleUpdateName={(nameType, value) =>
            act('set_preference', {
              preference: nameType,
              value,
            })
          }
          names={data.character_preferences.names}
        />
      )}

      <Stack fill>
        <Stack.Item>
          <Stack vertical>
            <Stack.Item height="300px">
              <CharacterPreview
                height="300px"
                id={data.character_preview_view}
              />
            </Stack.Item>
            <Stack.Item>
              <NameInput
                name={data.character_preferences.names[data.name_to_use]}
                handleUpdateName={createSetPreference(act, data.name_to_use)}
                openMultiNameInput={() => {
                  setMultiNameInputOpen(true);
                }}
              />
            </Stack.Item>
            <Stack.Item>
              <CharacterControls
                gender={data.character_preferences.misc.gender}
                handleOpenSpecies={() => setCurrentPage(Page.Species)}
                handleRotate={(dir) => {
                  act('rotate', { 'dir': dir });
                }}
                handleFood={() => {
                  act('open_food');
                }}
                setGender={createSetPreference(act, 'gender')}
                showGender={
                  data.character_preferences.misc.species
                    ? !!data.character_preferences.misc.gender
                    : true
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <Stack.Item width="100%">
          <h2>Categories</h2>

          <Divider />

          <Stack width="100%">
            <Stack.Item width="33%">
              <Stack vertical>
                <Stack.Item>
                  <BigPageButton
                    page={Page.Appearance}
                    setPage={setCurrentPage}
                    tooltip="Your character's basic appearance!">
                    Appearance
                  </BigPageButton>
                </Stack.Item>

                <Stack.Item>
                  <BigPageButton
                    page={Page.Antags}
                    setPage={setCurrentPage}
                    tooltip="Which evil guys you wanna be randomly rolled as!">
                    Antagonists
                  </BigPageButton>
                </Stack.Item>

                <Stack.Item>
                  <BigPageButton
                    page={Page.Inspection}
                    setPage={setCurrentPage}
                    tooltip="The flavour text that's shown for your character!">
                    Inspection Text
                  </BigPageButton>
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item fill width="33%">
              <Stack vertical>
                <Stack.Item>
                  <BigPageButton
                    page={Page.Clothing}
                    setPage={setCurrentPage}
                    tooltip="Your character's clothes that they start with!"
                    tooltipPosition="bottom">
                    Clothing
                  </BigPageButton>
                </Stack.Item>

                <Stack.Item>
                  <BigPageButton
                    page={Page.Quirks}
                    setPage={setCurrentPage}
                    tooltip="Odd traits that can range from a minor boon, to a fundimental gameplay alteration in order to stay alive!"
                    tooltipPosition="bottom">
                    Quirks
                  </BigPageButton>
                </Stack.Item>
              </Stack>
            </Stack.Item>

            <Stack.Item fill width="33%">
              <Stack vertical>
                <Stack.Item>
                  <BigPageButton
                    page={Page.Jobs}
                    setPage={setCurrentPage}
                    tooltip="What jobs your character plays!">
                    Occupations
                  </BigPageButton>
                </Stack.Item>

                <Stack.Item>
                  <BigPageButton
                    page={Page.Misc}
                    setPage={setCurrentPage}
                    tooltip="Various settings!">
                    Misc
                  </BigPageButton>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </>
  );
};
