#!/bin/bash
set -euo pipefail
script_dirpath="$(cd "$(dirname "${0}")" && pwd)"

echo "🚀 Go CLI Tool Template Configuration"
echo "====================================="
echo ""

# Function to validate input is not empty
validate_input() {
    local input="${1}"
    if [[ -z "${input}" ]]; then
        echo "❌ Error: Input cannot be empty"
        return 1
    fi
    return 0
}

# Function to validate GitHub username format
validate_github_username() {
    local username="${1}"
    if [[ ! "${username}" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
        echo "❌ Error: Invalid GitHub username format"
        return 1
    fi
    return 0
}

# Function to validate CLI name format (should be suitable for binary name)
validate_cli_name() {
    local name="${1}"
    if [[ ! "${name}" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo "❌ Error: CLI name should only contain letters, numbers, and hyphens"
        return 1
    fi
    return 0
}

# Auto-detect Git information
echo "🔍 Auto-detecting Git repository information..."

# Try to get remote URL and extract username/repo
git_remote_url=$(git remote get-url origin 2>/dev/null || echo "")
github_username=""
repo_name=""

if [[ "${git_remote_url}" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
    github_username="${BASH_REMATCH[1]}"
    repo_name="${BASH_REMATCH[2]}"
    echo "✅ Detected GitHub repository: ${github_username}/${repo_name}"
else
    echo "⚠️  Could not auto-detect GitHub repository from git remote."
    echo ""
    echo "Please provide the following information:"
    echo ""
    
    # GitHub username
    while true; do
        read -p "📝 Your GitHub username (e.g., 'johndoe'): " github_username
        if validate_input "${github_username}" && validate_github_username "${github_username}"; then
            break
        fi
    done

    # Repository name
    while true; do
        read -p "📝 The name of this repository (e.g., 'my-awesome-tool'): " repo_name
        if validate_input "${repo_name}" && validate_cli_name "${repo_name}"; then
            break
        fi
    done
fi

# CLI binary name
echo ""
echo "💡 The CLI binary name is what users will type to run your tool."
echo "   It can be the same as your repository name or different."
while true; do
    read -p "📝 CLI binary name (e.g., 'mytool'): " cli_name
    if validate_input "${cli_name}" && validate_cli_name "${cli_name}"; then
        break
    fi
done

# Homebrew tap repository name
echo ""
echo "🍺 Homebrew Tap Repository Setup"
echo "   You must first create a Homebrew tap repository on GitHub before proceeding."
echo ""
echo "   ⚠️  IMPORTANT: Create this repository on GitHub first!"
echo "   - Go to GitHub and create a new public repository"
echo "   - Name it 'homebrew-tap' (recommended) or 'homebrew-<something>'"
echo "   - Initialize with a README (GoReleaser will manage the Formula)"
echo ""
echo "   💡 We strongly recommend using 'homebrew-tap' as your repository name."
echo "      This is the standard convention and makes it easy for users to find."
echo ""

read -p "📝 Homebrew tap repository name (default: 'homebrew-tap', press Enter to use): " tap_input

if [[ -z "${tap_input}" ]]; then
    tap_name="homebrew-tap"
    echo "   ✅ Using recommended default: ${github_username}/homebrew-tap"
else
    # Use exactly what the user entered
    tap_name="${tap_input}"
    echo "   ✅ Will use repository: ${github_username}/${tap_name}"
fi

# Optional: CLI description
read -p "📝 CLI description (optional, press Enter to skip): " cli_description
if [[ -z "${cli_description}" ]]; then
    cli_description="A CLI tool built with Go and Cobra"
fi

echo ""
echo "📋 Configuration Summary:"
echo "========================"
echo "GitHub Username: ${github_username}"
echo "GitHub Repository Name: ${repo_name}"
echo "CLI Binary Name: ${cli_name}"
echo "Homebrew Tap Repository Name: ${tap_name}"
echo "Description: ${cli_description}"
echo ""

read -p "✅ Does this look correct? (y/N): " confirm
if [[ ! "${confirm}" =~ ^[Yy]$ ]]; then
    echo "❌ Configuration cancelled."
    exit 1
fi

echo ""
echo "🔧 Applying configuration..."

# Create the module path
module_path="github.com/${github_username}/${repo_name}"

# List of files to update
files_to_update=(
    "go.mod"
    "main.go"
    "cmd/root.go"
    "cmd/version.go"
    "build.sh"
    ".goreleaser.yaml"
)

# Perform replacements
for file in "${files_to_update[@]}"; do
    if [[ -f "${script_dirpath}/${file}" ]]; then
        echo "  📝 Updating ${file}..."
        
        # Use temporary file for safe replacement
        temp_file=$(mktemp)
        
        # Perform all replacements
        sed -e "s|github.com/TEMPLATE_USERNAME/TEMPLATE_CLI_NAME|${module_path}|g" \
            -e "s|TEMPLATE_USERNAME|${github_username}|g" \
            -e "s|TEMPLATE_CLI_NAME|${cli_name}|g" \
            -e "s|TEMPLATE_TAP_NAME|${tap_name}|g" \
            -e "s|TEMPLATE_REPO_NAME|${repo_name}|g" \
            -e "s|A CLI tool built with Go and Cobra|${cli_description}|g" \
            "${script_dirpath}/${file}" > "${temp_file}"
        
        # Replace original file
        mv "${temp_file}" "${script_dirpath}/${file}"
    else
        echo "  ⚠️  Warning: ${file} not found, skipping..."
    fi
done

# Clean up go.mod
echo "  🧹 Cleaning up Go modules..."
cd "${script_dirpath}"
go mod tidy > /dev/null 2>&1 || echo "  ⚠️  Warning: go mod tidy failed, you may need to run it manually"

echo ""
echo "✅ Configuration complete!"
echo ""
echo "🎯 Next Steps:"
echo "=============="
echo "1. Review the updated files to ensure everything looks correct"
echo "2. Test your CLI locally:"
echo "   ./build.sh"
echo "   ./build/${cli_name} --help"
echo ""
echo "3. For releases and Homebrew distribution, complete the manual setup tasks:"
echo "   📋 See TODO.md for detailed instructions"
echo ""
echo "4. When ready to make your first release:"
echo "   git add ."
echo "   git commit -m \"feat: initial CLI implementation\""
echo "   git tag v0.1.0"
echo "   git push origin main --tags"
echo ""
echo "🎉 Happy coding!"
