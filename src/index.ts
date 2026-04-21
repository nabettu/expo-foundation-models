import NativeModule from "./ExpoFoundationModels";
import { LanguageModelSession } from "./LanguageModelSession";
import type {
  CreateSessionOptions,
  GenerateOptions,
  UnavailabilityReason,
} from "./types";

export { LanguageModelSession };
export type { CreateSessionOptions, GenerateOptions, UnavailabilityReason };

const notLoadedError = () =>
  new Error(
    "ExpoFoundationModels native module is not loaded. Requires iOS 26+ and a native rebuild after install.",
  );

export function isAvailable(): boolean {
  if (!NativeModule) return false;
  return NativeModule.isAvailable();
}

export function unavailabilityReason(): UnavailabilityReason | null {
  if (!NativeModule) return "nativeModuleNotLoaded";
  return NativeModule.unavailabilityReason() as UnavailabilityReason | null;
}

export function generate(
  prompt: string,
  options?: GenerateOptions,
): Promise<string> {
  if (!NativeModule) return Promise.reject(notLoadedError());
  return NativeModule.generate(prompt, options);
}

export async function createSession(
  options?: CreateSessionOptions,
): Promise<LanguageModelSession> {
  if (!NativeModule) throw notLoadedError();
  const sessionId = await NativeModule.createSession(options?.instructions);
  return new LanguageModelSession(sessionId);
}
