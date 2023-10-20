import { NtosWindow } from '../layouts';
import { useBackend } from '../backend';
import { Box } from '../components';

type Data = {
  static_map_icon: string;
  static_map_areas: string;
  static_map_background: string;
  static_pos_to_area_name: Map<string, string> | string; // Constructed like {"x:y" = "Area Name"}
  static_overlays: Map<string, Map<string, Map<string, string>>>; // Constructed like {"Obj Name" = {"icon" = icon, "markers" = ["x, y"]}}
  pos_x: number;
  pos_y: number;
};

export const NtosHolomap = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    static_map_icon,
    static_map_areas,
    static_map_background,
    static_pos_to_area_name,
    static_overlays,
  } = data;
  const scaleStep = 256;
  const scaleEvent = (event, out = false) => {
    event.preventDefault();
    let src = document.getElementById('HolomapImages');
    if (!src) {
      return;
    }
    const originalHeight = Number(
      src.style.height.substring(0, src.style.height.length - 2)
    );

    if (out) {
      const scaleStepModded = scaleStep * (originalHeight / scaleStep);
      if (scaleStepModded >= 4096) {
        return;
      }
      src.style.height = originalHeight + scaleStepModded + 'px';
      src.style.width = originalHeight + scaleStepModded + 'px';
      src.style.left =
        Number(src.style.left.substring(0, src.style.left.length - 2)) -
        scaleStepModded / 2 +
        'px';
      src.style.top =
        Number(src.style.top.substring(0, src.style.top.length - 2)) -
        scaleStepModded / 2 +
        'px';
    } else {
      const scaleStepModded = scaleStep * (originalHeight / (scaleStep * 2));
      if (scaleStepModded <= 256) {
        return;
      }
      src.style.height = originalHeight - scaleStepModded + 'px';
      src.style.width = originalHeight - scaleStepModded + 'px';
      src.style.left =
        Number(src.style.left.substring(0, src.style.left.length - 2)) +
        scaleStepModded / 2 +
        'px';
      src.style.top =
        Number(src.style.top.substring(0, src.style.top.length - 2)) +
        scaleStepModded / 2 +
        'px';
    }
  };

  return (
    <NtosWindow width={512} height={600}>
      <NtosWindow.Content>
        {(typeof static_pos_to_area_name === 'string' && (
          <h1>{static_pos_to_area_name}</h1>
        )) || (
          <Box height="100%" width="100%" overflow="hidden">
            <img
              src={'data:image/png;base64,' + static_map_background}
              height="120%"
              width="auto"
              style={{
                '-ms-interpolation-mode': 'nearest-neighbor',
                'position': 'absolute',
                'left': '-10%',
                'top': '-10%',
              }}
              onClick={(e) => {
                scaleEvent(e, true);
              }}
              onContextMenu={(e) => {
                scaleEvent(e);
              }}
            />
            <div
              id="HolomapImages"
              style={{
                'position': 'absolute',
                'left': '0px',
                'top': '0px',
                'height': '512px',
                'width': '512px',
              }}>
              <img
                src={'data:image/png;base64,' + static_map_icon}
                style={{
                  '-ms-interpolation-mode': 'nearest-neighbor',
                  'position': 'absolute',
                  'height': '100%',
                  'width': '100%',
                  'top': '0%',
                }}
              />
              <img
                src={'data:image/png;base64,' + static_map_areas}
                style={{
                  '-ms-interpolation-mode': 'nearest-neighbor',
                  'position': 'absolute',
                  'top': '0%',
                  'height': '100%',
                  'width': '100%',
                }}
                onClick={(e) => {
                  scaleEvent(e, true);
                }}
                onContextMenu={(e) => {
                  scaleEvent(e);
                }}
              />
              {/* This can't possibly lag more than the research console, right? */}
              {Object.entries(data.static_pos_to_area_name).map(
                ([pos, name], _) => {
                  return (
                    <div
                      style={{
                        'position': 'absolute',
                        'left': Number(pos.split(',')[0]) * 0.2075 + '%',
                        'bottom': Number(pos.split(',')[1]) * 0.2075 + '%',
                        'width': '0.21%',
                        'height': '0.21%',
                      }}
                      onMouseEnter={() => {
                        const mouseTip = document.getElementById('MouseTip');
                        if (mouseTip) {
                          mouseTip.innerText = name;
                        }
                      }}
                      onClick={(e) => {
                        scaleEvent(e, true);
                      }}
                      onContextMenu={(e) => {
                        e.preventDefault();
                        scaleEvent(e);
                      }}
                    />
                  );
                }
              )}

              {/* Why do I need  to offset this differently from the tooltip catchers? */}
              {Object.entries(static_overlays).map(([name, data]) => {
                return data['markers'].map((pos) => {
                  return (
                    <div
                      className="NtosHolomapBlinkingMarker"
                      style={{
                        'position': 'absolute',
                        'left': Number(pos.split(',')[0]) * 0.2075 + '%',
                        'bottom': Number(pos.split(',')[1]) * 0.2075 + '%',
                        'width': '0.21%',
                        'height': '0.21%',
                        'background-color': data['color'],
                      }}
                      onMouseEnter={() => {
                        const mouseTip = document.getElementById('MouseTip');
                        if (mouseTip) {
                          mouseTip.innerText = name;
                        }
                      }}
                      onClick={(e) => {
                        scaleEvent(e, true);
                      }}
                      onContextMenu={(e) => {
                        e.preventDefault();
                        scaleEvent(e);
                      }}
                    />
                  );
                });
              })}
              <div
                className="NtosHolomapBlinkingMarker"
                style={{
                  'position': 'absolute',
                  'left': (data.pos_x + 112) * 0.2075 + '%',
                  'bottom': (data.pos_y + 112) * 0.2075 + '%',
                  'width': '0.21%',
                  'height': '0.21%',
                  'background-color': 'red',
                }}
                onMouseEnter={() => {
                  const mouseTip = document.getElementById('MouseTip');
                  if (mouseTip) {
                    mouseTip.innerText = 'You Are Here';
                  }
                }}
                onClick={(e) => {
                  scaleEvent(e, true);
                }}
                onContextMenu={(e) => {
                  e.preventDefault();
                  scaleEvent(e);
                }}
              />
            </div>
            {/* Placed here cause otherwise it renders under the image. */}
            <h1
              style={{
                'position': 'absolute',
                'background-color': 'rgba(0, 0, 0, 0.8)',
                'padding-left': '0.5em',
                'padding-right': '0.5em',
              }}
              id="MouseTip">
              Unknown
            </h1>
            <h3
              style={{
                'position': 'absolute',
                'background-color': 'rgba(0, 0, 0, 0.8)',
                'padding-left': '0.5em',
                'padding-right': '0.5em',
                'left': '0',
                'bottom': '0',
              }}>
              Left Click: Zoom In
            </h3>
            <h3
              style={{
                'position': 'absolute',
                'background-color': 'rgba(0, 0, 0, 0.8)',
                'padding-left': '0.5em',
                'padding-right': '0.5em',
                'right': '0',
                'bottom': '0',
              }}>
              Right Click: Zoom Out
            </h3>
          </Box>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
