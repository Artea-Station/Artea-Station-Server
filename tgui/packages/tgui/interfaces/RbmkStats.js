import { Chart, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { useBackend } from '../backend';

export const RbmkStats = (props, context) => {
  const { act, data } = useBackend(context);
  const powerData = data.powerData.map((value, i) => [i, value]);
  const psiData = data.psiData.map((value, i) => [i, value]);
  const tempInputData = data.tempInputData.map((value, i) => [i, value]);
  const tempOutputdata = data.tempOutputdata.map((value, i) => [i, value]);
  return (
    <Window resizable theme="ntos" width={350} height={500}>
      <Window.Content>
        <Section title="Legend:">
          Reactor Power:
          <ProgressBar
            value={data.power}
            minValue={0}
            maxValue={100}
            color="average">
            {data.power}%
          </ProgressBar>
          <br />
          Reactor Pressure:
          <ProgressBar
            value={data.psi}
            minValue={0}
            maxValue={2000}
            color="white">
            {data.psi} kpa
          </ProgressBar>
          Coolant Temperature:
          <ProgressBar
            value={data.coolantInput}
            minValue={0}
            maxValue={1227}
            color="blue">
            {data.coolantInput} K
          </ProgressBar>
          Outlet Temperature:
          <ProgressBar
            value={data.coolantOutput}
            minValue={0}
            maxValue={1227}
            color="bad">
            {data.coolantOutput} K
          </ProgressBar>
        </Section>
        <Section title="Generated Power:">{data.generatedPower}</Section>
        <Section fill title="Reactor Statistics:" height="200px">
          <Chart.Line
            fillPositionedParent
            data={powerData}
            rangeX={[0, powerData.length - 1]}
            rangeY={[0, 1500]}
            strokeColor="rgba(255, 215,0, 1)"
            fillColor="rgba(255, 215, 0, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={psiData}
            rangeX={[0, psiData.length - 1]}
            rangeY={[0, 1500]}
            strokeColor="rgba(255,250,250, 1)"
            fillColor="rgba(255,250,250, 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={tempInputData}
            rangeX={[0, tempInputData.length - 1]}
            rangeY={[0, 1227]}
            strokeColor="rgba(127, 179, 255 , 1)"
            fillColor="rgba(127, 179, 255 , 0.1)"
          />
          <Chart.Line
            fillPositionedParent
            data={tempOutputdata}
            rangeX={[0, tempOutputdata.length - 1]}
            rangeY={[0, 1227]}
            strokeColor="rgba(255, 0, 0 , 1)"
            fillColor="rgba(255, 0, 0 , 0.1)"
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
