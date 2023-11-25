import { useBackend, useLocalState, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, Divider, Icon, LabeledList, NoticeBox, Section, Stack, Tabs, Tooltip } from '../components';
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

  shuttle_blockaded: BooleanLike;
  shuttle_location: string;
  shuttle_away: BooleanLike;
  shuttle_docked: BooleanLike;
  shuttle_loanable: BooleanLike;
  shuttle_loan_dispatched: BooleanLike;
  shuttle_eta: string;
  grocery_amount: number;

  cart: Order[];
  static_galactic_imports: ImportCategory[];
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
  bounties: Bounty[];
  deliveries: Bounty[];
  color: string;
};

type Trade = {
  id: number;
  name: string;
  desc: string;
  cost: number;
  amount: number;
  access_desc: string;
};

type Order = Trade & {
  orderer: string;
};

type Bounty = {
  name: string;
  desc: string;
  index: number;
  reward: number;
};

type ImportCategory = {
  name: string;
  packs: Trade[];
};

const TraderContent = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Box>
      <CargoStatus />
      {!!data.shuttle_blockaded && (
        <NoticeBox color="bad">
          The shuttle is currently unable to depart for one of the following
          reasons: Bad weather, enemy activity, excessive damage, a broken
          economy with spiralling debt that is crashing every bank in the
          galaxy, poor quality fuel, and other, potentially unrelated reasons.
          Please do not panic.
        </NoticeBox>
      )}
      {tab === 'comms' && <CommsTab />}
      {tab === 'trade' && !!data.connected_trader && <TradeTab />}
      {tab === 'imports' && <ImportsTab />}
      {tab === 'cart' && <CartTab />}
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
      <Stack vertical mb="0.6em">
        <Stack.Item>
          <Stack>
            <Stack.Item>Shuttle Status:</Stack.Item>
            <Stack.Item>
              {data.shuttle_loan_dispatched ? (
                <Box color="average">On Loan</Box>
              ) : data.shuttle_away ? (
                <Box color="average">Away (ETA {data.shuttle_eta})</Box>
              ) : data.shuttle_docked ? (
                <Box color="good">Docked</Box>
              ) : (
                <Box color="bad">Unknown</Box>
              )}
            </Stack.Item>
            <Stack.Item ml="auto">
              <b>Produce Orders: {data.grocery_amount}</b>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button
                onClick={() => act('send_shuttle')}
                disabled={!data.shuttle_docked || data.shuttle_away}>
                Send Shuttle
              </Button>
            </Stack.Item>
            {!!data.shuttle_docked &&
              !data.shuttle_away &&
              !!data.shuttle_loanable && (
                <Stack.Item>
                  <Button color="bad" onClick={() => act('loan_shuttle')}>
                    Loan Shuttle
                  </Button>
                </Stack.Item>
              )}
            <Stack.Item ml="auto">
              <Button onClick={() => act('unload_coupons')} icon="eject">
                Eject Coupons
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      <Tabs fill fluid style={{ 'font-size': '1.2rem' }}>
        <Tabs.Tab
          icon="radio"
          selected={tab === 'comms'}
          onClick={() => setTab('comms')}>
          Comms
        </Tabs.Tab>
        <Tabs.Tab
          disabled={!data.connected_trader}
          icon="dollar"
          selected={tab === 'trade'}
          onClick={() => data.connected_trader && setTab('trade')}>
          Trader
        </Tabs.Tab>
        <Tabs.Tab
          icon="download"
          selected={tab === 'imports'}
          onClick={() => setTab('imports')}>
          Galactic Imports
        </Tabs.Tab>
        <Tabs.Tab
          icon="cart-shopping"
          selected={tab === 'cart'}
          onClick={() => setTab('cart')}>
          Cart
        </Tabs.Tab>
      </Tabs>
    </Section>
  );
};

const CommsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'comms');
  return (
    <Section
      title="Available Hubs"
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
        {data.trade_hubs.map((hub) => {
          return (
            <Stack.Item key={hub.id}>
              <Section
                title={hub.name}
                buttons={
                  hub.id === data.connected_hub?.id ? (
                    <Button
                      width="20rem"
                      textAlign="center"
                      color="bad"
                      onClick={() => {
                        act('disconnect_hub');
                      }}>
                      Disconnect
                    </Button>
                  ) : (
                    <Button
                      width="20rem"
                      textAlign="center"
                      onClick={() => {
                        act('choose_hub', { id: hub.id });
                      }}>
                      Connect
                    </Button>
                  )
                }>
                {data.connected_hub?.id === hub.id && (
                  <Section title="Available Traders">
                    <Stack.Divider hidden height="1rem" />
                    {data.connected_hub.traders.map((trader) => {
                      return (
                        <Button
                          key={trader.id}
                          compact
                          width="20rem"
                          textAlign="center"
                          onClick={() => {
                            act('choose_trader', { 'id': trader.id });
                            setTab('trade');
                          }}>
                          {trader.name}
                        </Button>
                      );
                    })}
                  </Section>
                )}
              </Section>
            </Stack.Item>
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
      scrollable
      fill
      height="560px"
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
        <Box style={{ 'color': data.connected_trader.color }}>
          <span style={{ 'font-size': '2em' }}>
            <Icon name="satellite-dish" />
          </span>{' '}
          {data.connected_hub?.last_transmission}
        </Box>
      )}
      <Stack vertical>
        <Stack.Divider hidden height="1rem" />
        <Stack.Item>
          <Section title="Selling">
            <LabeledList>
              {data.connected_trader.trades.map((trade) => {
                return (
                  <Tooltip
                    content={
                      <>
                        {trade.desc}
                        {trade.access_desc && (
                          <>
                            <Divider />
                            {trade.access_desc}
                          </>
                        )}
                      </>
                    }
                    key={trade.id}>
                    <LabeledList.Item
                      alternating
                      label={
                        <Button
                          fluid
                          disabled={!trade.amount}
                          icon="cart-shopping"
                          onClick={() => {
                            act('buy', { 'id': trade.id });
                          }}>
                          Buy ({trade.cost}cr)
                        </Button>
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

const ImportsTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [currentImportsCat, setImportsCat] = useLocalState(
    context,
    'trade_imports_cat',
    ''
  );

  return (
    <Section title="Galactic Imports">
      {Object.entries(data.static_galactic_imports).map(([_, category]) => {
        return (
          <LabeledList key={category.name}>
            <h3>
              <Button
                icon={
                  currentImportsCat === category.name
                    ? 'chevron-down'
                    : 'chevron-right'
                }
                fluid
                onClick={() => {
                  currentImportsCat === category.name
                    ? setImportsCat('')
                    : setImportsCat(category.name);
                }}>
                {category.name}
              </Button>
            </h3>
            {currentImportsCat === category.name && (
              <Stack vertical mb="1em">
                {category.packs.map((trade) => {
                  return (
                    <Tooltip
                      content={
                        <>
                          {trade.desc}
                          {trade.access_desc && (
                            <>
                              <Divider />
                              {trade.access_desc}
                            </>
                          )}
                        </>
                      }
                      key={trade.id}>
                      <LabeledList.Item
                        alternating
                        label={
                          <Button
                            fluid
                            icon="cart-shopping"
                            onClick={() => {
                              act('buy', { 'id': trade.id });
                            }}>
                            Buy ({trade.cost}cr)
                          </Button>
                        }>
                        <Box
                          inline
                          width="100%"
                          style={{ 'text-transform': 'capitalize' }}>
                          {trade.name}
                        </Box>
                      </LabeledList.Item>
                    </Tooltip>
                  );
                })}
              </Stack>
            )}
          </LabeledList>
        );
      })}
    </Section>
  );
};

const CartTab = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  return (
    <Section
      title={
        <>
          Cart
          <Box inline style={{ 'float': 'right' }} mr="10em">
            Orderer:
          </Box>
        </>
      }>
      <LabeledList>
        {data.cart.map((order) => {
          return (
            <Tooltip content={order.desc} key={order.id}>
              <LabeledList.Item
                alternating
                label={
                  <Button
                    color="bad"
                    icon="x"
                    onClick={() => {
                      act('remove', { 'id': order.id });
                    }}
                  />
                }>
                <Box inline width="100%">
                  (
                  <Box inline color="grey">
                    {order.cost}cr
                  </Box>
                  ){' '}
                  <Box inline style={{ 'text-transform': 'capitalize' }}>
                    {order.name}
                  </Box>
                  <Box inline style={{ 'float': 'right' }}>
                    {order.orderer}
                  </Box>
                </Box>
              </LabeledList.Item>
            </Tooltip>
          );
        })}
      </LabeledList>
    </Section>
  );
};
