# Install jq if not already installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    apt-get update && apt-get install -y jq
fi

# Function to add a script to package.json
addScript() {
    local package_path=$1
    local script_name=$2
    local script_command=$3
    
    # Add or update the specified script in the scripts object
    jq --arg name "$script_name" --arg cmd "$script_command" \
       '.scripts[$name] = $cmd' "$package_path" > "$package_path.tmp" && 
       mv "$package_path.tmp" "$package_path"
}

# --------------------------------------------------------------

# Define shared variables at the top
workspaceDir="/workspace"
pakagesDir="$workspaceDir/packages"

# Create directories for components
mkdir -p /workspace/packages
# Create directories for the component test app
mkdir -p /workspace/apps


# --------------------------------------------------------------
# Function to initialize a component
# --------------------------------------------------------------
initComponent() {
    local componentName=$1
    local componentDir="${pakagesDir}/${componentName}"

    # Create the component directory
    mkdir -p "$componentDir"

    #------------------------------------------------------------
    #                   comp1 - a simple component
    # Create a component in the packages directory
    #------------------------------------------------------------
    cd "$componentDir"
    pnpm init

    # Create tsconfig.json for the component
    # This file contains the TypeScript compiler options and settings
    # for the component. It specifies the target JavaScript version,
    # module system, library files, and other compiler options.
    # The "include" and "exclude" sections specify which files and
    # directories should be included or excluded from the compilation.
    cat > "$componentDir/tsconfig.json" <<'EOF'
// Compiler options for TypeScript
{
    "compilerOptions": {
        // Set the JavaScript language version for emitted code
        "target": "ES2020",
        // Specify the module code generation method
        "module": "ESNext",
        // List of library files to include in the compilation
        "lib": [
            "dom",              // Include DOM library types
            "dom.iterable",     // Include iterable DOM types
            "esnext"            // Include latest ECMAScript features
        ],
        // Specify JSX code generation mode (for React 17+)
        "jsx": "react-jsx",
        // Generate .d.ts declaration files
        "declaration": true,
        // Generate source map files for debugging
        "sourceMap": true,
        // Output directory for compiled files
        "outDir": "./dist",
        // Root directory of input files
        "rootDir": "./src",
        // Enable all strict type-checking options
        "strict": true,
        // Enable interoperability between CommonJS and ES Modules
        "esModuleInterop": true,
        // Skip type checking of declaration files (*.d.ts)
        "skipLibCheck": true,
        // Ensure file name casing consistency between imports and file system
        "forceConsistentCasingInFileNames": true,
        // Use bundler-style module resolution (for tools like Vite, Webpack)
        "moduleResolution": "bundler",
        // Allow default imports from modules with no default export
        "allowSyntheticDefaultImports": true,
        // Allow importing .json files as modules
        "resolveJsonModule": true,
        // Ensure each file can be safely transpiled independently
        "isolatedModules": true,
        // Emit output files (set to false to disable emitting)
        "noEmit": false
    },
    // List of directories to include in the compilation
    "include": [
        "src"
    ],
    // List of directories to exclude from the compilation
    "exclude": [
        "node_modules",            // Exclude dependencies
        "dist",                    // Exclude build output
        "**/__tests__/**",         // Exclude test directories
        "**/*.test.*",             // Exclude test files
        "**/*.spec.*"              // Exclude spec files
    ]
}
EOF


# Create a simple test file for the component
mkdir -p "${componentDir}/src"
cat > "$componentDir/src/index.tsx" <<'EOF'
type CompomompoProps = { message: string };

function Compomompo({ message }: CompomompoProps) {
    console.log("Compo message", message);
    console.log(`Logger - ${new Date().toISOString()}: ${message}`);
    return (
        <div>
            <h1>comp1 Bileşeninden gelen mesaj: {message}</h1>
        </div>
    );
}

export default Compomompo;
EOF

    # change the test script to build the package
    addScript "$componentDir/package.json" "build" "tsc"
    addScript "$workspaceDir/package.json" "build:$componentName" "pnpm --filter $componentName build"

    # Change the entrypoint of the package to the dist folder
    sed -i '5s|"main": "index.js",|"main": "dist/index.js",|' "$componentDir/package.json"
}


