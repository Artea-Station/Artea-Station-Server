import { round } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, ProgressBar, Section, Table } from '../components';
import { Window } from '../layouts';
import { BeakerContents } from './common/BeakerContents';

export const ChemRecipeDebug = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    targetTemp,
    isActive,
    isFlashing,
    currentTemp,
    forceTemp,
    targetVol,
    processing,
    processAll,
    index,
    endIndex,
    beakerSpawn,
    minTemp,
    editRecipeName,
    editRecipeCold,
    editRecipe = [],
    chamberContents = [],
    activeReactions = [],
    queuedReactions = [],
  } = data;
  return (
    <Window width={450} height={850}>
      <Window.Content scrollable>
        <Section
          title="Controls"
          buttons={
            <>
              <Button
                icon={beakerSpawn ? 'power-off' : 'times'}
                selected={beakerSpawn}
                content={'Spawn beaker'}
                onClick={() => act('beakerSpawn')}
              />
              <Button
                icon={processAll ? 'power-off' : 'times'}
                selected={processAll}
                content={'All'}
                onClick={() => act('all')}
              />
            </>
          }>
          <LabeledList>
            <LabeledList.Item label="Reactions">
              <Button icon="plus" onClick={() => act('setTargetList')} />
            </LabeledList.Item>
            <LabeledList.Item label="Queued">
              {(processAll && <Box>All</Box>) || (
                <Box>
                  {queuedReactions.length &&
                    queuedReactions.map((entry) => entry.name + ', ')}
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Temp">
              {currentTemp}K
              <NumberInput
                width="65px"
                unit="K"
                step={10}
                stepPixelSize={3}
                value={round(targetTemp)}
                minValue={0}
                maxValue={1000}
                onDrag={(e, value) =>
                  act('temperature', {
                    target: value,
                  })
                }
              />
              <Button
                icon={forceTemp ? 'power-off' : 'times'}
                selected={forceTemp}
                content={'Force'}
                onClick={() => act('forceTemp')}
              />
              <Button
                icon={minTemp ? 'power-off' : 'times'}
                selected={minTemp}
                content={'MinTemp'}
                onClick={() => act('minTemp')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Vol multi">
              <NumberInput
                width="65px"
                unit="x"
                step={1}
                stepPixelSize={3}
                value={round(targetVol)}
                minValue={1}
                maxValue={200}
                onDrag={(e, value) =>
                  act('vol', {
                    target: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Index">
              {index} of {endIndex}
            </LabeledList.Item>
            <LabeledList.Item label="Start">
              <Button
                icon={processing ? 'power-off' : 'times'}
                selected={!!processing}
                content={'Start'}
                onClick={() => act('start')}
              />
              <Button
                icon={processing ? 'times' : 'power-off'}
                color="red"
                content={'Stop'}
                onClick={() => act('stop')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Recipe edit">
          <LabeledList>
            <LabeledList.Item
              label={editRecipeName ? editRecipeName : 'lookup'}>
              <Button
                icon={'flask'}
                color="purple"
                content={'Select recipe'}
                onClick={() => act('setEdit')}
              />
            </LabeledList.Item>
            {!!editRecipe && (
              <>
                <LabeledList.Item label="is_cold_recipe">
                  <Button
                    icon={editRecipeCold ? 'smile' : 'times'}
                    color={editRecipeCold ? 'green' : 'red'}
                    content={'Cold?'}
                    onClick={() =>
                      act('updateVar', {
                        type: entry.name,
                        target: value,
                      })
                    }
                  />
                </LabeledList.Item>
                {editRecipe.map((entry) => (
                  <LabeledList.Item label={entry.name} key={entry.name}>
                    <NumberInput
                      width="65px"
                      step={1}
                      stepPixelSize={3}
                      value={entry.var}
                      minValue={-9999}
                      maxValue={9999}
                      onDrag={(e, value) =>
                        act('updateVar', {
                          type: entry.name,
                          target: value,
                        })
                      }
                    />
                  </LabeledList.Item>
                ))}
              </>
            )}
            <LabeledList.Item label="Export">
              <Button
                icon={'save'}
                color="green"
                content={'export'}
                onClick={() => act('export')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Reactions">
          {(activeReactions.length === 0 && (
            <Box color="label">No active reactions.</Box>
          )) || (
            <Table>
              <Table.Row>
                <Table.Cell bold color="label">
                  Reaction
                </Table.Cell>
                <Table.Cell bold color="label">
                  Target
                </Table.Cell>
              </Table.Row>
              {activeReactions &&
                activeReactions.map((reaction) => (
                  <Table.Row key="reactions">
                    <Table.Cell width={'60px'} color={reaction.danger && 'red'}>
                      {reaction.name}
                    </Table.Cell>
                    <Table.Cell width={'70px'}>
                      <ProgressBar
                        value={reaction.reactedVol}
                        minValue={0}
                        maxValue={reaction.targetVol}
                        textAlign={'center'}
                        icon={reaction.overheat && 'thermometer-full'}
                        width={7}
                        color={reaction.overheat ? 'red' : 'label'}>
                        {reaction.targetVol}u
                      </ProgressBar>
                    </Table.Cell>
                  </Table.Row>
                ))}
              <Table.Row />
            </Table>
          )}
        </Section>
        <Section
          title="Chamber"
          buttons={<Box>{isActive ? 'Reacting' : 'Waiting'}</Box>}>
          {(chamberContents.length && (
            <BeakerContents beakerLoaded beakerContents={chamberContents} />
          )) || <Box>Nothing</Box>}
        </Section>
      </Window.Content>
    </Window>
  );
};
