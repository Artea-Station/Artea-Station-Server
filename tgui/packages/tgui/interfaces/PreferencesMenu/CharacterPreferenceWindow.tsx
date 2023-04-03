import { exhaustiveCheck } from 'common/exhaustive';
import { useBackend, useLocalState } from '../../backend';
import { Box, Dropdown, Flex, Icon, Stack } from '../../components';
import { Window } from '../../layouts';
import { PreferencesMenuData } from './data';
import { PageButton } from './PageButton';
import { AntagsPage } from './AntagsPage';
import { JobsPage } from './JobsPage';
import { AppearancePage } from './AppearancePage';
import { SpeciesPage } from './SpeciesPage';
import { QuirksPage } from './QuirksPage';
import { IndexPage } from './IndexPage';
import { ClothingPage } from './ClothingPage';
import { MiscPage } from './MiscPage';
import { InspectionPage } from './InspectionPage';
import { OOCPage } from './OOCPage';
import { ContentPage } from './ContentPage';

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

  switch (currentPage) {
    case Page.Index:
      pageContents = <IndexPage parentContext={context} data={data} />;
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

          <Stack.Item height="100%">{pageContents}</Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
