import React from "react";

type ButtonProps = {
  children: React.ReactNode;
  onClick?: () => void;
};

export const Button = ({ children, onClick }: ButtonProps) => {
  return (
    <button
      style={{
        padding: "0.5rem 1rem",
        borderRadius: "8px",
        border: "1px solid gray",
        backgroundColor: "#f0f0f0",
        cursor: "pointer",
        fontWeight: "bold"
      }}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
