import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Divider, Flex, Icon, Modal, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  status: string;
  locked: BooleanLike;
  authorization_required: BooleanLike;
  timer_str: string;
};

export const ShuttleConsoleOvermap = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { type = 'shuttle', blind_drop } = props;
  const { authorization_required } = data;
  return (
    <Window width={350} height={300}>
      {!!authorization_required && (
        <Modal
          ml={1}
          mt={1}
          width={26}
          height={12}
          fontSize="28px"
          fontFamily="monospace"
          textAlign="center">
          <Flex>
            <Flex.Item mt={2}>
              <Icon name="minus-circle" />
            </Flex.Item>
            <Flex.Item mt={2} ml={2} color="bad">
              {type === 'shuttle' ? 'SHUTTLE LOCKED' : 'BASE LOCKED'}
            </Flex.Item>
          </Flex>
          <Box fontSize="18px" mt={4}>
            <Button
              lineHeight="40px"
              icon="arrow-circle-right"
              content="Request Authorization"
              color="bad"
              onClick={() => act('request')}
            />
          </Box>
        </Modal>
      )}
      <Window.Content>
        <ShuttleConsoleContent type={type} blind_drop={blind_drop} />
      </Window.Content>
    </Window>
  );
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

export const ShuttleConsoleContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { type } = props;
  const { status, locked, authorization_required, timer_str } = data;
  return (
    <Section>
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
          disabled={locked || authorization_required}
          icon="fire"
          textAlign="center"
          onClick={() => act('engines_on')}
        />
        <Button
          fluid
          content="Turn Off All Engines"
          disabled={locked || authorization_required}
          icon="power-off"
          textAlign="center"
          onClick={() => act('engines_off')}
        />
        <Button
          fluid
          content="Depart"
          disabled={status !== 'Idle' || locked || authorization_required}
          icon="arrow-up"
          textAlign="center"
          onClick={() => act('overmap_launch')}
        />
        <Divider />
        <Button
          fluid
          content="View Overmap"
          disabled={locked || authorization_required}
          icon="map"
          textAlign="center"
          onClick={() => act('overmap_view')}
        />
        <Button
          fluid
          content="View Ship Controls"
          disabled={locked || authorization_required}
          icon="gamepad"
          textAlign="center"
          onClick={() => act('overmap_ship_controls')}
        />
      </Section>
    </Section>
  );
};
