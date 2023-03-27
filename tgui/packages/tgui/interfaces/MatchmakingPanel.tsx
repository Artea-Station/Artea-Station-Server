import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Icon, LabeledList, NoticeBox, Section, StyleableSection, Table } from '../components';
import { TableCell, TableRow } from '../components/Table';
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
  ref_to_load?;
};

const MatchmakingEntry = (props, context) => {
  return props.small ? (
    <TableCell
      width="15rem"
      style={{
        'border-bottom': '0.1666666667em solid #4972a1',
        'padding': '0.5rem',
      }}>
      {props.children}
    </TableCell>
  ) : (
    <TableCell
      style={{
        'border-bottom': '0.1666666667em solid #4972a1',
        'padding': '0.5rem',
      }}>
      {props.children}
    </TableCell>
  );
};

export const MatchmakingPanel = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { is_victim, erp_status } = data;

  const [overlay, setOverlay] = useLocalState<CharacterData | null>(
    context,
    'overlay',
    null
  );

  if (data.ref_to_load) {
    const foundEntries = data.other_players.filter(
      (entry) => entry.ref === data.ref_to_load
    );
    if (foundEntries.length) {
      setOverlay(foundEntries[0]);
    }
  }

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
      <Section title="OOC Notes">
        <Box preserveWhitespace>{overlay.ooc_notes || 'Unset.'}</Box>
      </Section>
      <Section title="Broad Inspection Text">
        <Box preserveWhitespace>{overlay.flavor_text || 'Unset.'}</Box>
      </Section>
      <Section title="Preferences">
        <StyleableSection title="ERP" textStyle={{ 'color': '#dddddd' }}>
          <Table style={{ 'table-layout': 'fixed' }} id="erp_table">
            <TableRow>
              <MatchmakingEntry small>Status</MatchmakingEntry>
              <MatchmakingEntry>{overlay.erp_status}</MatchmakingEntry>
            </TableRow>

            {data.erp_status !== 'No' || overrideERPCheck ? (
              <>
                <TableRow>
                  <MatchmakingEntry small>Orientation</MatchmakingEntry>
                  <MatchmakingEntry>{overlay.erp_orientation}</MatchmakingEntry>
                </TableRow>
                <TableRow>
                  <MatchmakingEntry small>Position</MatchmakingEntry>
                  <MatchmakingEntry>{overlay.erp_position}</MatchmakingEntry>
                </TableRow>
                <TableRow>
                  <MatchmakingEntry small>Non-Con</MatchmakingEntry>
                  <MatchmakingEntry>
                    <NoticeBox>
                      Remember, non-con should be performed in a private
                      environment, for the OOC comfort of others!
                    </NoticeBox>
                    {overlay.erp_non_con}
                  </MatchmakingEntry>
                </TableRow>
              </>
            ) : (
              <TableRow>
                <MatchmakingEntry>
                  <Button
                    onClick={() => setOverrideERPCheck(true)}
                    content="Show ERP Prefs?"
                  />
                </MatchmakingEntry>
                <MatchmakingEntry />
              </TableRow>
            )}
          </Table>
        </StyleableSection>
        <StyleableSection
          title="General Content"
          textStyle={{ 'color': '#dddddd' }}>
          <Table style={{ 'table-layout': 'fixed' }}>
            <TableRow>
              <MatchmakingEntry small>Can Be Antag Objective</MatchmakingEntry>
              <MatchmakingEntry>{overlay.is_victim}</MatchmakingEntry>
            </TableRow>
            <TableRow>
              <MatchmakingEntry small>Can Be Borged</MatchmakingEntry>
              <MatchmakingEntry>{overlay.borging}</MatchmakingEntry>
            </TableRow>
            <TableRow>
              <MatchmakingEntry small>Can Be Isolated</MatchmakingEntry>
              <MatchmakingEntry>
                <NoticeBox>
                  This is stuff like locker welding, bolting, etc someone with
                  no way to interact with the outside world. See &quot;gay baby
                  jailing&quot; for an example.
                </NoticeBox>
                {overlay.isolation}
              </MatchmakingEntry>
            </TableRow>
            <TableRow>
              <MatchmakingEntry small>Can Be Kidnapped</MatchmakingEntry>
              <MatchmakingEntry>{overlay.kidnapping}</MatchmakingEntry>
            </TableRow>
            <TableRow>
              <MatchmakingEntry small>Can Be Brainwashed</MatchmakingEntry>
              <MatchmakingEntry>{overlay.brainwashing}</MatchmakingEntry>
            </TableRow>
            <TableRow>
              <MatchmakingEntry>
                Can Be Killed For An Objective
              </MatchmakingEntry>
              <MatchmakingEntry>{overlay.death}</MatchmakingEntry>
            </TableRow>
            <TableRow>
              <MatchmakingEntry small>Can Be Round Removed</MatchmakingEntry>
              <MatchmakingEntry>
                <NoticeBox>
                  This means cremating, beheading and hiding the brain, and
                  other such ways of ensuring someone cannot return to the
                  round.
                </NoticeBox>
                {overlay.round_removal}
              </MatchmakingEntry>
            </TableRow>
          </Table>
        </StyleableSection>
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
