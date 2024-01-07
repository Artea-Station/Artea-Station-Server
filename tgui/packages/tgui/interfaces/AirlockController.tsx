import { BooleanLike } from 'common/react';
import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

/**
 * Simple airlock consoles are the least complicated airlock controller.
 * They show the current chamber pressure, two cycle buttons, and two
 * force door buttons. That's it.
 */
export const AirlockController = (props, context) => {
  const { act, data } = useBackend<AirlockControllerData>(context);

  const barValues = {
    'Chamber Pressure': data.chamber_pressure,
    'Exterior Pressure': data.exterior_pressure,
    'Interior Pressure': data.interior_pressure,
  };

  let bars: object[] = [];
  let winHeight = 210;

  Object.entries(barValues).forEach(([entry, value]) => {
    if (value === null || value === undefined) {
      return;
    }
    bars.push({
      minValue: 0,
      maxValue: value < 102 ? 102 : value < 325 ? 325 : 550,
      value: value,
      label: entry,
      textValue: value + ' kPa',
      color: (value) => {
        return value < 80 || value > 550
          ? 'bad'
          : value < 95 || value > 325
            ? 'average'
            : 'good';
      },
    });
    winHeight += 24;
  });

  return (
    <Window width={580} height={winHeight}>
      <Window.Content>
        <StatusDisplay bars={bars} />
        <Section title="Controls">
          <StandardControls />
          <Box>
            <Button
              disabled={
                data.airlock_state !== 'open' && data.airlock_state !== 'closed'
              }
              icon="ban"
              color="bad"
              content="Abort"
              onClick={() => act('abort')}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

/**
 * Used for the upper status display that is used on 90% of these UIs.
 * @param {StatusDisplayProps} props
 */
const StatusDisplay = (props, context) => {
  const { bars } = props;

  return (
    <Section title="Status">
      <LabeledList>
        {bars.map((bar) => (
          <LabeledList.Item key={bar.label} label={bar.label}>
            <ProgressBar
              color={bar.color(bar.value)}
              minValue={bar.minValue}
              maxValue={bar.maxValue}
              value={bar.value}>
              {bar.textValue}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

type AirlockControllerData = {
  airlock_state: string;
  chamber_pressure: number;
  pump_status: string;
  interior_status: string;
  exterior_status: string;
  airlock_disabled: BooleanLike;
  interior_pressure: number;
  exterior_pressure: number;
  processing: BooleanLike;
  is_firelock: BooleanLike;
};

/**
 * This is just a quick helper for most airlock controllers. They usually all
 * have the "Cycle out, cycle in, force out, force in" buttons, so we just have
 * a single component that adjusts for the mild data structure differences
 * on it's own.
 */
export const StandardControls = (props, context) => {
  const { data, act } = useBackend<AirlockControllerData>(context);

  let externalForceSafe = true;
  if (data.processing) {
    externalForceSafe = false;
  } else if (data.exterior_pressure && data.chamber_pressure) {
    externalForceSafe = !(
      Math.abs(data.exterior_pressure - data.chamber_pressure) > 5
    );
  }

  let internalForceSafe = true;
  if (data.processing) {
    internalForceSafe = false;
  } else if (data.interior_pressure && data.chamber_pressure) {
    internalForceSafe = !(
      Math.abs(data.interior_pressure - data.chamber_pressure) > 5
    );
  }

  return (
    <Fragment>
      <Box>
        <Button
          disabled={data.airlock_disabled}
          icon="arrow-left"
          content="Cycle to Exterior"
          onClick={() => act('cycleExterior')}
        />
        <Button
          disabled={data.airlock_disabled}
          icon="arrow-right"
          content="Cycle to Interior"
          onClick={() => act('cycleInterior')}
        />
        <Button
          disabled={data.airlock_disabled}
          icon="door-closed"
          content="Cycle Closed"
          onClick={() => act('cycleClosed')}
        />
        {!!data.is_firelock && (
          <Button
            disabled={data.airlock_disabled}
            icon="door-open"
            content="Cycle Open"
            onClick={() => act('cycleOpen')}
          />
        )}
      </Box>
      <Box>
        <Button.Confirm
          disabled={data.airlock_disabled}
          color={externalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          content="Force Exterior Door"
          onClick={() => act('forceExterior')}
        />
        <Button.Confirm
          disabled={data.airlock_disabled}
          color={internalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          content="Force Interior Door"
          onClick={() => act('forceInterior')}
        />
      </Box>
    </Fragment>
  );
};
