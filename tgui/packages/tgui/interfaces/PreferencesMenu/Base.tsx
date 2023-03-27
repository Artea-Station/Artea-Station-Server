import { classes } from 'common/react';
import { sendAct, useBackend } from '../../backend';
import { Autofocus, Box, Button, Flex, LabeledList, Popper, Stack, Tooltip, TrackOutsideClicks } from '../../components';
import { PreferencesMenuData } from './data';
import features from './preferences/features';
import { FeatureChoicedServerData, FeatureValueInput } from './preferences/features/base';

const CLOTHING_CELL_SIZE = 48;

const CLOTHING_SELECTION_CELL_SIZE = 48;
const CLOTHING_SELECTION_WIDTH = 5.4;
const CLOTHING_SELECTION_MULTIPLIER = 5.2;

export const ChoicedSelection = (
  props: {
    name: string;
    catalog: FeatureChoicedServerData;
    selected: string;
    supplementalFeature?: string;
    supplementalValue?: unknown;
    onClose: () => void;
    onSelect: (value: string) => void;
  },
  context
) => {
  const { act } = useBackend<PreferencesMenuData>(context);

  const { catalog, supplementalFeature, supplementalValue } = props;

  if (!catalog.icons) {
    return <Box color="red">Provided catalog had no icons!</Box>;
  }

  return (
    <Box
      style={{
        background: 'white',
        padding: '5px',

        height: `${
          CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_MULTIPLIER
        }px`,
        width: `${CLOTHING_SELECTION_CELL_SIZE * CLOTHING_SELECTION_WIDTH}px`,
      }}>
      <Stack vertical fill>
        <Stack.Item>
          <Stack fill>
            {supplementalFeature && (
              <Stack.Item>
                <FeatureValueInput
                  act={act}
                  feature={features[supplementalFeature]}
                  featureId={supplementalFeature}
                  shrink
                  value={supplementalValue}
                />
              </Stack.Item>
            )}

            <Stack.Item grow>
              <Box
                style={{
                  'border-bottom': '1px solid #888',
                  'font-weight': 'bold',
                  'font-size': '14px',
                  'text-align': 'center',
                }}>
                Select {props.name.toLowerCase()}
              </Box>
            </Stack.Item>

            <Stack.Item>
              <Button color="red" onClick={props.onClose}>
                X
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <Stack.Item overflowX="hidden" overflowY="scroll">
          <Autofocus>
            <Flex wrap>
              {Object.entries(catalog.icons).map(([name, image], index) => {
                return (
                  <Flex.Item
                    key={index}
                    basis={`${CLOTHING_SELECTION_CELL_SIZE}px`}
                    style={{
                      padding: '5px',
                    }}>
                    <Button
                      onClick={() => {
                        props.onSelect(name);
                      }}
                      selected={name === props.selected}
                      tooltip={name}
                      tooltipPosition="right"
                      style={{
                        height: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                        width: `${CLOTHING_SELECTION_CELL_SIZE}px`,
                      }}>
                      <Box
                        className={classes([
                          'preferences32x32',
                          image,
                          'centered-image',
                        ])}
                      />
                    </Button>
                  </Flex.Item>
                );
              })}
            </Flex>
          </Autofocus>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

export const MainFeature = (
  props: {
    catalog: FeatureChoicedServerData & {
      name: string;
      supplemental_feature?: string;
    };
    currentValue: string;
    isOpen: boolean;
    handleClose: () => void;
    handleOpen: () => void;
    handleSelect: (newClothing: string) => void;
  },
  context
) => {
  const { act, data } = useBackend<PreferencesMenuData>(context);

  const {
    catalog,
    currentValue,
    isOpen,
    handleOpen,
    handleClose,
    handleSelect,
  } = props;

  const supplementalFeature = catalog.supplemental_feature;

  return (
    <Popper
      options={{
        placement: 'bottom-start',
      }}
      popperContent={
        isOpen && (
          <TrackOutsideClicks onOutsideClick={props.handleClose}>
            <ChoicedSelection
              name={catalog.name}
              catalog={catalog}
              selected={currentValue}
              supplementalFeature={supplementalFeature}
              supplementalValue={
                supplementalFeature &&
                data.character_preferences.supplemental_features[
                  supplementalFeature
                ]
              }
              onClose={handleClose}
              onSelect={handleSelect}
            />
          </TrackOutsideClicks>
        )
      }>
      <Button
        onClick={() => {
          if (isOpen) {
            handleClose();
          } else {
            handleOpen();
          }
        }}
        style={{
          height: `${CLOTHING_CELL_SIZE}px`,
          width: `${CLOTHING_CELL_SIZE}px`,
        }}
        position="relative"
        tooltip={catalog.name}
        tooltipPosition="right">
        <Box
          className={classes([
            'preferences32x32',
            catalog.icons![currentValue],
            'centered-image',
          ])}
          style={{
            transform: 'translateX(-50%) translateY(-50%) scale(1.3)',
          }}
        />
      </Button>
    </Popper>
  );
};

export const PreferenceList = (props: {
  act: typeof sendAct;
  preferences: Record<string, unknown>;
}) => {
  return (
    <Stack.Item
      basis="50%"
      grow
      style={{
        background: 'rgba(0, 0, 0, 0.5)',
        padding: '4px',
      }}
      overflowX="hidden"
      overflowY="scroll">
      <LabeledList>
        {Object.entries(props.preferences).map(([featureId, value]) => {
          const feature = features[featureId];

          if (feature === undefined) {
            return (
              <Stack.Item key={featureId}>
                <b>Feature {featureId} is not recognized.</b>
              </Stack.Item>
            );
          }

          return (
            <LabeledList.Item
              key={featureId}
              label={feature.name}
              verticalAlign="middle">
              {feature.description ? (
                <Tooltip content={<Box>{feature.description}</Box>}>
                  <Stack fill>
                    <Stack.Item grow>
                      <FeatureValueInput
                        act={props.act}
                        feature={feature}
                        featureId={featureId}
                        value={value}
                      />
                    </Stack.Item>
                  </Stack>
                </Tooltip>
              ) : (
                <Stack fill>
                  <Stack.Item grow>
                    <FeatureValueInput
                      act={props.act}
                      feature={feature}
                      featureId={featureId}
                      value={value}
                    />
                  </Stack.Item>
                </Stack>
              )}
            </LabeledList.Item>
          );
        })}
      </LabeledList>
    </Stack.Item>
  );
};
