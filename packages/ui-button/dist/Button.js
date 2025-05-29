import { jsx as _jsx } from "react/jsx-runtime";
export const Button = ({ children, onClick }) => {
    return (_jsx("button", { style: {
            padding: "0.5rem 1rem",
            borderRadius: "8px",
            border: "1px solid gray",
            backgroundColor: "#f0f0f0",
            cursor: "pointer",
            fontWeight: "bold"
        }, onClick: onClick, children: children }));
};
//# sourceMappingURL=Button.js.map