import ExpoModulesCore
import Foundation

#if compiler(>=6.0)
import FoundationModels
#endif

struct GenerateOptionsRecord: Record {
  @Field var instructions: String?
  @Field var temperature: Double?
  @Field var maximumResponseTokens: Int?
}

public class ExpoFoundationModelsModule: Module {
  // Stored as `Any` so we avoid availability annotations on stored properties.
  // Cast to `LanguageModelSession` inside iOS 26+ guards.
  private var sessions: [String: Any] = [:]
  private let sessionsQueue = DispatchQueue(label: "expo.foundationmodels.sessions")

  public func definition() -> ModuleDefinition {
    Name("ExpoFoundationModels")

    Function("isAvailable") { () -> Bool in
      #if compiler(>=6.0)
      if #available(iOS 26.0, *) {
        return SystemLanguageModel.default.isAvailable
      }
      #endif
      return false
    }

    Function("unavailabilityReason") { () -> String? in
      #if compiler(>=6.0)
      if #available(iOS 26.0, *) {
        return Self.getUnavailabilityReason()
      }
      #endif
      return "osTooOld"
    }

    AsyncFunction("generate") { (prompt: String, options: GenerateOptionsRecord?) -> String in
      #if compiler(>=6.0)
      if #available(iOS 26.0, *) {
        let session: LanguageModelSession
        if let instructions = options?.instructions, !instructions.isEmpty {
          session = LanguageModelSession(instructions: instructions)
        } else {
          session = LanguageModelSession()
        }
        let response = try await session.respond(
          to: prompt,
          options: self.buildGenerationOptions(options)
        )
        return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      #endif
      throw FoundationModelsUnavailableException()
    }

    AsyncFunction("createSession") { (instructions: String?) -> String in
      #if compiler(>=6.0)
      if #available(iOS 26.0, *) {
        let session: LanguageModelSession
        if let instructions, !instructions.isEmpty {
          session = LanguageModelSession(instructions: instructions)
        } else {
          session = LanguageModelSession()
        }
        let id = UUID().uuidString
        self.sessionsQueue.sync { self.sessions[id] = session }
        return id
      }
      #endif
      throw FoundationModelsUnavailableException()
    }

    AsyncFunction("sessionRespond") { (sessionId: String, prompt: String, options: GenerateOptionsRecord?) -> String in
      #if compiler(>=6.0)
      if #available(iOS 26.0, *) {
        let stored: Any? = self.sessionsQueue.sync { self.sessions[sessionId] }
        guard let session = stored as? LanguageModelSession else {
          throw SessionNotFoundException(sessionId)
        }
        let response = try await session.respond(
          to: prompt,
          options: self.buildGenerationOptions(options)
        )
        return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
      }
      #endif
      throw FoundationModelsUnavailableException()
    }

    Function("releaseSession") { (sessionId: String) -> Void in
      self.sessionsQueue.sync { _ = self.sessions.removeValue(forKey: sessionId) }
    }
  }

  #if compiler(>=6.0)
  @available(iOS 26.0, *)
  private static func getUnavailabilityReason() -> String? {
    let model = SystemLanguageModel.default
    if model.isAvailable { return nil }
    switch model.availability {
    case .available:
      return nil
    case .unavailable(.deviceNotEligible):
      return "deviceNotEligible"
    case .unavailable(.appleIntelligenceNotEnabled):
      return "appleIntelligenceNotEnabled"
    case .unavailable(.modelNotReady):
      return "modelNotReady"
    case .unavailable:
      return "unknown"
    }
  }

  @available(iOS 26.0, *)
  private func buildGenerationOptions(_ opts: GenerateOptionsRecord?) -> GenerationOptions {
    GenerationOptions(
      temperature: opts?.temperature,
      maximumResponseTokens: opts?.maximumResponseTokens
    )
  }
  #endif
}

internal class FoundationModelsUnavailableException: Exception {
  override var reason: String {
    "Foundation Models is not available. Call unavailabilityReason() for details."
  }
}

internal class SessionNotFoundException: GenericException<String> {
  override var reason: String {
    "No session found with id: \(param). It may have been released."
  }
}
