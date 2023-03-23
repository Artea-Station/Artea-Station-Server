import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Icon, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

type CharacterData = {
  name;
  species;
  is_victim;
  erp_status;
  character_ad;
  ooc_notes;
  flavor_text;
};

type Data = {
  other_players;
  erp_status;
  is_victim;
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
  const [overlay, setOverlay] = useLocalState<CharacterData | null>(
    context,
    'overlay',
    null
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
      <Section title="Can Be Victim">
        <Box p={1}>{overlay.is_victim}</Box>
      </Section>
      <Section title="ERP Status">
        <Box>{overlay.erp_status}</Box>
      </Section>
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
