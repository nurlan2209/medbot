function buildMedicalContext(user) {
  const useMedicalData = user?.settings?.useMedicalDataInAI !== false;
  if (!useMedicalData) return null;

  const card = user?.medicalCard;
  if (!card) return null;

  const lines = [];
  const p = card.personalInfo || {};
  const push = (k, v) => {
    if (v === undefined || v === null) return;
    const s = String(v).trim();
    if (!s) return;
    lines.push(`${k}: ${s}`);
  };

  push("Name", p.name);
  push("Date of Birth", p.dateOfBirth);
  push("Blood Type", p.bloodType);
  push("Height", p.height);
  push("Weight", p.weight);

  if (Array.isArray(card.chronicConditions) && card.chronicConditions.length) {
    lines.push(`Chronic Conditions: ${card.chronicConditions.join(", ")}`);
  }
  if (Array.isArray(card.allergies) && card.allergies.length) {
    lines.push(
      `Allergies: ${card.allergies
        .filter(a => a?.name)
        .map(a => `${a.name}${a.severity ? ` (${a.severity})` : ""}`)
        .join(", ")}`
    );
  }
  if (Array.isArray(card.currentMedications) && card.currentMedications.length) {
    lines.push(
      `Current Medications: ${card.currentMedications
        .filter(m => m?.name)
        .map(m => `${m.name}${m.dosage ? ` ${m.dosage}` : ""}${m.frequency ? ` • ${m.frequency}` : ""}`)
        .join(", ")}`
    );
  }

  if (!lines.length) return null;
  return `You are a medical assistant. Use the following patient profile as context when answering, but do not reveal it verbatim unless asked.\n\n${lines.join("\n")}`;
}

module.exports = { buildMedicalContext };
