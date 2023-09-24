import { exhaustiveCheck } from 'common/exhaustive';
import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Dropdown, Flex, Icon, Popper, Section, Stack } from '../../components';
import { Window } from '../../layouts';
import { createSetPreference, PreferencesMenuData } from './data';
import { PageButton } from './PageButton';
import { AntagsPage } from './AntagsPage';
import { JobsPage } from './JobsPage';
import { AppearancePage } from './AppearancePage';
import { SpeciesPage } from './SpeciesPage';
import { QuirksPage } from './QuirksPage';
import { CharacterControls, IndexPage } from './IndexPage';
import { ClothingPage } from './ClothingPage';
import { MiscPage } from './MiscPage';
import { InspectionPage } from './InspectionPage';
import { OOCPage } from './OOCPage';
import { ContentPage } from './ContentPage';
import { FoodPage } from './FoodPage';
import { LoadoutPage } from './LoadoutPage';
import { CharacterPreview } from '../common/CharacterPreview';
import { BooleanLike } from 'common/react';
import { NameInput } from './names';
import { Gender, GENDERS } from './preferences/gender';

export enum Page {
  Index,
  Antags,
  Appearance,
  Jobs,
  Species,
  Quirks,
  Clothing,
  Misc,
  Inspection,
  OOC,
  Content,
  Food,
  Loadout,
}

const CharacterProfiles = (props: {
  activeSlot: number;
  onClick: (index: number) => void;
  profiles: (string | null)[];
}) => {
  const { profiles, activeSlot, onClick } = props;

  return (
    <Flex align="center" justify="center">
      <Flex.Item width="25%" fontSize="1.2em">
        <Dropdown
          width="100%"
          selected={activeSlot}
          displayText={profiles[activeSlot]}
          options={profiles.map((profile, slot) => ({
            value: slot,
            displayText: profile ?? 'New Character',
          }))}
          onSelected={(slot) => {
            onClick(slot);
          }}
        />
      </Flex.Item>
    </Flex>
  );
};

export const CharacterPreferenceWindow = (props, context) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);

  const [currentPage, setCurrentPage] = useLocalState(
    context,
    'currentPage',
    Page.Index
  );

  let pageContents;
  let extraCharacterControls;

  switch (currentPage) {
    case Page.Index:
      pageContents = <IndexPage parentContext={context} data={data} />;
      extraCharacterControls = (
        <NameInput
          name={data.character_preferences.names[data.name_to_use]}
          handleUpdateName={createSetPreference(act, data.name_to_use)}
        />
      );
      break;

    case Page.Antags:
      pageContents = <AntagsPage />;
      break;

    case Page.Jobs:
      pageContents = <JobsPage />;
      break;

    case Page.Appearance:
      pageContents = (
        <AppearancePage
          openSpecies={() => setCurrentPage(Page.Species)}
          parentContext={context}
        />
      );
      break;

    case Page.Species:
      pageContents = <SpeciesPage />;
      break;

    case Page.Quirks:
      pageContents = <QuirksPage />;
      break;

    case Page.Clothing:
      pageContents = <ClothingPage />;
      break;

    case Page.Misc:
      pageContents = <MiscPage />;
      break;

    case Page.Inspection:
      pageContents = <InspectionPage />;
      break;

    case Page.OOC:
      pageContents = <OOCPage />;
      break;

    case Page.Content:
      pageContents = <ContentPage />;
      break;

    case Page.Food:
      pageContents = <FoodPage />;
      break;

    case Page.Loadout:
      pageContents = <LoadoutPage />;
      break;

    default:
      exhaustiveCheck(currentPage);
  }

  return (
    <Window title="Character Preferences" width={920} height={770}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            {!(currentPage === Page.Index) && (
              <Box width="8em" position="absolute">
                <PageButton
                  currentPage={currentPage}
                  page={Page.Index}
                  setPage={setCurrentPage}>
                  <Icon name="arrow-left" />
                  Index
                </PageButton>
              </Box>
            )}
            <CharacterProfiles
              activeSlot={data.active_slot - 1}
              onClick={(slot) => {
                act('change_slot', {
                  slot: slot + 1,
                });
              }}
              profiles={data.character_profiles}
            />
          </Stack.Item>
          {!data.content_unlocked && (
            <Stack.Item align="center">
              Buy BYOND premium for more slots!
            </Stack.Item>
          )}

          <Stack.Divider />

          <Stack.Item height="100%">
            <Stack fill>
              <Stack.Item style={{ 'width': '280px' }}>
                <LoadoutPreviewSection
                  extra_character_controls={extraCharacterControls}
                />
              </Stack.Item>
              <Stack.Divider />
              <Stack.Item width="100%" height="100%">
                {pageContents}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

type PreviewData = PreferencesMenuData & {
  job_clothes: BooleanLike;
  loadout_clothes: BooleanLike;
  character_preview_view: string;
};

export const LoadoutPreviewSection = (
  props: { extra_character_controls? },
  context
) => {
  const { act, data } = useBackend<PreviewData>(context);
  const { loadout_clothes, job_clothes, character_preview_view } = data;
  const [tutorialStatus] = useLocalState(context, 'tutorialStatus', false);
  return (
    <Section
      grow
      height="100%"
      title={
        <Box style={{ 'font-size': '0.85em', 'text-align': 'center' }}>
          <Button.Checkbox
            align="center"
            content="Toggle Job Clothes"
            checked={job_clothes}
            onClick={() => act('toggle_job_clothes')}
          />
          <Button.Checkbox
            align="center"
            content="Toggle Loadout Clothes"
            checked={loadout_clothes}
            onClick={() => act('toggle_loadout_clothes')}
          />
        </Box>
      }>
      <Stack vertical>
        <Stack.Item height="250px" align="center">
          {!tutorialStatus && (
            <CharacterPreview height="100%" id={character_preview_view} />
          )}
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>{props.extra_character_controls}</Stack.Item>
        <Stack.Item align="center">
          <CharacterControls
            handleRotate={(dir) => {
              act('rotate', { 'dir': dir });
            }}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const GenderButton = (
  props: {
    gender: Gender;
  },
  context
) => {
  const [genderMenuOpen, setGenderMenuOpen] = useLocalState(
    context,
    'genderMenuOpen',
    false
  );
  const { act } = useBackend(context);

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
                        createSetPreference(act, 'gender')(gender);
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
