import { useState } from "react";
import { Send, Plus, CircleAlert, Save, Share } from "lucide-react";

interface Message {
  id: string;
  type: "user" | "ai";
  content: string;
  riskLevel?: "low" | "medium" | "high";
  timestamp: Date;
}

interface ChatHistory {
  id: string;
  title: string;
  date: string;
  lastMessage: string;
}

export function AIChatScreen() {
  const [showHistory, setShowHistory] = useState(true);
  const [currentChat, setCurrentChat] = useState<Message[]>([]);
  const [inputValue, setInputValue] = useState("");

  const chatHistory: ChatHistory[] = [
    {
      id: "1",
      title: "Headache and dizziness",
      date: "Today, 14:30",
      lastMessage: "Monitor symptoms and rest...",
    },
    {
      id: "2",
      title: "Drug interaction check",
      date: "Yesterday",
      lastMessage: "No known interactions found...",
    },
    {
      id: "3",
      title: "Fever and cough symptoms",
      date: "Dec 18, 2025",
      lastMessage: "Consult with your doctor if...",
    },
  ];

  const sampleMessages: Message[] = [
    {
      id: "1",
      type: "user",
      content: "I have a persistent headache and feel dizzy",
      timestamp: new Date(),
    },
    {
      id: "2",
      type: "ai",
      content:
        "I understand you're experiencing headaches and dizziness. Let me analyze this with your medical profile.",
      riskLevel: "medium",
      timestamp: new Date(),
    },
  ];

  const handleStartChat = () => {
    setShowHistory(false);
    setCurrentChat(sampleMessages);
  };

  const handleSendMessage = () => {
    if (!inputValue.trim()) return;
    
    const newMessage: Message = {
      id: Date.now().toString(),
      type: "user",
      content: inputValue,
      timestamp: new Date(),
    };
    
    setCurrentChat([...currentChat, newMessage]);
    setInputValue("");
    
    // Simulate AI response
    setTimeout(() => {
      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        type: "ai",
        content: "Based on your symptoms and medical history, I can provide some insights. However, please consult with a healthcare professional for proper diagnosis.",
        riskLevel: "low",
        timestamp: new Date(),
      };
      setCurrentChat(prev => [...prev, aiResponse]);
    }, 1000);
  };

  const getRiskColor = (level?: string) => {
    switch (level) {
      case "high":
        return "bg-[#EF4444]";
      case "medium":
        return "bg-[#F59E0B]";
      case "low":
        return "bg-[#10B981]";
      default:
        return "bg-[#999999]";
    }
  };

  const getRiskLabel = (level?: string) => {
    switch (level) {
      case "high":
        return "High Risk";
      case "medium":
        return "Medium Risk";
      case "low":
        return "Low Risk";
      default:
        return "";
    }
  };

  if (showHistory) {
    return (
      <div className="flex-1 flex flex-col pb-20 bg-white">
        {/* Header */}
        <div className="px-4 pt-6 pb-4 border-b border-[#E5E5E5]">
          <h1 className="text-[24px] text-black mb-1">AI Chat</h1>
          <p className="text-[#999999]">Medical consultation assistant</p>
        </div>

        {/* Medical Profile Badge */}
        <div className="px-4 py-3 bg-[#F5F5F5]">
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 bg-[#10B981] rounded-full"></div>
            <span className="text-[12px] text-[#484C52]">
              Medical profile applied
            </span>
          </div>
        </div>

        {/* Chat History */}
        <div className="flex-1 overflow-auto px-4 pt-4">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-[18px] text-black">Recent Chats</h2>
            <button
              onClick={handleStartChat}
              className="flex items-center gap-2 px-4 py-2 bg-[#0F4BFB] text-white rounded-lg"
            >
              <Plus className="w-4 h-4" />
              <span className="text-[14px]">New Chat</span>
            </button>
          </div>

          <div className="space-y-3 pb-4">
            {chatHistory.map((chat) => (
              <button
                key={chat.id}
                onClick={handleStartChat}
                className="w-full p-4 bg-white border border-[#E5E5E5] rounded-xl text-left hover:border-[#0F4BFB] transition-colors"
              >
                <div className="text-black mb-1">{chat.title}</div>
                <div className="text-[14px] text-[#999999] mb-2 truncate">
                  {chat.lastMessage}
                </div>
                <div className="text-[12px] text-[#999999]">{chat.date}</div>
              </button>
            ))}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="flex-1 flex flex-col pb-20 bg-white">
      {/* Header */}
      <div className="px-4 py-4 border-b border-[#E5E5E5] bg-white">
        <div className="flex items-center justify-between">
          <button
            onClick={() => setShowHistory(true)}
            className="text-[#0F4BFB]"
          >
            ← Back
          </button>
          <div className="flex items-center gap-2">
            <button className="p-2">
              <Save className="w-5 h-5 text-[#999999]" />
            </button>
            <button className="p-2">
              <Share className="w-5 h-5 text-[#999999]" />
            </button>
          </div>
        </div>
      </div>

      {/* Medical Profile Badge */}
      <div className="px-4 py-2 bg-[#F5F5F5]">
        <div className="flex items-center gap-2">
          <div className="w-2 h-2 bg-[#10B981] rounded-full"></div>
          <span className="text-[12px] text-[#484C52]">
            Medical profile applied
          </span>
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 overflow-auto px-4 py-4">
        <div className="space-y-4">
          {currentChat.map((message) => (
            <div
              key={message.id}
              className={`flex ${
                message.type === "user" ? "justify-end" : "justify-start"
              }`}
            >
              <div
                className={`max-w-[80%] ${
                  message.type === "user"
                    ? "bg-[#0F4BFB] text-white"
                    : "bg-[#F5F5F5] text-black"
                } p-4 rounded-xl`}
              >
                {message.type === "ai" && message.riskLevel && (
                  <div className="flex items-center gap-2 mb-3 pb-3 border-b border-[#E5E5E5]">
                    <div
                      className={`w-2 h-2 rounded-full ${getRiskColor(
                        message.riskLevel
                      )}`}
                    ></div>
                    <span className="text-[12px] text-[#484C52]">
                      {getRiskLabel(message.riskLevel)}
                    </span>
                  </div>
                )}
                <p className="text-[14px]">{message.content}</p>
                {message.type === "ai" && (
                  <div className="mt-3 pt-3 border-t border-[#E5E5E5]">
                    <button className="text-[#0F4BFB] text-[12px]">
                      Ask follow-up →
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Input */}
      <div className="px-4 py-4 border-t border-[#E5E5E5] bg-white">
        <div className="flex items-center gap-2">
          <input
            type="text"
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            onKeyPress={(e) => e.key === "Enter" && handleSendMessage()}
            placeholder="Describe your symptoms..."
            className="flex-1 px-4 py-3 bg-[#F5F5F5] rounded-xl border-none outline-none text-[14px]"
          />
          <button
            onClick={handleSendMessage}
            className="flex items-center justify-center w-12 h-12 bg-[#0F4BFB] rounded-xl"
          >
            <Send className="w-5 h-5 text-white" />
          </button>
        </div>
      </div>
    </div>
  );
}
