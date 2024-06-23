import type { BaseConfig, NodeInfo } from "@norskvideo/norsk-studio/lib/extension/client-types";
import type Registration from "@norskvideo/norsk-studio/lib/extension/registration";

const InitialisedComponents: { [key: string]: NodeInfo<BaseConfig> } = {};
let initialised = false;

const AllComponents: ((r: Registration) => NodeInfo<BaseConfig>)[] = [];

export default function getNodeInfo(r: Registration, type: string) {
  if(!initialised) {
    AllComponents.forEach((f) => {
      const i = f(r);
      InitialisedComponents[i.identifier] = i;
    })
    initialised = true;
  }
  return InitialisedComponents[type];
}

