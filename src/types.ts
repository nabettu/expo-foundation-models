export interface GenerateOptions {
  /**
   * System prompt / persona. Applied for one-shot `generate()` calls.
   * For multi-turn sessions, pass `instructions` to `createSession()` instead.
   */
  instructions?: string;

  /** Sampling temperature. Typical range 0.0–2.0. */
  temperature?: number;

  /** Upper bound on tokens generated in the response. */
  maximumResponseTokens?: number;
}

export interface CreateSessionOptions {
  /** System prompt that persists across every turn of this session. */
  instructions?: string;
}

/**
 * Returned by `unavailabilityReason()`:
 * - `null` → available
 * - `"deviceNotEligible"` → hardware lacks Apple Intelligence
 * - `"appleIntelligenceNotEnabled"` → user hasn't enabled Apple Intelligence in Settings
 * - `"modelNotReady"` → model is still downloading / not warmed up
 * - `"osTooOld"` → below iOS 26
 * - `"nativeModuleNotLoaded"` → native module didn't register (wrong platform or not rebuilt)
 * - `"unknown"` → new case not yet mapped
 */
export type UnavailabilityReason =
  | "deviceNotEligible"
  | "appleIntelligenceNotEnabled"
  | "modelNotReady"
  | "osTooOld"
  | "nativeModuleNotLoaded"
  | "unknown";
