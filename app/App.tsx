import { useState } from "react";
import { BottomNavigation } from "./components/BottomNavigation";
import { HomeScreen } from "./components/HomeScreen";
import { AIChatScreen } from "./components/AIChatScreen";
import { MedicalCardScreen } from "./components/MedicalCardScreen";
import { ProfileScreen } from "./components/ProfileScreen";
import { EmergencyButton } from "./components/EmergencyButton";

export default function App() {
  const [activeTab, setActiveTab] = useState("home");

  const renderScreen = () => {
    switch (activeTab) {
      case "home":
        return <HomeScreen onNavigate={setActiveTab} />;
      case "chat":
        return <AIChatScreen />;
      case "medical":
        return <MedicalCardScreen />;
      case "profile":
        return <ProfileScreen />;
      default:
        return <HomeScreen onNavigate={setActiveTab} />;
    }
  };

  return (
    <div className="h-screen flex flex-col bg-white max-w-md mx-auto relative">
      {renderScreen()}
      <BottomNavigation activeTab={activeTab} onTabChange={setActiveTab} />
      <EmergencyButton />
    </div>
  );
}
