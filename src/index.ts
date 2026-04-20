import NativeModule from "./ExpoFoundationModels";
import { LanguageModelSession } from "./LanguageModelSession";
import type { CreateSessionOptions, GenerateOptions } from "./types";

export { LanguageModelSession };
export type { CreateSessionOptions, GenerateOptions };

export function isAvailable(): boolean {
  return NativeModule.isAvailable();
}

export function generate(
  prompt: string,
  options?: GenerateOptions,
): Promise<string> {
  return NativeModule.generate(prompt, options);
}

export async function createSession(
  options?: CreateSessionOptions,
): Promise<LanguageModelSession> {
  const sessionId = await NativeModule.createSession(options?.instructions);
  return new LanguageModelSession(sessionId);
}
