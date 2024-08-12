"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.callResponseFlow = void 0;
const z = __importStar(require("zod"));
const ai_1 = require("@genkit-ai/ai");
const core_1 = require("@genkit-ai/core");
const flow_1 = require("@genkit-ai/flow");
const googleai_1 = require("@genkit-ai/googleai");
const googleai_2 = require("@genkit-ai/googleai");
(0, core_1.configureGenkit)({
    plugins: [
        (0, googleai_1.googleAI)(),
    ],
    logLevel: 'debug',
    enableTracingAndMetrics: true,
});
exports.callResponseFlow = (0, flow_1.defineFlow)({
    name: 'callResponseFlow',
    inputSchema: z.string(),
    outputSchema: z.string(),
}, async (callHistory) => {
    const llmResponse = await (0, ai_1.generate)({
        prompt: `You are a phone call bot responsible for conducting followups for patients. 
      Included below is the details about the patient and the call history between the bot (you) and the patient.
      Do not mention the word bot or make the user feel like he or she is talking to a bot.
      Also no need to have placeholders. Use generic names or no names at all.
      
      Call history: ${callHistory}`,
        model: googleai_2.gemini15Flash,
        config: {
            temperature: 1,
        },
    });
    return llmResponse.text();
});
(0, flow_1.startFlowsServer)();
//# sourceMappingURL=index.js.map