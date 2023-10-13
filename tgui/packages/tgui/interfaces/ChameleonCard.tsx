import { useBackend } from '../backend';
import { AccessList } from './common/AccessList';
import { Window } from '../layouts';

type Data = {
  accesses: String[];
  selectedList: String[];
  regionAccess: String[];
  regions: String[];
  showBasic;
  ourAccess: String[];
  theftAccess;
};

export const ChameleonCard = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const {
    accesses,
    selectedList,
    regionAccess,
    showBasic,
    ourAccess,
    theftAccess,
  } = data;

  const parsedAccess = accesses.flatMap((region) => {
    const regionName = region;
    const regionAccess = region;
    const parsedRegion = {
      name: regionName,
      accesses: [],
    };
    parsedRegion.accesses = regionAccess.filter((access) => {
      // Snip everything that's part of our regions.
      if (regionAccess.includes(access)) {
        return false;
      }
      // Add anything not part of our regions that's an access
      // Also add any access on the ID card we're stealing from.
      if (ourAccess.includes(access) || theftAccess.includes(access)) {
        return true;
      }
      return false;
    });
    if (parsedRegion.accesses.length) {
      return parsedRegion;
    }
    return [];
  });

  return (
    <Window width={500} height={620}>
      <Window.Content scrollable>
        <AccessList
          accesses={parsedAccess}
          selectedList={selectedList}
          regionAccess={regionAccess}
          accessFlags={accessFlags}
          accessFlagNames={accessFlagNames}
          showBasic={!!showBasic}
          accessMod={(ref, access) =>
            act('mod_access', {
              access_target: ref,
              access: access,
            })
          }
        />
      </Window.Content>
    </Window>
  );
};
