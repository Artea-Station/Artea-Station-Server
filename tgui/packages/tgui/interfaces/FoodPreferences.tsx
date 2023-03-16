import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Dimmer, Divider, Icon, Section, Stack, StyleableSection, Tooltip } from '../components';
import { Button } from '../components/Button';
import { Window } from '../layouts';

type Data = {
  food_types: Record<string, Record<string, number>>;
  selection: Record<string, number>;
  points: number;
  enabled: BooleanLike;
  invalid: string;
  race_disabled: BooleanLike;
};

const FOOD_TOXIC = 1;
const FOOD_DISLIKED = 2;
const FOOD_NEUTRAL = 3;
const FOOD_LIKED = 4;
const DEFAULT_FOOD_VALUE = 4; // Yes, four, cause byond lists start at 1, while JS starts at 0.
const OBSCURE_FOOD = 5;

export const FoodPreferences = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  return (
    <Window width={850} height={500}>
      <Window.Content scrollable>
        {
          <StyleableSection
            style={{
              'margin-bottom': '1em',
              'break-inside': 'avoid-column',
            }}
            titleStyle={{
              'justify-content': 'center',
            }}
            title={
              <Box>
                <Tooltip
                  position="bottom"
                  content={
                    data.invalid ? (
                      <>
                        Your selected food preferences are invalid!
                        <Divider />
                        {data.invalid.charAt(0).toUpperCase() +
                          data.invalid.slice(1)}
                        !
                      </>
                    ) : (
                      'Your selected food preferences are valid!'
                    )
                  }>
                  <Box inline>
                    {data.invalid && (
                      <Button icon="circle-question" mr="0.5em" />
                    )}
                    <span
                      style={{ 'color': data.invalid ? '#bd2020' : 'inherit' }}>
                      Points left: <AnimatedNumber value={data.points} />
                    </span>
                  </Box>
                </Tooltip>

                <Button
                  style={{ 'position': 'absolute', 'right': '20em' }}
                  color={'red'}
                  onClick={() => act('reset')}
                  tooltip="Reset to the default values!">
                  Reset
                </Button>

                <Button
                  style={{ 'position': 'absolute', 'right': '0.5em' }}
                  icon={data.enabled ? 'check-square-o' : 'square-o'}
                  color={data.enabled ? 'green' : 'red'}
                  onClick={() => act('toggle')}
                  tooltip={
                    <>
                      Toggles if these food preferences will be applied to your
                      character on spawn.
                      <Divider />
                      Remember, these are mostly suggestions, and you are
                      encouraged to roleplay liking meals that your character
                      likes, even if you don&apos;t have it&apos;s food type
                      liked here!
                    </>
                  }>
                  Use Custom Food Preferences
                </Button>
              </Box>
            }>
            {(data.race_disabled && (
              <ErrorOverlay>
                You&apos;re using a race which isn&apos;t affected by food
                preferences!
              </ErrorOverlay>
            )) ||
              (!data.enabled && (
                <ErrorOverlay>Your food preferences are disabled!</ErrorOverlay>
              ))}
            <Box style={{ 'columns': '30em' }}>
              {Object.entries(data.food_types).map((element) => {
                const { 0: foodName, 1: foodPointValues } = element;
                return (
                  <Box key={foodName} wrap="wrap">
                    <Section
                      title={
                        <>
                          {foodName}
                          {foodPointValues[OBSCURE_FOOD] && (
                            <Tooltip content="This food doesn't count towards your maximum likes, and is free!">
                              <span
                                style={{
                                  'margin-left': '0.3em',
                                  'vertical-align': 'top',
                                  'font-size': '0.75em',
                                }}>
                                <Icon
                                  name="star"
                                  style={{ 'color': 'orange' }}
                                />
                              </span>
                            </Tooltip>
                          )}
                        </>
                      }
                      style={{
                        'break-inside': 'avoid-column',
                        'margin-bottom': '1em',
                      }}>
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_TOXIC}
                        selected={
                          data.selection[foodName] === FOOD_TOXIC ||
                          (!data.selection[foodName] &&
                            foodPointValues[DEFAULT_FOOD_VALUE.toString()] ===
                              FOOD_TOXIC)
                        }
                        content={
                          <>
                            Toxic
                            {foodPointValues &&
                              !foodPointValues[OBSCURE_FOOD] &&
                              ' (' + foodPointValues[FOOD_TOXIC - 1] + ')'}
                          </>
                        }
                        color="olive"
                        tooltip="Your character will almost immediately throw up on eating anything toxic."
                      />
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_DISLIKED}
                        selected={
                          data.selection[foodName] === FOOD_DISLIKED ||
                          (!data.selection[foodName] &&
                            foodPointValues[DEFAULT_FOOD_VALUE.toString()] ===
                              FOOD_DISLIKED)
                        }
                        content={
                          <>
                            Disliked
                            {foodPointValues &&
                              !foodPointValues[OBSCURE_FOOD] &&
                              ' (' + foodPointValues[FOOD_DISLIKED - 1] + ')'}
                          </>
                        }
                        color="red"
                        tooltip="Your character will become grossed out, before eventually throwing up after a decent intake of disliked food."
                      />
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_NEUTRAL}
                        selected={
                          data.selection[foodName] === FOOD_NEUTRAL ||
                          (!data.selection[foodName] &&
                            foodPointValues[DEFAULT_FOOD_VALUE.toString()] ===
                              FOOD_NEUTRAL)
                        }
                        content={
                          <>
                            Neutral
                            {foodPointValues &&
                              !foodPointValues[OBSCURE_FOOD] &&
                              ' (' + foodPointValues[FOOD_NEUTRAL - 1] + ')'}
                          </>
                        }
                        color="grey"
                        tooltip="Your character has very little to say about something that's neutral."
                      />
                      <FoodButton
                        foodName={foodName}
                        foodPreference={FOOD_LIKED}
                        selected={
                          data.selection[foodName] === FOOD_LIKED ||
                          (!data.selection[foodName] &&
                            foodPointValues[DEFAULT_FOOD_VALUE.toString()] ===
                              FOOD_LIKED)
                        }
                        content={
                          <>
                            Liked
                            {foodPointValues &&
                              !foodPointValues[OBSCURE_FOOD] &&
                              ' (' + foodPointValues[FOOD_LIKED - 1] + ')'}
                          </>
                        }
                        color="green"
                        tooltip="Your character will enjoy anything that's liked."
                      />
                    </Section>
                  </Box>
                );
              })}
            </Box>
          </StyleableSection>
        }
      </Window.Content>
    </Window>
  );
};

const FoodButton = (props, context) => {
  const { act } = useBackend(context);
  const { foodName, foodPreference, color, selected, ...rest } = props;
  return (
    <Button
      icon={selected ? 'check-square-o' : 'square-o'}
      color={selected ? color : 'grey'}
      onClick={() =>
        act('change_food', {
          food_name: foodName,
          food_preference: foodPreference,
        })
      }
      {...rest}
    />
  );
};

const ErrorOverlay = (props, context) => {
  return (
    <Dimmer style={{ 'align-items': 'stretch' }}>
      {/* prettier-ignore */}
      <Stack vertical mt="5.2em"> {/* Perfectly aligned in some empty space so it's more legible.*/}
        <Stack.Item color="#bd2020" textAlign="center">
          <h1>{props.children}</h1>
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};