addIndexTsx() {
    local componentName=$1
    local componentDir="${pakagesDir}/${componentName}"

    # ensure src folder exists
    mkdir -p "${componentDir}/src"

    # Create a simple test file for the component
    cat > "${componentDir}/src/index.tsx" << "EOF"
type CompomompoProps = { message: string };

function Compomompo({ message }: CompomompoProps) {
    console.log("Compo message", message);
    console.log(`Logger - ${new Date().toISOString()}: ${message}`);
    return (
        <div>
            <h1>comp1 Bileşeninden gelen mesaj: {message}</h1>
        </div>
    );
}

export default Compomompo;
EOF
}

addDependencies() {
    local componentName=$1
    local componentDir="${pakagesDir}/${componentName}"

    cd "$workspaceDir"
    # install dependencies
    pnpm add --filter "$componentName" --save-dev typescript @types/react @types/react @types/react-dom

    # install dev dependencies
    # install react and react-dom as peer dependencies
    # This means that the component will expect these packages to be
    # installed in the consuming application, and it will not bundle them
    # with the component. This is a common practice for libraries and
    # components to avoid version conflicts and reduce bundle size.
    # The --filter flag is used to specify the package to which the
    # dependencies should be added. In this case, we are adding the
    # dependencies to the "comp1" package.
    # The --workspace-root flag is used to specify that the dependencies
    # should be added to the root package.json file, which is the
    # workspace root. This is useful for monorepos where you want to
    # manage dependencies at the workspace level.
    pnpm add --filter --save-peer "$componentName" react react-dom
}

addComponentToWorkspace() {
    local componentName=$1
    local componentDir="${pakagesDir}/${componentName}"

    # Linking comp1 to the root package.json
    cd "$workspaceDir"
    pnpm add "./packages/$componentName" --workspace-root
}

createComponent() {
    local componentName=$1
    initComponent "$componentName"
    
    addIndexTsx "$componentName"

    addDependencies "$componentName"

    # Add the component to the workspace
    addComponentToWorkspace "$componentName"
}
# -------------------------------------------------------------

createWebapp() {
    local appName=$1

    # -------------------------------------------------------------
    #               comp1-app - a simple web app
    # Create test web app for the first component
    # -------------------------------------------------------------
    cd "$workspaceDir"
    pnpm create vite "apps/$appName" --template react-ts

    appDir="$workspaceDir/apps/$appName"
    cd "$appDir"
    pnpm install

    cat > "$appDir/vite.config.ts" <<'EOF'
    import { defineConfig } from 'vite'
    import react from '@vitejs/plugin-react'

    export default defineConfig({
        plugins: [react()],
        server: {
            port: 3001,
            host: '0.0.0.0',
        }
    })
EOF

    # Create a simple React component that uses the Logger from comp1
    cat > "$appDir/src/App.tsx" <<'EOF'
    import Compomompo from 'comp1'

    function App() {
    return (
        <div className="App">
        <h1>comp1 Web App</h1>
        <Compomompo message="Hello from comp1!" />
        </div>
    )
    }

    export default App
EOF

    # Add a script to start the web app
    addScript "$appDir/package.json" "start" "vite"
    addScript "$workspaceDir/package.json" "start:$appName:ui" "pnpm --filter $appName dev"
}

# -------------------------------------------------------------


# Create a pnpm workspace with two components
cat > /workspace/pnpm-workspace.yaml << EOF
packages:
  - 'apps/*'
  - 'packages/*'
EOF

cd /workspace
pnpm init

# Initialize the first component
createComponent "comp1"

# Create a web app for the first component
createWebapp "comp1-app"