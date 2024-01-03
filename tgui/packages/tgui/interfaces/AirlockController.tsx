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

  const bars = [
    {
      minValue: 0,
      maxValue:
        data.chamberPressure < 102
          ? 102
          : data.chamberPressure < 325
            ? 325
            : 550,
      value: data.chamberPressure,
      label: 'Chamber Pressure',
      textValue: data.chamberPressure + ' kPa',
      color: (value) => {
        return value < 80 || value > 550
          ? 'bad'
          : value < 95 || value > 325
            ? 'average'
            : 'good';
      },
    },
  ];

  return (
    <Window width={580} height={190}>
      <Window.Content>
        <StatusDisplay bars={bars} />
        <Section title="Controls">
          <StandardControls />
          <Box>
            <Button
              disabled={
                data.airlockState !== 'open' && data.airlockState !== 'closed'
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
  airlockState: string;
  chamberPressure: number;
  pumpStatus: string;
  interiorStatus: string;
  exteriorStatus: string;
  airlockDisabled: BooleanLike;
  externalPressure: number;
  internalPressure: number;
  processing: BooleanLike;
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
  } else if (data.externalPressure && data.chamberPressure) {
    externalForceSafe = !(
      Math.abs(data.externalPressure - data.chamberPressure) > 5
    );
  }

  let internalForceSafe = true;
  if (data.processing) {
    internalForceSafe = false;
  } else if (data.internalPressure && data.chamberPressure) {
    internalForceSafe = !(
      Math.abs(data.internalPressure - data.chamberPressure) > 5
    );
  }

  return (
    <Fragment>
      <Box>
        <Button
          disabled={data.airlockDisabled}
          icon="arrow-left"
          content="Cycle to Exterior"
          onClick={() => act('cycleExterior')}
        />
        <Button
          disabled={data.airlockDisabled}
          icon="arrow-right"
          content="Cycle to Interior"
          onClick={() => act('cycleInterior')}
        />
      </Box>
      <Box>
        <Button.Confirm
          disabled={data.airlockDisabled}
          color={externalForceSafe ? '' : 'bad'}
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          content="Force Exterior Door"
          onClick={() => act('forceExterior')}
        />
        <Button.Confirm
          disabled={data.airlockDisabled}
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
