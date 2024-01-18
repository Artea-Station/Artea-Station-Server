/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { BooleanLike, classes } from 'common/react';
import { RefObject } from 'inferno';
import { computeFlexClassName, computeFlexItemClassName, computeFlexItemProps, computeFlexProps, FlexItemProps, FlexProps } from './Flex';

type StackProps = FlexProps & {
  vertical?: boolean;
  fill?: boolean;
};

export const Stack = (props: StackProps) => {
  const { className, vertical, fill, ...rest } = props;
  return (
    <div
      className={classes([
        'Stack',
        fill && 'Stack--fill',
        vertical ? 'Stack--vertical' : 'Stack--horizontal',
        className,
        computeFlexClassName(props),
      ])}
      {...computeFlexProps({
        direction: vertical ? 'column' : 'row',
        ...rest,
      })}
    />
  );
};

type StackItemProps = FlexProps & {
  innerRef?: RefObject<HTMLDivElement>;
  alternating?: BooleanLike;
};

const StackItem = (props: StackItemProps) => {
  const { className, innerRef, alternating, ...rest } = props;
  let classesTouse = ['Stack__item', className, computeFlexItemClassName(rest)];

  if (alternating) {
    classesTouse.push('Stack__item__alternating');
  }
  return (
    <div
      className={classes(classesTouse)}
      ref={innerRef}
      {...computeFlexItemProps(rest)}
    />
  );
};

Stack.Item = StackItem;

type StackDividerProps = FlexItemProps & {
  hidden?: boolean;
};

const StackDivider = (props: StackDividerProps) => {
  const { className, hidden, ...rest } = props;
  return (
    <div
      className={classes([
        'Stack__item',
        'Stack__divider',
        hidden && 'Stack__divider--hidden',
        className,
        computeFlexItemClassName(rest),
      ])}
      {...computeFlexItemProps(rest)}
    />
  );
};

Stack.Divider = StackDivider;
