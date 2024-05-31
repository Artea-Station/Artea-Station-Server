import { sortBy } from 'common/collections';
import { round } from 'common/math';

import { useBackend } from '../backend';
import { ProgressBar, Section, Stack } from '../components';
import { Window } from '../layouts';

export const Restock = (props, context) => {
  return (
    <Window width={575} height={560}>
      <Window.Content scrollable>
        <RestockTracker />
      </Window.Content>
    </Window>
  );
};

type VendingMachine = {
  id: string;
  name: string;
  location: string;
  percentage: number;
};

type Data = {
  vending_list: VendingMachine[];
};

export const RestockTracker = (props, context) => {
  const { data } = useBackend<Data>(context);
  const vending_list = sortBy((vend: VendingMachine) => vend.percentage)(
    data.vending_list ?? []
  );
  return (
    <Section fill title="Vendor Stocking Status">
      <Stack vertical>
        <Stack fill horizontal>
          <Stack.Item bold width="30%">
            Vending Name
          </Stack.Item>
          <Stack.Item bold width="30%">
            Location
          </Stack.Item>
          <Stack.Item bold width="40%">
            Stock %
          </Stack.Item>
        </Stack>
        <hr />
        {vending_list?.map((vend) => (
          <Stack key={vend.id} fill horizontal>
            <Stack.Item wrap width="30%" height="100%">
              {vend.name}
            </Stack.Item>
            <Stack.Item wrap width="30%" height="100%">
              {vend.location}
            </Stack.Item>
            <Stack.Item
              wrap
              width="40%"
              textAlign={
                vend.percentage > 75
                  ? 'left'
                  : vend.percentage > 45
                    ? 'right'
                    : 'center'
              }>
              <ProgressBar
                value={vend.percentage}
                minValue={0}
                maxValue={100}
                ranges={{
                  good: [75, 100],
                  average: [45, 75],
                  bad: [0, 45],
                }}>
                {round(vend.percentage, 0.01)}
              </ProgressBar>
            </Stack.Item>
          </Stack>
        ))}
      </Stack>
    </Section>
  );
};
