import { BooleanLike } from 'common/react';
import { useBackend, useSharedState } from '../backend';
import { Button, Section, Table, Tabs } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

type Data = {
  status: string;
  timer_str: string;
  shield_status: string;
  comms_status: BooleanLike;
  mic_status: BooleanLike;
  x: number;
  y: number;
  engine_amount: number;
  engines: EngineData[];
  helm_command: number;
  destination_x: number;
  destination_y: number;
  current_speed: number;
  impulse_power: number;
  top_speed: number;
  targets: TargetData[];
  can_target: BooleanLike;
  can_use_engines: BooleanLike;
  can_sense: BooleanLike;
  can_dock: BooleanLike;
  lock: LockData;
  docking: DockingData | string;
};

const STATUS_COLOR_KEYS = {
  'In Transit': 'good',
  'Idle': 'average',
  'Igniting': 'average',
  'Recharging': 'average',
  'Missing': 'bad',
  'Unauthorized Access': 'bad',
  'Locked': 'bad',
};

const ActionButton = (
  props: {
    action: string;
    data?: object | undefined;
    disabled?: boolean;
    children;
  },
  context
) => {
  const { act } = useBackend(context);
  return (
    <Button
      onClick={() => act(props.action, props.data)}
      disabled={props.disabled}>
      {props.children}
    </Button>
  );
};

export const ShuttleOvermapControls = (props, context) => {
  const [tab, setTab] = useSharedState(context, 'tab', 1);
  return (
    <Window width={450} height={550}>
      <Window.Content>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            General
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            Engines
          </Tabs.Tab>

          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            Helm
          </Tabs.Tab>

          <Tabs.Tab selected={tab === 4} onClick={() => setTab(4)}>
            Sensors
          </Tabs.Tab>

          <Tabs.Tab selected={tab === 5} onClick={() => setTab(5)}>
            Target
          </Tabs.Tab>

          <Tabs.Tab selected={tab === 6} onClick={() => setTab(6)}>
            Dock
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <GeneralTab />}
        {tab === 2 && <EnginesTab />}
        {tab === 3 && <HelmTab />}
        {tab === 4 && <SensorsTab />}
        {tab === 5 && <TargetTab />}
        {tab === 6 && <DockingTab />}
        {/* <Section>
          <Box bold fontSize="26px" textAlign="center" fontFamily="monospace">
            {timer_str || '00:00'}
          </Box>
          <Box textAlign="center" fontSize="14px" mb={1}>
            <Box inline bold>
              STATUS:
            </Box>
            <Box inline color={STATUS_COLOR_KEYS[status] || 'bad'} ml={1}>
              {status || 'Not Available'}
            </Box>
          </Box>
          <Section
            title={
              type === 'shuttle' ? 'Shuttle Controls' : 'Base Launch Controls'
            }>
            <Button
              fluid
              content="Turn On All Engines"
              icon="fire"
              textAlign="center"
              onClick={() => act('engines_on')}
            />
          </Section>
        </Section> */}
      </Window.Content>
    </Window>
  );
};

const GeneralTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { shield_status, comms_status, mic_status, x, y } = data;
  return (
    <Section>
      <p>
        Shields:{' '}
        <ActionButton
          action="shields"
          disabled={shield_status === 'Not installed'}>
          {shield_status}
        </ActionButton>
      </p>
      <p>
        Position: X: {x}, Y: {y}
      </p>
      <Button
        fluid
        content="Open Overmap View"
        icon="map"
        textAlign="center"
        onClick={() => act('open_overmap_view')}
      />
      <Button
        fluid
        content="Send a Hail"
        icon="map"
        textAlign="center"
        onClick={() => act('send_hail')}
      />
      <Button
        fluid
        content="Toggle Alerts"
        icon={comms_status === 1 ? 'volume-high' : 'volume-xmark'}
        color={comms_status === 1 ? null : 'red'}
        textAlign="center"
        onClick={() => act('comms')}
      />
      <Button
        fluid
        content="Toggle Microphone"
        icon={mic_status === 1 ? 'microphone' : 'microphone-slash'}
        color={mic_status === 1 ? null : 'red'}
        textAlign="center"
        onClick={() => act('microphone_muted')}
      />
    </Section>
  );
};

type EngineData = {
  id: number;
  name: string;
  efficiency_percent: number;
  fuel_percent: number;
  status: string;
};

const EngineEntry = (props, context) => {
  const { act } = useBackend(context);
  const engine: EngineData = props.engine;

  return (
    <Section title={engine.name}>
      <p>
        Engine {engine.id}: {engine.name}
      </p>
      <p>
        Efficiency:{' '}
        <ActionButton
          action="set_efficiency"
          data={{ engine_index: engine.id }}>
          {engine.efficiency_percent}%
        </ActionButton>
      </p>
      <p>Fuel: {engine.fuel_percent}%</p>
      <p>Status: {engine.status}</p>
    </Section>
  );
};

const EnginesTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { engine_amount, engines } = data;

  if (!data.can_use_engines) {
    return (
      <Section>
        <h2>This structure can&apos;t use engines!</h2>
      </Section>
    );
  }

  return (
    <Section>
      <p>
        <ActionButton action="all_on">All On</ActionButton>
        <ActionButton action="all_off">All Off</ActionButton>
        <ActionButton action="all_efficiency">Set All Efficiency</ActionButton>
      </p>
      <p>Engines: {engine_amount}</p>
      {engines.map((engine) => {
        return <EngineEntry key={engine.name} engine={engine} />;
      })}
    </Section>
  );
};

const HelmTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { helm_command } = data;

  if (!data.can_use_engines) {
    return (
      <Section>
        <h2>This structure can&apos;t use engines!</h2>
      </Section>
    );
  }

  return (
    <Section>
      <p>Current Command: {helm_command}</p>
      <p>
        Position: X: {data.x}, Y: {data.y}
      </p>
      <p>
        Description: X:{' '}
        <ActionButton action="change_x">{data.destination_x}</ActionButton>, Y:{' '}
        <ActionButton action="change_y">{data.destination_y}</ActionButton>
      </p>
      <p>Current Speed: {data.current_speed}</p>
      <p>
        - Impulse Power:{' '}
        <ActionButton action="change_impulse_power">
          {data.impulse_power}%
        </ActionButton>
      </p>
      <p>- Top Speed: {data.top_speed}</p>
      {data.engine_amount < 1 ? (
        <p>No engines installed.</p>
      ) : (
        <>
          <p>Commands:</p>
          {Object.entries({
            // Am I fuck writing each of these.
            command_stop: 'Full Stop',
            command_move_dest: 'Move to Destination',
            command_turn_dest: 'Turn to Destination',
            command_follow_sensor: 'Follow Sensor Lock',
            command_turn_sensor: 'Turn to Sensor Lock',
            command_idle: 'Idle',
          }).map((entry) => (
            <p key={entry[0]}>
              - <ActionButton action={entry[0]}>{entry[1]}</ActionButton>
            </p>
          ))}
          <p>
            <ActionButton action="pad">Pad Control</ActionButton>
          </p>
        </>
      )}
    </Section>
  );
};

type TargetData = {
  id: string;
  name: string;
  x: number;
  y: number;
  distance: number;
  in_lock_range: BooleanLike;
  is_target: BooleanLike;
  is_destination: BooleanLike;
};

const SensorsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { targets } = data;

  if (!data.can_sense) {
    return (
      <Section>
        <h2>This structure can&apos;t use sensors!</h2>
      </Section>
    );
  }

  return (
    <Section>
      <Table align="center" width="100%" height="100%">
        <TableRow style={{ 'vertical-align': 'top' }}>
          <TableCell>Name</TableCell>
          <TableCell>X</TableCell>
          <TableCell>Y</TableCell>
          <TableCell>Distance</TableCell>
          <TableCell>Actions</TableCell>
        </TableRow>
        {targets.map((entry) => (
          <TableRow key={entry.id}>
            <TableCell>{entry.name}</TableCell>
            <TableCell>{entry.x}</TableCell>
            <TableCell>{entry.y}</TableCell>
            <TableCell>{entry.distance}</TableCell>
            <TableCell>
              {data.can_target && (
                <ActionButton
                  action="target"
                  data={{ target_id: entry.id }}
                  disabled={!!entry.is_target}>
                  Target
                </ActionButton>
              )}
              {data.can_use_engines && (
                <ActionButton
                  action="destination"
                  data={{ target_id: entry.id }}
                  disabled={!!entry.is_destination}>
                  Set Destination
                </ActionButton>
              )}
            </TableCell>
          </TableRow>
        ))}
      </Table>
    </Section>
  );
};

type LockData = {
  name: string;
  status: string;
  calibrated: BooleanLike;
  command: string;
};

const TargetTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { lock } = data;

  if (!data.can_target) {
    return (
      <Section>
        <h2>This structure can&apos;t target!</h2>
      </Section>
    );
  }

  if (!lock) {
    return (
      <Section>
        <h2 color="red">No locked target!</h2>
      </Section>
    );
  }

  return (
    <Section>
      <p>Target: {lock.name}</p>
      <p>
        Lock Status: {lock.status}{' '}
        <ActionButton action="disengage_lock">Disengage</ActionButton>
      </p>
      <p>Current Command: {lock.command}</p>
      <p>Commands:</p>
      {Object.entries({
        command_idle: 'Idle',
        command_fire_once: 'Fire Once!',
        command_keep_firing: 'Keep Firing!',
        command_scan: 'Scan',
        command_beam_on_board: 'Beam on Board',
      }).map((entry) => (
        <p key={entry[0]}>
          <ActionButton action={entry[0]} disabled={!lock.calibrated}>
            {entry[1]}
          </ActionButton>
        </p>
      ))}
    </Section>
  );
};

type DockingData = {
  docks: Record<string, string>;
  freeforms: Record<string, string>;
};

const DockingTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { docking } = data;

  if (!data.can_dock) {
    return (
      <Section>
        <h2>This structure can&apos;t dock or land!</h2>
      </Section>
    );
  }

  if (!docking) {
    return (
      <Section>
        <p>Cannot safely dock or land at high velocities!</p>
      </Section>
    );
  }

  if (typeof docking === 'string') {
    return (
      <Section>
        <p>
          This console is unable to access the docking port! Wrong deck or area?
        </p>
      </Section>
    );
  }

  return (
    <Section>
      <p>Designated Docks:</p>
      {Object.entries(docking.docks).map((entry) => (
        <p key={entry[1]}>
          <ActionButton action="normal_dock" data={{ dock_id: entry[1] }}>
            - {entry[0]}
          </ActionButton>
        </p>
      ))}
      <p>Freeform Landing:</p>
      {Object.entries(docking.freeforms).map((entry) => (
        <p key={entry[1]}>
          <ActionButton action="freeform_dock" data={{ z_value: entry[1] }}>
            - {entry[0]}
          </ActionButton>
        </p>
      ))}
    </Section>
  );
};
