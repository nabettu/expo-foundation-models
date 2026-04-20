import { requireNativeModule } from "expo-modules-core";

import type { GenerateOptions } from "./types";

interface NativeModule {
  isAvailable(): boolean;
  generate(prompt: string, options?: GenerateOptions): Promise<string>;
  createSession(instructions?: string): Promise<string>;
  sessionRespond(
    sessionId: string,
    prompt: string,
    options?: GenerateOptions,
  ): Promise<string>;
  releaseSession(sessionId: string): void;
}

export default requireNativeModule<NativeModule>("ExpoFoundationModels");
