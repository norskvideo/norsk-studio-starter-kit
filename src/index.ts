import { autoRegisterComponents } from "@norskvideo/norsk-studio/lib/extension/registration"
import path from 'path';

export const registerAll = autoRegisterComponents(__dirname,
  path.join(__dirname, "../static/info.js"),
  (p: string) => p.replace('lib', 'static'));

export default registerAll;
