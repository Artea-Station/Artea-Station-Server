import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Icon, LabeledList, NoticeBox, Section, StyleableSection, Table } from '../components';
import { Window } from '../layouts';

type CharacterData = {
  name;
  species;
  ooc_notes;
  is_victim;
  erp_status;
  erp_orientation;
  erp_position;
  erp_non_con;
  brainwashing;
  borging;
  kidnapping;
  isolation;
  torture;
  death;
  round_removal;
  flavor_text;
};

type Data = {
  other_players;
  erp_status;
  is_victim;
};

const MatchmakingCategory = (props, context) => {
  return (
    <StyleableSection
      childStyle={{ 'border-left': '0.1666666667em solid #4972a1' }}
      title={props.title}>
      {props.children}
    </StyleableSection>
  );
};

export const MatchmakingPanel = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { is_victim, erp_status } = data;

  const [overlay] = useLocalState(context, 'overlay', null);

  return (
    <Window width={640} height={480} resizeable>
      <Window.Content scrollable>
        {(overlay && <ViewCharacter />) || (
          <Fragment>
            <Section title="Self Information">
              <LabeledList>
                <LabeledList.Item label="Is Victim">
                  <Button
                    fluid
                    content={is_victim}
                    onClick={() => act('toggle_victim_status')}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="ERP Status">
                  {erp_status}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <CharacterDirectoryList />
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};

const ViewCharacter = (props, context) => {
  const { data } = useBackend<Data>(context);
  const [overlay, setOverlay] = useLocalState<CharacterData | null>(
    context,
    'overlay',
    null
  );
  const [overrideERPCheck, setOverrideERPCheck] = useLocalState<boolean>(
    context,
    'overrideERPCheck',
    false
  );

  if (!overlay) {
    return <Box />;
  }

  return (
    <Section
      title={overlay.name}
      buttons={
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => setOverlay(null)}
        />
      }>
      <Section title="Species">
        <Box>{overlay.species}</Box>
      </Section>
      <MatchmakingCategory title="ERP Preferences">
        <Section title="ERP Status">
          <Box>{overlay.erp_status}</Box>
        </Section>
        {data.erp_status !== 'No' && !overrideERPCheck ? (
          <>
            <Section title="ERP Orientation">
              <Box>{overlay.erp_orientation}</Box>
            </Section>
            <Section title="ERP Position">
              <Box>{overlay.erp_position}</Box>
            </Section>
            <Section title="ERP Non-Con">
              <NoticeBox>
                Remember, non-con should be performed in a private environment,
                for the OOC comfort of others!
              </NoticeBox>
              <Box>{overlay.erp_non_con}</Box>
            </Section>
          </>
        ) : (
          <Button onClick={setOverrideERPCheck(true)}>Show ERP Prefs?</Button>
        )}
      </MatchmakingCategory>
      <MatchmakingCategory title="General Content Preferences">
        <Section title="Can Be Antag Objective">
          <Box>{overlay.is_victim}</Box>
        </Section>
        <Section title="Can Be Borged">
          <Box>{overlay.borging}</Box>
        </Section>
        <Section title="Can Be Isolated">
          <NoticeBox>
            This is stuff like locker welding, bolting, etc someone with no way
            to interact with the outside world. See &quot;gay baby jailing&quot;
            for an example.
          </NoticeBox>
          <Box>{overlay.isolation}</Box>
        </Section>
        <Section title="Can Be Kidnapped">
          <Box>{overlay.kidnapping}</Box>
        </Section>
        <Section title="Can Be Brainwashed">
          <Box>{overlay.brainwashing}</Box>
        </Section>
        <Section title="Can Be Killed For An Objective">
          <Box>{overlay.death}</Box>
        </Section>
        <Section title="Can Be Round Removed">
          <NoticeBox>
            This means cremating, beheading and hiding the brain, and other such
            ways of ensuring someone cannot return to the round.
          </NoticeBox>
          <Box>{overlay.round_removal}</Box>
        </Section>
      </MatchmakingCategory>
      <Section title="OOC Notes">
        <Box style={{ 'word-break': 'break-all' }} preserveWhitespace>
          {overlay.ooc_notes || 'Unset.'}
        </Box>
      </Section>
      <Section title="Broad Inspection Text">
        <Box style={{ 'word-break': 'break-all' }} preserveWhitespace>
          {overlay.flavor_text || 'Unset.'}
        </Box>
      </Section>
    </Section>
  );
};

const CharacterDirectoryList = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { other_players } = data;

  const [sortId, _setSortId] = useLocalState(context, 'sortId', 'name');
  const [sortOrder, _setSortOrder] = useLocalState(
    context,
    'sortOrder',
    'name'
  );
  const [overlay, setOverlay] = useLocalState<CharacterData | null>(
    context,
    'overlay',
    null
  );

  return (
    <Section
      title="Directory"
      buttons={
        <Button icon="sync" content="Refresh" onClick={() => act('refresh')} />
      }>
      <Table>
        <Table.Row bold>
          <SortButton id="name">Name</SortButton>
          <SortButton id="species">Species</SortButton>
          <SortButton id="is_victim">Can be Victim</SortButton>
          <SortButton id="erp_status">ERP Status</SortButton>
          <Table.Cell collapsing textAlign="right">
            View
          </Table.Cell>
        </Table.Row>
        {other_players
          .sort((a, b) => {
            const i = sortOrder ? 1 : -1;
            return a[sortId].localeCompare(b[sortId]) * i;
          })
          .map((character, i) => (
            <Table.Row key={i}>
              <Table.Cell p={1}>{character.name}</Table.Cell>
              <Table.Cell>{character.species}</Table.Cell>
              <Table.Cell>{character.is_victim}</Table.Cell>
              <Table.Cell>{character.erp_status}</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                <Button
                  onClick={() => setOverlay(character)}
                  color="transparent"
                  icon="sticky-note"
                  mr={1}
                  content="View"
                />
              </Table.Cell>
            </Table.Row>
          ))}
      </Table>
    </Section>
  );
};

const SortButton = (props, context) => {
  const { id, children } = props;

  // Hey, same keys mean same data~
  const [sortId, setSortId] = useLocalState(context, 'sortId', 'name');
  const [sortOrder, setSortOrder] = useLocalState<boolean>(
    context,
    'sortOrder',
    true
  );

  return (
    <Table.Cell collapsing>
      <Button
        width="100%"
        color={sortId !== id && 'transparent'}
        onClick={() => {
          if (sortId === id) {
            setSortOrder(!sortOrder);
          } else {
            setSortId(id);
            setSortOrder(true);
          }
        }}>
        {children}
        {sortId === id && (
          <Icon name={sortOrder ? 'sort-up' : 'sort-down'} ml="0.25rem;" />
        )}
      </Button>
    </Table.Cell>
  );
};
