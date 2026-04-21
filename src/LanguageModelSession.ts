import NativeModule from "./ExpoFoundationModels";
import type { GenerateOptions } from "./types";

export class LanguageModelSession {
  private released = false;

  constructor(private readonly sessionId: string) {}

  async respond(prompt: string, options?: GenerateOptions): Promise<string> {
    if (this.released) {
      throw new Error("LanguageModelSession has been released.");
    }
    if (!NativeModule) {
      throw new Error("ExpoFoundationModels native module is not loaded.");
    }
    return NativeModule.sessionRespond(this.sessionId, prompt, options);
  }

  release(): void {
    if (this.released) return;
    this.released = true;
    NativeModule?.releaseSession(this.sessionId);
  }
}
