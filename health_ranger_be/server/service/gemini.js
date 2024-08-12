const fetch = require("node-fetch-commonjs");

const presetPrompt = `The following is a conversation with an patient named Sudipto. 
He was diagnosed with mumps a week ago. He stays with his family.
Ask him about his health, whether he is taking his medicines, remind him about his family's appointment for the MMR vaccine
and also explain the benefits of MMR vaccine. Reply in short questions, one at a time.\n\n`;

async function generateAIResponse(convo) {
  const body = {
    data: `Patient details: ${presetPrompt}\n Conversation: ${convo}`,
  };

  const response = await fetch("http://localhost:3400/callResponseFlow", {
    method: "post",
    body: JSON.stringify(body),
    headers: { "Content-Type": "application/json" },
  });

  const data = await response.json();
  console.log(data.result);
  return data.result;
}

module.exports = { generateAIResponse };
