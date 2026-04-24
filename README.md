# expo-foundation-models

Expo module wrapping Apple [Foundation Models](https://developer.apple.com/documentation/foundationmodels) (iOS 26+). On-device LLM via `LanguageModelSession` — no network, no API key.

## Requirements

- iOS 26.0 or later (on older iOS, `isAvailable()` returns `false` and calls throw)
- Xcode 26 SDK (Swift 6 compiler) for building
- Expo SDK 54+
- Apple Intelligence–capable device with the feature enabled in Settings

The module uses `#if compiler(>=6.0)` so older Swift compilers still build (APIs become no-ops at runtime). `isAvailable()` reflects `SystemLanguageModel.default.isAvailable` — it is `false` on ineligible hardware, when Apple Intelligence is disabled, or while the model is still downloading.

## Install

```sh
npm install expo-foundation-models
# or
bun add expo-foundation-models
```

Then rebuild the native iOS app:

```sh
npx expo prebuild
npx expo run:ios
```

## Usage

### Availability check

```ts
import { isAvailable, unavailabilityReason } from "expo-foundation-models";

if (!isAvailable()) {
  switch (unavailabilityReason()) {
    case "osTooOld":                   /* iOS < 26 */ break;
    case "deviceNotEligible":          /* hardware lacks Apple Intelligence */ break;
    case "appleIntelligenceNotEnabled":/* ask user to enable in Settings */ break;
    case "modelNotReady":              /* still downloading — retry later */ break;
    case "nativeModuleNotLoaded":      /* wrong platform or not rebuilt */ break;
    case "unknown":                    /* unmapped new case */ break;
  }
}
```

Always wrap calls in `Platform.OS === "ios"` — this module is iOS-only.

### One-shot generation

```ts
import { generate } from "expo-foundation-models";

const answer = await generate("Summarize quantum entanglement in one sentence.");
```

With options:

```ts
const answer = await generate(
  "Translate to Japanese: Hello, world!",
  {
    instructions: "You are a professional translator.",
    temperature: 0.2,
    maximumResponseTokens: 256,
  }
);
```

### Multi-turn session

`LanguageModelSession` preserves conversation history on the native side:

```ts
import { createSession } from "expo-foundation-models";

const session = await createSession({
  instructions: "You are a helpful cooking assistant.",
});

const first = await session.respond("What can I make with eggs and rice?");
const second = await session.respond("Make it spicier."); // remembers context

session.release(); // free native resources when done
```

## API

```ts
function isAvailable(): boolean;

function unavailabilityReason(): UnavailabilityReason | null;

function generate(prompt: string, options?: GenerateOptions): Promise<string>;

function createSession(options?: { instructions?: string }): Promise<LanguageModelSession>;

interface GenerateOptions {
  instructions?: string;         // system prompt (one-shot only)
  temperature?: number;          // 0.0–2.0
  maximumResponseTokens?: number;
}

type UnavailabilityReason =
  | "deviceNotEligible"
  | "appleIntelligenceNotEnabled"
  | "modelNotReady"
  | "osTooOld"
  | "nativeModuleNotLoaded"
  | "unknown";

class LanguageModelSession {
  respond(prompt: string, options?: GenerateOptions): Promise<string>;
  release(): void;
}
```

## Platform notes

- **Android / Web**: not supported. `platforms: ["ios"]` in `expo-module.config.json`. Guard with `Platform.OS`.
- **Old Architecture**: works (`newArchEnabled: false` is fine).
- **Simulator**: Foundation Models runs in the iOS 26 simulator on Apple Silicon Macs.

## Concurrency

The module does not queue calls internally. Compute is serialized by the Neural Engine regardless, so parallel calls don't speed anything up — but each live session holds its own KV cache, so fan-out from a tight loop can pressure memory on lower-end devices (especially with long prompts or multi-turn history). If you call `generate()` or `session.respond()` in a fan-out, rate-limit it yourself (e.g. cap to ~3 concurrent).

## License

MIT © nabettu
