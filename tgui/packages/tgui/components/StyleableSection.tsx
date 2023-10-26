import { SFC } from 'inferno';
import { Box } from './Box';

// The cost of flexibility and prettiness.
export const StyleableSection: SFC<{
  style?;
  titleStyle?;
  textStyle?;
  childStyle?;
  title?;
  titleSubtext?;
  scrollable?;
}> = (props) => {
  return (
    <Box
      style={props.style}
      className={props.scrollable && 'Section--scrollable'}>
      {/* Yes, this box (line above) is missing the "Section" class. This is very intentional, as the layout looks *ugly* with it.*/}
      <Box class="Section__title" style={props.titleStyle}>
        <Box class="Section__titleText" style={props.textStyle}>
          {props.title}
        </Box>
        <div className="Section__buttons">{props.titleSubtext}</div>
      </Box>
      <Box style={props.childStyle} class="Section__rest">
        <Box class="Section__content">{props.children}</Box>
      </Box>
    </Box>
  );
};
