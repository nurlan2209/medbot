import { Pencil, ChevronRight, CircleAlert } from "lucide-react";
import { useState } from "react";

export function MedicalCardScreen() {
  const [aiDataEnabled, setAiDataEnabled] = useState(true);

  const medicalData = {
    personalInfo: {
      name: "John Doe",
      dateOfBirth: "January 15, 1985",
      bloodType: "A+",
      height: "175 cm",
      weight: "70 kg",
    },
    chronicConditions: [
      "Hypertension",
      "Type 2 Diabetes",
    ],
    allergies: [
      { name: "Penicillin", severity: "High" },
      { name: "Peanuts", severity: "Medium" },
    ],
    currentMedications: [
      { name: "Metformin", dosage: "500mg", frequency: "Twice daily" },
      { name: "Lisinopril", dosage: "10mg", frequency: "Once daily" },
    ],
    documents: [
      { name: "Blood Test Results", date: "Dec 10, 2025" },
      { name: "Annual Checkup", date: "Nov 20, 2025" },
    ],
  };

  return (
    <div className="flex-1 overflow-auto pb-20 bg-white">
      {/* Header */}
      <div className="px-4 pt-6 pb-4 border-b border-[#E5E5E5]">
        <div className="flex items-center justify-between mb-2">
          <h1 className="text-[24px] text-black">Medical Card</h1>
          <button className="p-2">
            <Pencil className="w-5 h-5 text-[#0F4BFB]" />
          </button>
        </div>
        <p className="text-[#999999]">Your personal health information</p>
      </div>

      {/* AI Data Toggle */}
      <div className="px-4 py-4 bg-[#F5F5F5]">
        <div className="flex items-center justify-between">
          <div className="flex-1">
            <div className="text-black mb-1">Use medical data in AI responses</div>
            <div className="text-[12px] text-[#999999]">
              Allow AI to personalize responses
            </div>
          </div>
          <button
            onClick={() => setAiDataEnabled(!aiDataEnabled)}
            className={`relative w-12 h-7 rounded-full transition-colors ${
              aiDataEnabled ? "bg-[#0F4BFB]" : "bg-[#E5E5E5]"
            }`}
          >
            <div
              className={`absolute top-1 w-5 h-5 bg-white rounded-full transition-transform ${
                aiDataEnabled ? "translate-x-6" : "translate-x-1"
              }`}
            ></div>
          </button>
        </div>
      </div>

      <div className="px-4 py-4 space-y-4">
        {/* Personal Information */}
        <div className="border border-[#E5E5E5] rounded-xl p-4">
          <h2 className="text-[18px] text-black mb-4">Personal Information</h2>
          <div className="space-y-3">
            <div className="flex justify-between">
              <span className="text-[#999999]">Name</span>
              <span className="text-black">{medicalData.personalInfo.name}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-[#999999]">Date of Birth</span>
              <span className="text-black">{medicalData.personalInfo.dateOfBirth}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-[#999999]">Blood Type</span>
              <span className="text-black">{medicalData.personalInfo.bloodType}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-[#999999]">Height</span>
              <span className="text-black">{medicalData.personalInfo.height}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-[#999999]">Weight</span>
              <span className="text-black">{medicalData.personalInfo.weight}</span>
            </div>
          </div>
        </div>

        {/* Chronic Conditions */}
        <div className="border border-[#E5E5E5] rounded-xl p-4">
          <h2 className="text-[18px] text-black mb-4">Chronic Conditions</h2>
          <div className="space-y-2">
            {medicalData.chronicConditions.map((condition, index) => (
              <div
                key={index}
                className="flex items-center justify-between p-3 bg-[#F5F5F5] rounded-lg"
              >
                <span className="text-black">{condition}</span>
                <ChevronRight className="w-4 h-4 text-[#999999]" />
              </div>
            ))}
          </div>
        </div>

        {/* Allergies */}
        <div className="border border-[#EF4444] rounded-xl p-4 bg-[#FEF2F2]">
          <div className="flex items-center gap-2 mb-4">
            <CircleAlert className="w-5 h-5 text-[#EF4444]" />
            <h2 className="text-[18px] text-black">Allergies (Critical)</h2>
          </div>
          <div className="space-y-2">
            {medicalData.allergies.map((allergy, index) => (
              <div
                key={index}
                className="flex items-center justify-between p-3 bg-white rounded-lg border border-[#EF4444]"
              >
                <div>
                  <div className="text-black">{allergy.name}</div>
                  <div className="text-[12px] text-[#999999]">
                    Severity: {allergy.severity}
                  </div>
                </div>
                <ChevronRight className="w-4 h-4 text-[#999999]" />
              </div>
            ))}
          </div>
        </div>

        {/* Current Medications */}
        <div className="border border-[#E5E5E5] rounded-xl p-4">
          <h2 className="text-[18px] text-black mb-4">Current Medications</h2>
          <div className="space-y-3">
            {medicalData.currentMedications.map((med, index) => (
              <div
                key={index}
                className="p-3 bg-[#F5F5F5] rounded-lg"
              >
                <div className="text-black mb-1">{med.name}</div>
                <div className="text-[14px] text-[#999999]">
                  {med.dosage} • {med.frequency}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Medical Documents */}
        <div className="border border-[#E5E5E5] rounded-xl p-4 mb-4">
          <h2 className="text-[18px] text-black mb-4">Medical Documents</h2>
          <div className="space-y-2">
            {medicalData.documents.map((doc, index) => (
              <button
                key={index}
                className="w-full flex items-center justify-between p-3 bg-[#F5F5F5] rounded-lg hover:bg-[#E5E5E5] transition-colors"
              >
                <div className="text-left">
                  <div className="text-black">{doc.name}</div>
                  <div className="text-[12px] text-[#999999]">{doc.date}</div>
                </div>
                <ChevronRight className="w-4 h-4 text-[#999999]" />
              </button>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
