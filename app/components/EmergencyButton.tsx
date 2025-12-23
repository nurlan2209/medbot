import { Phone } from "lucide-react";
import { useState } from "react";

export function EmergencyButton() {
  const [showDialog, setShowDialog] = useState(false);

  const emergencyContacts = [
    { label: "Emergency Services", number: "911", country: "US" },
    { label: "Emergency Services", number: "112", country: "EU" },
  ];

  const handleEmergencyClick = () => {
    setShowDialog(true);
  };

  const handleCall = (number: string) => {
    window.location.href = `tel:${number}`;
  };

  if (showDialog) {
    return (
      <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 px-4">
        <div className="bg-white rounded-2xl p-6 max-w-sm w-full">
          <div className="text-center mb-6">
            <div className="flex items-center justify-center w-16 h-16 bg-[#EF4444] rounded-full mx-auto mb-4">
              <Phone className="w-8 h-8 text-white" />
            </div>
            <h2 className="text-[20px] text-black mb-2">Emergency Services</h2>
            <p className="text-[14px] text-[#999999]">
              If you are in danger, contact emergency services immediately.
            </p>
          </div>

          <div className="space-y-3 mb-6">
            {emergencyContacts.map((contact, index) => (
              <button
                key={index}
                onClick={() => handleCall(contact.number)}
                className="w-full p-4 bg-[#EF4444] text-white rounded-xl hover:bg-[#DC2626] transition-colors"
              >
                <div className="text-center">
                  <div className="mb-1">{contact.label}</div>
                  <div className="text-[20px]">{contact.number}</div>
                  <div className="text-[12px] opacity-80">({contact.country})</div>
                </div>
              </button>
            ))}
          </div>

          <button
            onClick={() => setShowDialog(false)}
            className="w-full p-4 bg-[#F5F5F5] text-black rounded-xl"
          >
            Cancel
          </button>
        </div>
      </div>
    );
  }

  return (
    <button
      onClick={handleEmergencyClick}
      className="fixed right-4 bottom-20 w-14 h-14 bg-[#EF4444] text-white rounded-full shadow-lg flex items-center justify-center z-40 hover:bg-[#DC2626] transition-colors"
      aria-label="Emergency"
    >
      <Phone className="w-6 h-6" />
    </button>
  );
}
