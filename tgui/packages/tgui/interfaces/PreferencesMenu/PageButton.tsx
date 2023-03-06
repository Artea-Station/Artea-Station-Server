import { InfernoNode } from 'inferno';
import { Button } from '../../components';

export const PageButton = <P extends unknown>(props: {
  currentPage?: P;
  page: P;
  otherActivePages?: P[];

  style?: CSSProperties;
  tooltip?: String;
  tooltipPosition?: String;

  setPage: (page: P) => void;

  children?: InfernoNode;
}) => {
  const pageIsActive =
    props.currentPage === props.page ||
    (props.otherActivePages &&
      props.currentPage &&
      props.otherActivePages.indexOf(props.currentPage) !== -1);

  return (
    <Button
      align="center"
      fontSize="1.2em"
      fluid
      selected={pageIsActive}
      style={props.style}
      tooltip={props.tooltip}
      tooltipPosition={props.tooltipPosition}
      onClick={() => props.setPage(props.page)}>
      {props.children}
    </Button>
  );
};

export const BigPageButton = <P extends unknown>(props: {
  currentPage?: P;
  page: P;
  otherActivePages?: P[];

  style?: CSSProperties;
  tooltip?: String;
  tooltipPosition?: String;

  setPage: (page: P) => void;

  children?: InfernoNode;
}) => {
  return (
    <PageButton
      {...props}
      tooltipPosition={props.tooltipPosition ? props.tooltipPosition : 'right'} // Set to right, cause TGUI's byond frame overlays over everything.
      style={{ 'padding': '20px' }}>
      {props.children}
    </PageButton>
  );
};
