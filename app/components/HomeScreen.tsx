import { Search, Activity, Pill, FileUp, Phone } from "lucide-react";

interface HomeScreenProps {
  onNavigate: (tab: string) => void;
}

export function HomeScreen({ onNavigate }: HomeScreenProps) {
  const quickActions = [
    {
      id: "symptom-checker",
      title: "Symptom Checker",
      description: "Check your symptoms",
      icon: Activity,
    },
    {
      id: "drug-guide",
      title: "Drug Guide",
      description: "Search medications",
      icon: Pill,
    },
    {
      id: "analyze-document",
      title: "Analyze Document",
      description: "Upload medical files",
      icon: FileUp,
    },
  ];

  return (
    <div className="flex-1 overflow-auto pb-20 bg-white">
      {/* Header */}
      <div className="px-4 pt-6 pb-4">
        <h1 className="text-[24px] text-black mb-1">Medical Assistant</h1>
        <p className="text-[#999999]">Your AI-powered health companion</p>
      </div>

      {/* Search Bar */}
      <div className="px-4 mb-6">
        <div
          className="flex items-center gap-3 p-4 bg-[#F5F5F5] rounded-xl cursor-pointer"
          onClick={() => onNavigate("chat")}
        >
          <Search className="w-5 h-5 text-[#999999]" />
          <span className="text-[#999999]">Search symptoms, diagnoses...</span>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="px-4 mb-6">
        <h2 className="text-[18px] text-black mb-3">Quick Actions</h2>
        <div className="space-y-3">
          {quickActions.map((action) => {
            const Icon = action.icon;
            return (
              <button
                key={action.id}
                onClick={() => onNavigate("chat")}
                className="w-full flex items-center gap-4 p-4 bg-white border border-[#E5E5E5] rounded-xl hover:border-[#0F4BFB] transition-colors"
              >
                <div className="flex items-center justify-center w-12 h-12 bg-[#F5F5F5] rounded-lg">
                  <Icon className="w-6 h-6 text-[#0F4BFB]" />
                </div>
                <div className="flex-1 text-left">
                  <div className="text-black">{action.title}</div>
                  <div className="text-[14px] text-[#999999]">
                    {action.description}
                  </div>
                </div>
              </button>
            );
          })}
        </div>
      </div>

      {/* Ask AI Doctor CTA */}
      <div className="px-4 mb-6">
        <button
          onClick={() => onNavigate("chat")}
          className="w-full p-4 bg-[#0F4BFB] text-white rounded-xl"
        >
          Ask AI Doctor
        </button>
      </div>

      {/* Medical Disclaimer */}
      <div className="px-4 mb-6">
        <div className="p-4 bg-[#F5F5F5] rounded-xl border border-[#E5E5E5]">
          <p className="text-[12px] text-[#484C52] text-center">
            ⚠️ This application provides informational support only and does not
            replace professional medical advice.
          </p>
        </div>
      </div>
    </div>
  );
}
