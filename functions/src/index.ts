import { onRequest } from 'firebase-functions/v2/https';
import { initializeApp } from 'firebase-admin/app';
import { defineSecret } from 'firebase-functions/params';
import OpenAI from 'openai';
import * as cors from 'cors';

initializeApp();

// Declare a secret (no runtime lookup yet!)
const OPENAI_KEY = defineSecret('OPENAI_KEY');

const corsHandler = cors({ origin: true });

export const generateWordCardList = onRequest(
  {
    timeoutSeconds: 60,
    secrets: [OPENAI_KEY],    // << Cloud Functions injects it at runtime
  },
  async (req, res) => {
    // CORS
    corsHandler(req, res, async () => {
      // ------ Validation (trimmed for brevity) -----------------------------
      const { topic, fromLanguage, toLanguage } = req.body ?? {};
      if (!topic || !fromLanguage || !toLanguage) {
        return res.status(400).json({ error: 'topic/fromLanguage/toLanguage required' });
      }

      // ------ Create client *after* secret is available --------------------
      const openai = new OpenAI({ apiKey: OPENAI_KEY.value() });

      try {
        const prompt = `Generate 25 "${topic}" word pairs from "${fromLanguage}" to "${toLanguage}" in pure JSON …`;
        const completion = await openai.chat.completions.create({
          model: 'gpt-4o-mini',
          messages: [
            { role: 'system', content: 'You output JSON only.' },
            { role: 'user', content: prompt },
          ],
          temperature: 0.7,
        });

        const json = JSON.parse(completion.choices[0].message.content ?? '');
        return res.json(json);
      } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'OpenAI call failed' });
      }
    });
  }
);
