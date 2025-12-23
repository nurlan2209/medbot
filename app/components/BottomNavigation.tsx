import { House, MessageSquare, FileText, User } from "lucide-react";

interface BottomNavigationProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

export function BottomNavigation({ activeTab, onTabChange }: BottomNavigationProps) {
  const tabs = [
    { id: "home", label: "Home", icon: House },
    { id: "chat", label: "AI Chat", icon: MessageSquare },
    { id: "medical", label: "Medical Card", icon: FileText },
    { id: "profile", label: "Profile", icon: User },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-[#E5E5E5] safe-area-inset-bottom">
      <nav className="flex items-center justify-around h-16 max-w-md mx-auto">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className="flex flex-col items-center justify-center gap-1 flex-1 h-full transition-colors"
            >
              <Icon
                className={`w-6 h-6 ${
                  isActive ? "text-[#0F4BFB]" : "text-[#999999]"
                }`}
                strokeWidth={isActive ? 2 : 1.5}
              />
              <span
                className={`text-[10px] ${
                  isActive ? "text-[#0F4BFB]" : "text-[#999999]"
                }`}
              >
                {tab.label}
              </span>
            </button>
          );
        })}
      </nav>
    </div>
  );
}
