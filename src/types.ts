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
