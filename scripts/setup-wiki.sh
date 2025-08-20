#!/bin/bash

# GitHub Wiki Setup Script
# This script helps set up the GitHub Wiki for the gohex-auth project

set -e

REPO_URL="https://github.com/cristianino/gohex-auth"
WIKI_URL="https://github.com/cristianino/gohex-auth.wiki"

echo "🚀 GoHex Auth - GitHub Wiki Setup"
echo "=================================="

# Check if we're in the right directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Script directory: $SCRIPT_DIR"
echo "Project root: $PROJECT_ROOT"
echo ""

# Check if this looks like the gohex-auth project
if [[ ! -f "$PROJECT_ROOT/go.mod" ]] || [[ ! -f "$PROJECT_ROOT/README.md" ]]; then
    echo "❌ Error: Cannot find gohex-auth project structure"
    echo "   Expected go.mod and README.md in: $PROJECT_ROOT"
    echo "   Contents of $PROJECT_ROOT:"
    ls -la "$PROJECT_ROOT" 2>/dev/null || echo "   Directory not accessible"
    exit 1
fi

# Set the wiki directory path
WIKI_DIR="$PROJECT_ROOT/wiki"

# Check if wiki directory exists, if not try to find it
if [[ ! -d "$WIKI_DIR" ]]; then
    echo "⚠️  Wiki directory not found at: $WIKI_DIR"
    # Maybe we're running from wiki directory?
    if [[ -d "./wiki" ]]; then
        WIKI_DIR="./wiki"
        echo "✅ Found wiki directory at: ./wiki"
    elif [[ -d "../wiki" ]]; then
        WIKI_DIR="../wiki"  
        echo "✅ Found wiki directory at: ../wiki"
    else
        echo "❌ Error: wiki directory not found"
        echo "   Searched in: $PROJECT_ROOT/wiki, ./wiki, ../wiki"
        echo "   Please create wiki content first or run from correct directory"
        exit 1
    fi
else
    echo "✅ Found wiki directory at: $WIKI_DIR"
fi

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed or not in PATH"
    exit 1
fi

echo "📚 Setting up GitHub Wiki..."
echo ""

# Option 1: Manual setup instructions
echo "Manual Setup Instructions:"
echo "========================="
echo ""
echo "1. Go to your repository: $REPO_URL"
echo "2. Click on the 'Wiki' tab"
echo "3. Click 'Create the first page'"
echo "4. For each file in the wiki/ directory, create a new wiki page:"
echo ""

# List all wiki files and their suggested page names
for file in "$WIKI_DIR"/*.md; do
    if [[ -f "$file" ]]; then
        basename=$(basename "$file" .md)
        echo "   📄 $basename"
        echo "      Content from: $file"
        echo ""
    fi
done

echo "5. Copy the content from each file to its corresponding wiki page"
echo "6. Save each page"
echo ""

# Option 2: Automated setup (if wiki repo is accessible)
echo "Automated Setup (Advanced):"
echo "============================"
echo ""
echo "If you have write access to the wiki repository, you can clone and push directly:"
echo ""
echo "git clone $WIKI_URL.git temp-wiki"
echo "cp $WIKI_DIR/*.md temp-wiki/"
echo "cd temp-wiki"
echo "git add ."
echo "git commit -m 'Initial wiki setup'"
echo "git push origin master"
echo "cd .."
echo "rm -rf temp-wiki"
echo ""

# Option 3: Create a summary of what should be created
echo "Wiki Page Summary:"
echo "=================="
echo ""
echo "The following pages will be created in your GitHub Wiki:"
echo ""

declare -A wiki_descriptions
wiki_descriptions[Home]="Project overview and quick navigation"
wiki_descriptions[Quick-Start]="5-minute setup guide for new developers"
wiki_descriptions[Development-Workflow]="Daily development practices and best practices"
wiki_descriptions[Hexagonal-Architecture]="Architecture implementation details and examples"
wiki_descriptions[README]="Wiki maintenance and structure guide"

for file in "$WIKI_DIR"/*.md; do
    if [[ -f "$file" ]]; then
        basename=$(basename "$file" .md)
        description=${wiki_descriptions[$basename]:-"Documentation page"}
        echo "📖 $basename"
        echo "   $description"
        echo "   Lines: $(wc -l < "$file")"
        echo ""
    fi
done

echo "✅ Wiki content is ready!"
echo ""
echo "Next Steps:"
echo "==========="
echo "1. Visit $REPO_URL"
echo "2. Click the 'Wiki' tab"
echo "3. Create pages using the content from the wiki/ directory"
echo "4. Link pages together for easy navigation"
echo ""
echo "💡 Tip: Start with the Home page for the best first impression!"

# Optional: Validate wiki content
echo "🔍 Content Validation:"
echo "====================="
echo ""

total_lines=0
for file in "$WIKI_DIR"/*.md; do
    if [[ -f "$file" ]]; then
        lines=$(wc -l < "$file")
        total_lines=$((total_lines + lines))
    fi
done

echo "Total documentation: $total_lines lines across $(ls "$WIKI_DIR"/*.md | wc -l) files"
echo ""

# Check for common issues
echo "Pre-flight Checks:"
echo "=================="

all_good=true

# Check for placeholder content
if grep -q "TODO\|FIXME\|PLACEHOLDER" "$WIKI_DIR"/*.md 2>/dev/null; then
    echo "⚠️  Warning: Found TODO/FIXME/PLACEHOLDER content in wiki files"
    all_good=false
fi

# Check for broken internal links
if grep -q "\](.*\.md)" "$WIKI_DIR"/*.md 2>/dev/null; then
    echo "⚠️  Warning: Found .md links that should be wiki links"
    all_good=false
fi

# Check for required files
required_files=("Home.md" "Quick-Start.md" "Development-Workflow.md")
for required_file in "${required_files[@]}"; do
    if [[ ! -f "$WIKI_DIR/$required_file" ]]; then
        echo "❌ Missing required file: $WIKI_DIR/$required_file"
        all_good=false
    fi
done

if $all_good; then
    echo "✅ All checks passed! Wiki content is ready to publish."
else
    echo "⚠️  Some issues found. Please review before publishing."
fi

echo ""
echo "🎉 Setup script completed!"
echo "Visit the wiki after setup: $REPO_URL/wiki"
