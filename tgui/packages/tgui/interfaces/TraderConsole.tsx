import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, Section, Stack, Tabs } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';
import { BooleanLike } from 'common/react';
import { ButtonCheckbox } from '../components/Button';

export const TraderConsole = (props, context) => {
  return (
    <Window width={780} height={750}>
      <Window.Content scrollable>
        <TraderContent />
      </Window.Content>
    </Window>
  );
};

type Data = {
  requestonly: BooleanLike;
  cart: Trade[];
  requests: Trade[];
  department: string;
  grocery: BooleanLike;
  away: BooleanLike;
  docked: BooleanLike;
  loan: BooleanLike;
  loan_dispatched: BooleanLike;
  location: string;
  message: string;
  credits: number;
  can_send: BooleanLike;
  self_paid: BooleanLike;
  app_cost: number;
  can_approve_requests: BooleanLike;
  wallet_name: string;
  trade_hubs: TradeHub[];
  makes_manifests: BooleanLike;
  makes_log: BooleanLike;
  trade_log?: string[];
  pad_linked: BooleanLike;
  connected_hub: ConnectedTradeHub;
};

type TradeHub = {
  id: string;
  name: string;
  traders: Trader[];
};

type ConnectedTradeHub = TradeHub & {
  last_transmission: string;
};

type Trader = {
  id: string;
  name: string;
  trades: Trade[];
};

type Trade = {
  index: string;
  name: string;
  desc: string;
  small_item: string;
  access: string;
  object: string;
  reason: string;
  orderer: string;
  cost: number;
  paid: BooleanLike;
  dep_order: BooleanLike;
  unorderable?: string;
};

const TraderContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Box>
      <CargoStatus />
      <Section fitted>
        <Tabs>
          <Tabs.Tab
            icon="list"
            selected={tab === 'comms'}
            onClick={() => setTab('comms')}>
            Comms
          </Tabs.Tab>
          <Tabs.Tab
            icon="cart-shopping"
            selected={tab === 'traders'}
            onClick={() => setTab('traders')}>
            Trade
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            selected={tab === 'logs'}
            onClick={() => setTab('logs')}>
            Logs
          </Tabs.Tab>
        </Tabs>
      </Section>
      {tab === 'comms' && <CommsTab />}
      {tab === 'traders' && <TradersTab />}
      {tab === 'logs' && <LogsTab />}
    </Box>
  );
};

const CargoStatus = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { department, docked, location, credits, can_send, wallet_name } = data;
  return (
    <Section
      title={department}
      buttons={
        <Box inline bold>
          <AnimatedNumber
            value={credits}
            format={(value) => formatMoney(value)}
          />
          {' credits (' + wallet_name + ')'}
        </Box>
      }>
      <LabeledList>
        <LabeledList.Item label="Shuttle">
          {(docked && can_send && (
            <Button
              color="green"
              content={location}
              tooltipPosition="right"
              onClick={() => act('send')}
            />
          )) ||
            location}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const CommsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Section title="Available Hubs">
      <Stack vertical>
        <Stack.Divider hidden height="1rem" />
        {data.trade_hubs.map((hub) => {
          return (
            <Stack.Item key={hub.id}>
              <Section title={hub.name}>
                <Stack>
                  <Stack.Item>
                    <Button
                      onClick={() => {
                        act('choose_hub', { id: hub.id });
                        setTab('traders');
                      }}>
                      Pick Hub
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
};

const TradersTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Section
      title="Available Traders"
      buttons={
        <>
          <ButtonCheckbox
            checked={data.makes_manifests}
            onClick={() => {
              act('toggle_manifest');
            }}>
            Print Manifests
          </ButtonCheckbox>
          <ButtonCheckbox
            checked={data.makes_log}
            onClick={() => {
              act('toggle_log');
            }}>
            Log Transactions
          </ButtonCheckbox>
        </>
      }>
      <Stack vertical>
        <Stack.Divider hidden height="1rem" />
        {data.connected_hub.traders.map((trader) => {
          return (
            <Section title={trader.name} key={trader.id}>
              <Stack vertical>
                {trader.trades.map((trade) => {
                  return (
                    <Stack.Item key={trade.index}>
                      <Button
                        autocapitalize="words"
                        disabled={!!trade.unorderable}
                        icon="cart-shopping"
                        onClick={() => {
                          act('buy', { 'index': trade.index });
                        }}>
                        Buy ({trade.cost}cr)
                      </Button>{' '}
                      {trade.name}
                    </Stack.Item>
                  );
                })}
              </Stack>
            </Section>
          );
        })}
      </Stack>
    </Section>
  );
};

const LogsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Box height="50rem">
      <Section id="trade_log_scrollable" title="Logs" scrollable fitted fill>
        <Stack vertical>
          <Stack.Divider hidden height="1rem" />
          {data.trade_log?.reverse().map((entry) => {
            return <Stack.Item key={entry}>{entry}</Stack.Item>;
          })}
        </Stack>
      </Section>
    </Box>
  );
};
