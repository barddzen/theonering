#!/bin/bash
# Flight Ready Android - Run All Prompts
# Executes all Claude Code prompts in sequence

set -e

PROJECT_ROOT="/Users/davidyutzy/Development/FlightReady/android"
TEMPLATES_DIR="$PROJECT_ROOT/templates"
APP_DIR="$PROJECT_ROOT/FlightReadyAndroid"

echo "🚀 Flight Ready Android - Running All Prompts"
echo "=============================================="
echo ""

cd "$PROJECT_ROOT"

# Check if templates directory exists
if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "❌ Error: Templates directory not found at $TEMPLATES_DIR"
    exit 1
fi

# Function to run prompts in a phase
run_phase() {
    local phase_dir=$1
    local phase_name=$(basename "$phase_dir")
    
    echo ""
    echo "📦 Starting $phase_name"
    echo "────────────────────────────────────────"
    
    # Read PLAN.md if it exists
    if [ -f "$phase_dir/PLAN.md" ]; then
        echo "📋 Phase Plan:"
        head -10 "$phase_dir/PLAN.md"
        echo ""
    fi
    
    # Run each step in order
    for step_file in "$phase_dir"/Step*.md; do
        if [ -f "$step_file" ]; then
            local step_name=$(basename "$step_file")
            echo ""
            echo "▶️  Running $step_name..."
            
            # Feed prompt to Claude Code
            # Uncomment when ready to use:
            # claude-code < "$step_file"
            
            echo "   [Prompt would be executed here]"
            
            # Verify build still works
            echo "   🔨 Verifying build..."
            cd "$APP_DIR"
            if ./gradlew assembleDebug --quiet 2>&1 | grep -q "BUILD SUCCESSFUL"; then
                echo "   ✅ Build successful"
            else
                echo "   ⚠️  Build issues detected - review before continuing"
                read -p "   Continue anyway? (y/N) " -n 1 -r
                echo ""
                if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                    echo "   ❌ Stopped at $phase_name/$step_name"
                    exit 1
                fi
            fi
            cd "$PROJECT_ROOT"
        fi
    done
    
    echo ""
    echo "✅ $phase_name complete"
}

# Get all phase directories in order
phases=($(find "$TEMPLATES_DIR" -maxdepth 1 -type d -name "Phase*" | sort))

if [ ${#phases[@]} -eq 0 ]; then
    echo "⚠️  No phase directories found in $TEMPLATES_DIR"
    echo "   Phase directories should be named: Phase01-Foundation, Phase02-Services, etc."
    exit 1
fi

echo "📋 Found ${#phases[@]} phases to execute"
for phase in "${phases[@]}"; do
    echo "   • $(basename "$phase")"
done

echo ""
read -p "Start execution? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Execution cancelled"
    exit 0
fi

# Run all phases
start_time=$(date +%s)

for phase_dir in "${phases[@]}"; do
    run_phase "$phase_dir"
    
    # Optional: pause between phases
    # read -p "Press enter to continue to next phase..."
done

end_time=$(date +%s)
duration=$((end_time - start_time))

echo ""
echo "🎉 All Phases Complete!"
echo "────────────────────────────────────────"
echo "⏱️  Total time: ${duration}s"
echo ""
echo "🔍 Final verification:"
cd "$APP_DIR"
./gradlew assembleDebug
echo ""
echo "✅ Flight Ready Android build complete!"
