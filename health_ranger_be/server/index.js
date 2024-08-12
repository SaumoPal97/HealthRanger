require("dotenv").config();
const express = require("express");
const urlencoded = require("body-parser").urlencoded;
const { generateAIResponse } = require("./service/gemini.js");
const app = express();
const port = 3000;

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const fromNumber = process.env.TWILIO_FROM_NUMBER;
const toNumber = process.env.TWILIO_TO_NUMBER;

const twilioClient = require("twilio")(accountSid, authToken);
const VoiceResponse = require("twilio").twiml.VoiceResponse;

app.use(urlencoded({ extended: false }));

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/create", async (req, res) => {
  const response = await twilioClient.calls.create({
    to: toNumber,
    from: fromNumber,
    url: "https://ev.ngrok.app/transcribe",
  });
  console.log("res from call creation", response.sid);
  res.send("created call");
});

app.post("/transcribe", (req, res) => {
  res.type("xml");
  const twiml = new VoiceResponse();
  let convo = req.query.convo || "";
  // If no previous conversation is present, start the conversation
  if (!convo) {
    twiml.say(
      {
        voice: "male",
      },
      "Hey! I'm from Malgudi Health Department. I wanted to talk about your current health situation. Last time we talked, you had mumps. How are you feeling now?"
    );
    convo +=
      "Bot: Hey! I'm from Malgudi Health Department. I wanted to talk about your current health situation. Last time we talked, you had mumps. How are you feeling now?";
  }

  // Listen to user response and pass input to /respond
  const params = new URLSearchParams({ convo: convo });
  twiml.gather({
    speechTimeout: "auto",
    speechModel: "phone_call",
    input: "speech",
    langauge: "en-IN",
    action: `/respond?${params}`,
  });

  return res.send(twiml.toString());
});

app.post("/respond", async (req, res) => {
  res.type("xml");
  const twiml = new VoiceResponse();
  let convo = req.query.convo || "";
  const voiceInput = req.body.SpeechResult;
  convo = `${convo}\nYou: ${voiceInput}\nBot:`;

  const aiResponse = await generateAIResponse(convo);
  convo = `${convo}${aiResponse}`;
  twiml.say(
    {
      voice: "male",
    },
    aiResponse
  );

  const params = new URLSearchParams({ convo: convo });
  twiml.redirect(
    {
      method: "POST",
    },
    `/transcribe?${params}`
  );

  return res.send(twiml.toString());
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
