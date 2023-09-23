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
  credits: number;
  rank: string;
  wallet_name: string;
  trade_hubs: TradeHub[];
  makes_manifests: BooleanLike;
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
      {!data.pad_linked && (
        <NoticeBox color="bad">
          No pad linked! Make sure it&apos;s next to the console!
        </NoticeBox>
      )}
      {tab === 'comms' && <CommsTab />}
      {tab === 'traders' && !!data.connected_hub && <TradersTab />}
      {tab === 'trade' && !!data.connected_trader && <TradeTab />}
    </Box>
  );
};

const CargoStatus = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { credits, rank, wallet_name } = data;
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Section
      title={
        (wallet_name ? wallet_name : 'Unknown') +
        ' (' +
        (rank ? rank : 'Unknown') +
        ')'
      }
      buttons={
        <Box inline bold>
          <AnimatedNumber
            value={credits ? credits : 0}
            format={(value) => formatMoney(value)}
          />
          {' credits '}
          <Button onClick={() => act('eject_id')} icon="eject" />
        </Box>
      }>
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
      </Tabs>
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
        <ButtonCheckbox
          checked={data.makes_manifests}
          onClick={() => {
            act('toggle_manifest');
          }}>
          Print Manifests
        </ButtonCheckbox>
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
          <Button
            icon="print"
            onClick={() => {
              act('print_manifest');
            }}>
            Print Manifest
          </Button>
          <ButtonCheckbox
            checked={data.makes_manifests}
            onClick={() => {
              act('toggle_manifest');
            }}>
            Log to Manifest
          </ButtonCheckbox>
        </>
      }>
      {!!data.connected_hub?.last_transmission && (
        <NoticeBox>{data.connected_hub?.last_transmission}</NoticeBox>
      )}
      <Stack vertical>
        <Stack.Divider hidden height="1rem" />
        <Stack.Item>
          <Section title="Selling">
            <LabeledList>
              {data.connected_trader.trades.map((trade) => {
                return (
                  <Tooltip content={trade.desc} key={trade.index}>
                    <LabeledList.Item
                      alternating
                      label={
                        <Box width="100%">
                          <Tooltip content="Try and barter for items adding up to an equivalent value. Trader will only accept items they will buy below.">
                            <Button
                              disabled={!trade.amount}
                              icon="arrow-right-arrow-left"
                              onClick={() => {
                                act('barter', { 'index': trade.index });
                              }}
                            />
                          </Tooltip>
                          <Button
                            width="82%"
                            disabled={!trade.amount}
                            icon="cart-shopping"
                            onClick={() => {
                              act('buy', { 'index': trade.index });
                            }}>
                            Buy ({trade.cost}cr)
                          </Button>
                        </Box>
                      }>
                      <Box
                        inline
                        width="100%"
                        style={{ 'text-transform': 'capitalize' }}>
                        {trade.name}
                        <Box style={{ float: 'right' }}>
                          {trade.amount >= 0 && (
                            <Box
                              inline
                              color={trade.amount > 0 ? 'good' : 'bad'}>
                              ({trade.amount} left)
                            </Box>
                          )}
                        </Box>
                      </Box>
                    </LabeledList.Item>
                  </Tooltip>
                );
              })}
            </LabeledList>
          </Section>
        </Stack.Item>
        <Stack.Divider hidden height="1rem" />
        <Stack.Item>
          <Section
            title="Buying"
            buttons={
              <>
                <Button icon="question" onClick={() => act('appraise')}>
                  Get Apprisal
                </Button>
                <Button icon="cart-shopping" onClick={() => act('sell_pad')}>
                  Sell All on Pad
                </Button>
              </>
            }>
            <LabeledList>
              {data.connected_trader.buying.map((trade) => {
                return (
                  <LabeledList.Item
                    alternating
                    key={trade.index}
                    label={
                      <Button
                        width="100%"
                        disabled={trade.amount !== null && !trade.amount}
                        icon="cart-shopping"
                        onClick={() => {
                          act('sell', { 'index': trade.index });
                        }}>
                        Sell ({trade.cost}cr)
                      </Button>
                    }>
                    <Box
                      inline
                      width="100%"
                      style={{ 'text-transform': 'capitalize' }}>
                      {trade.name}
                      <Box style={{ float: 'right' }}>
                        {trade.amount !== null && (
                          <Box inline color={trade.amount > 0 ? 'good' : 'bad'}>
                            ({trade.amount} left)
                          </Box>
                        )}
                      </Box>
                    </Box>
                  </LabeledList.Item>
                );
              })}
            </LabeledList>
          </Section>
        </Stack.Item>
        <Stack.Divider hidden height="1rem" />
        <Stack.Item>
          <Section title="Bounties">
            <LabeledList>
              {data.connected_trader.bounties.map((bounty) => {
                return (
                  <Tooltip content={bounty.desc} key={bounty.index}>
                    <LabeledList.Item
                      alternating
                      label={
                        <Button
                          width="100%"
                          icon="check"
                          onClick={() => {
                            act('bounty', { 'index': bounty.index });
                          }}>
                          Deliver ({bounty.reward}cr)
                        </Button>
                      }>
                      <Box inline style={{ 'text-transform': 'capitalize' }}>
                        {bounty.name}
                      </Box>
                    </LabeledList.Item>
                  </Tooltip>
                );
              })}
            </LabeledList>
          </Section>
        </Stack.Item>
        <Stack.Divider hidden height="1rem" />
        <Stack.Item>
          <Section title="Deliveries">
            <LabeledList>
              {data.connected_trader.deliveries.map((delivery) => {
                return (
                  <Tooltip content={delivery.desc} key={delivery.index}>
                    <LabeledList.Item
                      alternating
                      label={
                        <Button
                          width="100%"
                          icon="check"
                          onClick={() => {
                            act('delivery', { 'index': delivery.index });
                          }}>
                          Accept
                        </Button>
                      }>
                      <Box inline style={{ 'text-transform': 'capitalize' }}>
                        {delivery.name} ({delivery.reward}cr reward)
                      </Box>
                    </LabeledList.Item>
                  </Tooltip>
                );
              })}
            </LabeledList>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
