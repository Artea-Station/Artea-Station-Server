import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, NoticeBox, Section, Stack, Tabs, Tooltip } from '../components';
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
  connected_trader: Trader;
};

type TradeHub = {
  id: string;
  name: string;
  traders: TraderStub[];
};

type ConnectedTradeHub = TradeHub & {
  last_transmission: string;
};

type TraderStub = {
  id: string;
  name: string;
};

type Trader = TraderStub & {
  trades: Trade[];
  buying: Trade[];
  bounties: Bounty[];
  deliveries: Bounty[];
};

type Trade = {
  index: number;
  name: string;
  desc: string;
  cost: number;
  amount: number;
};

type Bounty = {
  name: string;
  desc: string;
  index: number;
  reward: number;
};

const TraderContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Box>
      <CargoStatus />
      {!!data.connected_hub?.last_transmission && (
        <NoticeBox>{data.connected_hub?.last_transmission}</NoticeBox>
      )}
      <Section fitted>
        <Tabs fill fluid style={{ 'font-size': '1.2rem' }}>
          <Tabs.Tab
            icon="list"
            selected={tab === 'comms'}
            onClick={() => setTab('comms')}>
            Comms
          </Tabs.Tab>
          <Tabs.Tab
            disabled={!data.connected_hub}
            icon="list"
            selected={tab === 'traders'}
            onClick={() => setTab('traders')}>
            Traders
          </Tabs.Tab>
          <Tabs.Tab
            disabled={!data.connected_trader}
            icon="cart-shopping"
            selected={tab === 'trade'}
            onClick={() => setTab('trade')}>
            Trader
          </Tabs.Tab>
          <Tabs.Tab
            icon="book-open"
            selected={tab === 'logs'}
            onClick={() => setTab('logs')}>
            Logs
          </Tabs.Tab>
        </Tabs>
      </Section>
      {tab === 'comms' && <CommsTab />}
      {tab === 'traders' && !!data.connected_hub && <TradersTab />}
      {tab === 'trade' && !!data.connected_trader && <TradeTab />}
      {tab === 'logs' && <LogsTab />}
    </Box>
  );
};

const CargoStatus = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { department, docked, location, credits, can_send, wallet_name } = data;
  return (
    <Section
      title={window.name}
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
              <Section
                title={hub.name}
                buttons={
                  <Button
                    width="20rem"
                    textAlign="center"
                    onClick={() => {
                      act('choose_hub', { id: hub.id });
                      setTab('traders');
                    }}>
                    Connect
                  </Button>
                }
              />
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
            <Section
              title={trader.name}
              key={trader.id}
              buttons={
                <Button
                  width="20rem"
                  textAlign="center"
                  onClick={() => {
                    act('choose_trader', { 'id': trader.id });
                    setTab('trade');
                  }}>
                  Connect
                </Button>
              }
            />
          );
        })}
      </Stack>
    </Section>
  );
};

const TradeTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  return (
    <Section
      title={data.connected_trader.name}
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
        <LabeledList>
          {data.connected_trader.trades.map((trade) => {
            return (
              <Tooltip content={trade.desc} key={trade.index}>
                <LabeledList.Item
                  label={
                    <Button
                      width="100%"
                      disabled={!trade.amount}
                      icon="cart-shopping"
                      onClick={() => {
                        act('buy', { 'index': trade.index });
                      }}>
                      Buy ({trade.cost}cr)
                    </Button>
                  }>
                  <Box inline style={{ 'text-transform': 'capitalize' }}>
                    {trade.name}
                  </Box>
                </LabeledList.Item>
              </Tooltip>
            );
          })}
        </LabeledList>
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
