import { ChevronRight, User, Settings, Clock, Save, FileText, Shield, Trash2 } from "lucide-react";

export function ProfileScreen() {
  const menuSections = [
    {
      title: "Account",
      items: [
        { icon: User, label: "User Information", action: "user-info" },
        { icon: Settings, label: "AI Preferences", action: "ai-preferences" },
      ],
    },
    {
      title: "History & Data",
      items: [
        { icon: Clock, label: "Chat History", action: "chat-history" },
        { icon: Save, label: "Saved Items", action: "saved-items" },
      ],
    },
    {
      title: "Legal & Privacy",
      items: [
        { icon: FileText, label: "Medical Disclaimer", action: "disclaimer" },
        { icon: Shield, label: "Privacy Policy", action: "privacy" },
        { icon: Shield, label: "Data Privacy Settings", action: "data-privacy" },
      ],
    },
    {
      title: "Danger Zone",
      items: [
        { icon: Trash2, label: "Delete Account", action: "delete-account", danger: true },
      ],
    },
  ];

  return (
    <div className="flex-1 overflow-auto pb-20 bg-white">
      {/* Header */}
      <div className="px-4 pt-6 pb-4 border-b border-[#E5E5E5]">
        <h1 className="text-[24px] text-black mb-1">Profile</h1>
        <p className="text-[#999999]">Settings and preferences</p>
      </div>

      {/* User Profile Card */}
      <div className="px-4 py-6">
        <div className="flex items-center gap-4 p-4 border border-[#E5E5E5] rounded-xl">
          <div className="flex items-center justify-center w-16 h-16 bg-[#0F4BFB] rounded-full">
            <span className="text-white text-[24px]">JD</span>
          </div>
          <div className="flex-1">
            <div className="text-[18px] text-black">John Doe</div>
            <div className="text-[14px] text-[#999999]">john.doe@email.com</div>
          </div>
          <button className="p-2">
            <ChevronRight className="w-5 h-5 text-[#999999]" />
          </button>
        </div>
      </div>

      {/* Menu Sections */}
      <div className="px-4 space-y-6 pb-6">
        {menuSections.map((section, sectionIndex) => (
          <div key={sectionIndex}>
            <h2 className="text-[14px] text-[#999999] mb-3 px-2">
              {section.title}
            </h2>
            <div className="border border-[#E5E5E5] rounded-xl overflow-hidden">
              {section.items.map((item, itemIndex) => {
                const Icon = item.icon;
                return (
                  <button
                    key={itemIndex}
                    className={`w-full flex items-center gap-3 p-4 bg-white hover:bg-[#F5F5F5] transition-colors ${
                      itemIndex !== section.items.length - 1
                        ? "border-b border-[#E5E5E5]"
                        : ""
                    }`}
                  >
                    <Icon
                      className={`w-5 h-5 ${
                        item.danger ? "text-[#EF4444]" : "text-[#0F4BFB]"
                      }`}
                    />
                    <span
                      className={`flex-1 text-left ${
                        item.danger ? "text-[#EF4444]" : "text-black"
                      }`}
                    >
                      {item.label}
                    </span>
                    <ChevronRight className="w-4 h-4 text-[#999999]" />
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      {/* App Info */}
      <div className="px-4 pb-6">
        <div className="text-center text-[12px] text-[#999999]">
          <p className="mb-1">Medical Assistant v1.0.0</p>
          <p>© 2025 All rights reserved</p>
        </div>
      </div>

      {/* Medical Disclaimer */}
      <div className="px-4 pb-6">
        <div className="p-4 bg-[#F5F5F5] rounded-xl border border-[#E5E5E5]">
          <p className="text-[12px] text-[#484C52] text-center">
            ⚠️ This application provides informational support only and does not
            replace professional medical advice. Always consult with qualified
            healthcare professionals for medical decisions.
          </p>
        </div>
      </div>
    </div>
  );
}
