import { NtosWindow } from '../layouts';
import { useBackend } from '../backend';
import { Stack, Section, Table, NoticeBox } from '../components';

type Data = {
  name: string;
  owner_token: string;
  money: number;
  transaction_list: Transactions[];
  wanted_token: string;
};

type Transactions = {
  adjusted_money: number;
  reason: string;
};
let name_to_token, money_to_send, token;

export const NtosBanking = (props, context) => {
  return (
    <NtosWindow width={495} height={655}>
      <NtosWindow.Content>
        <NtosBankingContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosBankingContent = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { name } = data;

  if (!name) {
    return (
      <NoticeBox>
        You need to insert your ID card into the card slot in order to use this
        application.
      </NoticeBox>
    );
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Introduction />
      </Stack.Item>
      <Stack.Item grow>
        <TransactionHistory />
      </Stack.Item>
    </Stack>
  );
};

/** Displays the user's name and balance. */
const Introduction = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { name, owner_token, money } = data;
  return (
    <Section textAlign="center">
      <Table>
        <Table.Row>Hi, {name}.</Table.Row>
        <Table.Row>
          Account balance: {money} credit{money === 1 ? '' : 's'}
        </Table.Row>
      </Table>
    </Section>
  );
};

/** Displays the transaction history. */
const TransactionHistory = (props, context) => {
  const { data } = useBackend<Data>(context);
  const { transaction_list = [] } = data;

  return (
    <Section fill title="Transaction History">
      <Section fill scrollable title={<TableHeaders />}>
        <Table>
          {transaction_list.map((log) => (
            <Table.Row
              key={log}
              className="candystripe"
              color={log.adjusted_money < 1 ? 'red' : 'green'}>
              <Table.Cell width="100px">
                {log.adjusted_money > 1 ? '+' : ''}
                {log.adjusted_money}
              </Table.Cell>
              <Table.Cell textAlign="center">{log.reason}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

/** Renders a set of sticky headers */
const TableHeaders = (props, context) => {
  return (
    <Table>
      <Table.Row>
        <Table.Cell color="label" width="100px">
          Amount
        </Table.Cell>
        <Table.Cell color="label" textAlign="center">
          Reason
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
