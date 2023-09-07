import { useBackend } from '../../backend';
import { AnimatedNumber, Box, Dimmer, Divider, Icon, NoticeBox, Section, Stack, StyleableSection, Tooltip } from '../../components';
import { Button } from '../../components/Button';
import { PreferencesMenuData } from './data';

const FOOD_TOXIC = 1;
const FOOD_DISLIKED = 2;
const FOOD_NEUTRAL = 3;
const FOOD_LIKED = 4;
const DEFAULT_FOOD_VALUE = 4; // Yes, four, cause byond lists start at 1, while JS starts at 0.
const OBSCURE_FOOD = 5;

export const FoodPage = (props, context) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);
  return (
    <StyleableSection
      style={{
        'margin-bottom': '1em',
        'break-inside': 'avoid-column',
        'height': '100%',
      }}
      titleStyle={{
        'justify-content': 'center',
      }}
      title={
        <Box>
          <Box inline>
            <span
              style={{
                'color': data.food_invalid ? '#bd2020' : 'inherit',
              }}>
              Points left: <AnimatedNumber value={data.food_points} />
            </span>
          </Box>

          <Button
            style={{ 'position': 'absolute', 'right': '20em' }}
            color={'red'}
            onClick={() => act('reset_food')}
            tooltip="Reset to the default values!">
            Reset
          </Button>

          <Button
            style={{ 'position': 'absolute', 'right': '0.5em' }}
            icon={data.food_enabled ? 'check-square-o' : 'square-o'}
            color={data.food_enabled ? 'green' : 'red'}
            onClick={() => act('toggle_food')}
            tooltip={
              <>
                Toggles if these food preferences will be applied to your
                character on spawn.
                <Divider />
                Remember, these are mostly suggestions, and you are encouraged
                to roleplay liking meals that your character likes, even if you
                don&apos;t have it&apos;s food type liked here!
              </>
            }>
            Use Custom Food Preferences
          </Button>
        </Box>
      }>
      {!data.food_enabled && (
        <ErrorOverlay>Your food preferences are disabled!</ErrorOverlay>
      )}
      <Box>
        <NoticeBox>
          You can have up to {data.max_likes} likes, but you require{' '}
          {data.min_dislikes} dislikes and {data.min_toxics} toxic option.
          <br />
          You must also stay within the point limit.
        </NoticeBox>
        {data.food_invalid && (
          <NoticeBox color="red">
            Your selected food preferences are invalid!
            <Divider />
            {data.food_invalid}
          </NoticeBox>
        )}
      </Box>
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
                          <Icon name="star" style={{ 'color': 'orange' }} />
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
                    data.food_selection[foodName] === FOOD_TOXIC ||
                    (!data.food_selection[foodName] &&
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
                    data.food_selection[foodName] === FOOD_DISLIKED ||
                    (!data.food_selection[foodName] &&
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
                    data.food_selection[foodName] === FOOD_NEUTRAL ||
                    (!data.food_selection[foodName] &&
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
                    data.food_selection[foodName] === FOOD_LIKED ||
                    (!data.food_selection[foodName] &&
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
