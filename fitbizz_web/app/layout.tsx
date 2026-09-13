import "./globals.css";
import PlatformLayout from "./components/PlatformLayout";

export const metadata = {
  title: "FitBizz Multi-Tenant SaaS • Platform Control Center",
  description: "Enterprise Multi-Tenant Gym Management SaaS Platform Administration",
  icons: {
    icon: "/fitbizz_logo.png",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="min-h-screen bg-[#f8fafc] text-slate-900 antialiased">
        <PlatformLayout>{children}</PlatformLayout>
      </body>
    </html>
  );
}
