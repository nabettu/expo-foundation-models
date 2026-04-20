# expo-foundation-models

Expo module wrapping Apple [Foundation Models](https://developer.apple.com/documentation/foundationmodels) (iOS 26+). On-device LLM via `LanguageModelSession` — no network, no API key.

## Requirements

- iOS 26.0 or later (on older iOS, `isAvailable()` returns `false` and calls throw)
- Xcode 26 SDK for building
- Expo SDK 54+
- Apple Intelligence–capable device for runtime

The module uses `#if canImport(FoundationModels)` so older Xcode versions still compile (all APIs become no-ops at runtime).

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
import { isAvailable } from "expo-foundation-models";

if (!isAvailable()) {
  // Fallback path (older iOS, non-AI device, etc.)
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

function generate(prompt: string, options?: GenerateOptions): Promise<string>;

function createSession(options?: { instructions?: string }): Promise<LanguageModelSession>;

interface GenerateOptions {
  instructions?: string;         // system prompt (one-shot only)
  temperature?: number;          // 0.0–2.0
  maximumResponseTokens?: number;
}

class LanguageModelSession {
  respond(prompt: string, options?: GenerateOptions): Promise<string>;
  release(): void;
}
```

## Platform notes

- **Android / Web**: not supported. `platforms: ["ios"]` in `expo-module.config.json`. Guard with `Platform.OS`.
- **Old Architecture**: works (`newArchEnabled: false` is fine).
- **Simulator**: Foundation Models runs in the iOS 26 simulator on Apple Silicon Macs.

## License

MIT © nabettu
