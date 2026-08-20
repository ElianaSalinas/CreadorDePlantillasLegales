import express from "express";
import path from "path";
import { createServer as createViteServer } from "vite";
import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = 3000;

app.use(express.json({ limit: "25mb" }));

// Server-side Gemini AI integration
let aiClient: GoogleGenAI | null = null;
function getGenAI(): GoogleGenAI | null {
  if (!aiClient && process.env.GEMINI_API_KEY) {
    aiClient = new GoogleGenAI({
      apiKey: process.env.GEMINI_API_KEY,
      httpOptions: {
        headers: {
          "User-Agent": "aistudio-build",
        },
      },
    });
  }
  return aiClient;
}

// Health check endpoint
app.get("/api/health", (req, res) => {
  res.json({
    status: "ok",
    service: "SAVE - Legal Document Automation Engine",
    version: "2.0.0",
    jurisdiction: "DO",
    hasGemini: !!process.env.GEMINI_API_KEY,
  });
});

// Deep AI Legal Entity & Clause Extraction Endpoint
app.post("/api/analyze-gemini", async (req, res) => {
  try {
    const { text, existingVariables = [] } = req.body;
    if (!text || typeof text !== "string") {
      return res.status(400).json({ error: "Document text is required" });
    }

    const ai = getGenAI();
    if (!ai) {
      return res.status(503).json({
        error: "GEMINI_API_KEY is not configured on server",
        isFallback: true,
      });
    }

    const prompt = `Act as an expert Dominican Republic Legal Tech NLP analyst for the SAVE platform.
Analyze the following Dominican legal text and extract all dynamic entities, legal parties, Cédulas, RNCs, financial amounts, notarial dates, addresses, and reusable legal clauses.

Format your response strictly as valid JSON matching this schema:
{
  "detectedVariables": [
    {
      "tag": "snake_case_name",
      "label": "Human readable label in Spanish",
      "originalValue": "exact text from document",
      "category": "CAT_NAME" | "CAT_CEDULA" | "CAT_RNC" | "CAT_AMOUNT" | "CAT_DATE" | "CAT_ADDRESS" | "CAT_COMPANY" | "CAT_ROLE" | "CAT_TERM",
      "dataType": "string" | "number" | "currency" | "date" | "cedula" | "rnc" | "address" | "person" | "company",
      "confidence": 0.95,
      "gender": "masculino" | "femenino" | "no_especificado",
      "role": "arrendador" | "arrendatario" | "comprador" | "vendedor" | "acreedor" | "deudor" | "notario" | "garante" | "otro",
      "description": "Short explanation of this legal field in Spanish",
      "required": true
    }
  ],
  "detectedClauses": [
    {
      "title": "Title of the clause (e.g. Cláusula de Depósito de Garantía)",
      "category": "Garantía" | "Penalidades" | "Jurisdicción" | "Mantenimiento" | "Terminación" | "Confidencialidad" | "General",
      "snippet": "first 150 chars of clause",
      "conditionalSuggestion": "e.g. if incluye_mantenimiento == true"
    }
  ],
  "legalConsistencyNotes": [
    "Any legal observations like amount in numbers matching words, valid JCE format, or missing notary clauses"
  ]
}

Document Text to analyze:
"""
${text.slice(0, 15000)}
"""`;

    const response = await ai.models.generateContent({
      model: "gemini-3.7-flash",
      contents: prompt,
      config: {
        responseMimeType: "application/json",
        temperature: 0.1,
      },
    });

    const outputText = response.text || "{}";
    const parsed = JSON.parse(outputText);
    return res.json({
      success: true,
      data: parsed,
    });
  } catch (error: any) {
    console.error("Gemini analysis error:", error);
    return res.status(500).json({
      error: error.message || "Failed to analyze document with AI",
      success: false,
    });
  }
});

async function start() {
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`SAVE Legal Platform running on http://localhost:${PORT}`);
  });
}

start();
