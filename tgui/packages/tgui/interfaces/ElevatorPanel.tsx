import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  floors: Floor[];
  is_stopped: BooleanLike;
};

type Floor = {
  id: string;
  name: string;
  is_active: BooleanLike;
};

export const ElevatorPanel = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  return (
    <Window
      title="Elevator Control Panel"
      width={300}
      height={400}
      theme="retro">
      <Window.Content>
        <Section title="Select Floor" textAlign="center">
          <Stack vertical>
            {data.floors.map((entry) => {
              return (
                <Stack.Item grow key={entry.id} mb="4em">
                  <Button
                    content={entry.name}
                    textAlign="center"
                    fontSize="1.2em"
                    fluid={1}
                    lineHeight="3"
                    onClick={() =>
                      act('task', { task: 'click_waypoint', id: entry.id })
                    }
                    color={entry.is_active ? 'green' : null}
                  />
                </Stack.Item>
              );
            })}
            <Stack.Item grow mb="3.4em">
              <Button
                content="STOP"
                fluid={1}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('task', { task: 'click_stop' })}
                color={data.is_stopped ? 'yellow' : 'red'}
                icon={data.is_stopped ? 'square-xmark' : null}
              />
            </Stack.Item>
            <Stack.Item grow mb="3.4em">
              <Button
                content="EMERGENCY REVERSE"
                fluid={1}
                textAlign="center"
                lineHeight="3"
                onClick={() => act('task', { task: 'click_reverse' })}
                color="orange"
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
