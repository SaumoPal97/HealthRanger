import * as z from 'zod';

import { generate } from '@genkit-ai/ai';
import { configureGenkit } from '@genkit-ai/core';
import { defineFlow, startFlowsServer } from '@genkit-ai/flow';
import { googleAI } from '@genkit-ai/googleai';
import { gemini15Flash } from '@genkit-ai/googleai';

configureGenkit({
  plugins: [
    googleAI(),
  ],
  logLevel: 'debug',
  enableTracingAndMetrics: true,
});


export const callResponseFlow = defineFlow(
  {
    name: 'callResponseFlow',
    inputSchema: z.string(),
    outputSchema: z.string(),
  },
  async (callHistory) => {
    const llmResponse = await generate({
      prompt: `You are a phone call bot responsible for conducting followups for patients. 
      Included below is the details about the patient and the call history between the bot (you) and the patient.
      Do not mention the word bot or make the user feel like he or she is talking to a bot.
      Also no need to have placeholders. Use generic names or no names at all.
      
      Call history: ${callHistory}`,
      model: gemini15Flash,
      config: {
        temperature: 1,
      },
    });
    return llmResponse.text();
  }
);

startFlowsServer();
