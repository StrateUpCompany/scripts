#!/usr/bin/env bash
#
# smart-git-workflow.sh - Advanced Git workflow script with smart commit message generation
# 
# Features:
# - Automatic analysis of changes to generate meaningful commit messages
# - Interactive menu for common Git operations
# - Pre-commit analysis of changes
# - File status visualization
# - Branch management
# - Colorful UX with feedback
#
# Author: GitHub Copilot for StrateUpCompany
# Date: 2025-06-05

# Set up colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner function
show_banner() {
    clear
    echo -e "${BLUE}"
    echo "  _____                      _      _____  _  _   "
    echo " / ____|                    | |    / ____|| |(_)  "
    echo "| (___  _ __ ___   __ _ _ __| |_  | |  __ | | _  __ _ "
    echo " \___ \| '_ \` _ \ / _\` | '__| __| | | |_ || || |/ _\` |"
    echo " ____) | | | | | | (_| | |  | |_  | |__| || || | (_| |"
    echo "|_____/|_| |_| |_|\__,_|_|   \__|  \_____||_||_|\__,_|"
    echo -e "${NC}"
    echo -e "${YELLOW}Smart Git Workflow with Automated Commit Message Generation${NC}"
    echo -e "${CYAN}--------------------------------------------------------${NC}"
    echo -e "${GREEN}StrateUpCompany${NC}"
    echo -e "${CYAN}Current Date: $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo ""
}

# Check if git is installed
check_git() {
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: Git is not installed or not in PATH${NC}"
        exit 1
    fi
    
    # Check if inside a git repository
    if ! git rev-parse --is-inside-work-tree &> /dev/null; then
        echo -e "${RED}Error: Not inside a Git repository${NC}"
        echo -e "${YELLOW}Would you like to initialize a new repository? (y/n)${NC}"
        read -r answer
        if [[ "$answer" == "y" ]]; then
            git init
            echo -e "${GREEN}Repository initialized${NC}"
        else
            exit 1
        fi
    fi
}

# Status function with enhanced visualization
show_status() {
    echo -e "${CYAN}Current Git Status:${NC}"
    echo -e "${CYAN}------------------${NC}"

    # Branch information
    current_branch=$(git branch --show-current)
    echo -e "${PURPLE}Current branch:${NC} $current_branch"
    
    # Get remote tracking branch
    remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [ $? -eq 0 ]; then
        ahead_behind=$(git rev-list --left-right --count $current_branch...$remote_branch)
        ahead=$(echo $ahead_behind | awk '{print $1}')
        behind=$(echo $ahead_behind | awk '{print $2}')
        
        echo -e "${PURPLE}Remote tracking:${NC} $remote_branch"
        if [ "$ahead" -gt 0 ]; then
            echo -e "${YELLOW}Your branch is ahead by $ahead commit(s)${NC}"
        fi
        if [ "$behind" -gt 0 ]; then
            echo -e "${RED}Your branch is behind by $behind commit(s)${NC}"
        fi
    else
        echo -e "${YELLOW}No remote tracking branch${NC}"
    fi
    
    # Show status in a clean way
    echo -e "\n${PURPLE}Modified files:${NC}"
    git status -s | while read line; do
        status=$(echo "$line" | cut -c1-2)
        file=$(echo "$line" | cut -c4-)
        
        case $status in
            "M "*)
                echo -e "  ${GREEN}Modified:${NC} $file"
                ;;
            " M"*)
                echo -e "  ${RED}Modified (not staged):${NC} $file"
                ;;
            "A "*)
                echo -e "  ${GREEN}Added:${NC} $file"
                ;;
            "??"*)
                echo -e "  ${YELLOW}Untracked:${NC} $file"
                ;;
            "D "*)
                echo -e "  ${RED}Deleted:${NC} $file"
                ;;
            *) 
                echo -e "  $status $file"
                ;;
        esac
    done
    
    echo ""
}

# Enhanced analysis function for smart commit message generation
analyze_changes() {
    echo -e "${CYAN}Analyzing Changes:${NC}"
    echo -e "${CYAN}------------------${NC}"
    
    # Count files changed
    modified=$(git diff --name-only --cached | wc -l)
    not_staged=$(git diff --name-only | wc -l)
    untracked=$(git ls-files --others --exclude-standard | wc -l)
    
    echo -e "${GREEN}$modified${NC} files staged for commit"
    echo -e "${YELLOW}$not_staged${NC} files modified but not staged"
    echo -e "${RED}$untracked${NC} untracked files"
    
    # Show diff statistics
    echo -e "\n${PURPLE}Change statistics:${NC}"
    git diff --cached --stat
    
    # Check for potential issues
    echo -e "\n${PURPLE}Checking for potential issues:${NC}"
    
    # Check for large files
    large_files=$(git diff --cached --numstat | awk '$1 > 500 || $2 > 500 {print $3}')
    if [ ! -z "$large_files" ]; then
        echo -e "${YELLOW}Warning: Large files detected:${NC}"
        echo "$large_files" | while read file; do
            echo "  - $file"
        done
    fi
    
    # Check for trailing whitespace
    whitespace=$(git diff --cached --check)
    if [ ! -z "$whitespace" ]; then
        echo -e "${YELLOW}Warning: Trailing whitespace detected${NC}"
    fi
    
    # Check for conflict markers
    conflict_markers=$(git diff --cached | grep -E "^[<>=]{7}")
    if [ ! -z "$conflict_markers" ]; then
        echo -e "${RED}Error: Conflict markers detected in files${NC}"
    fi
    
    echo ""
}

# Function to analyze code changes and generate a commit message
generate_commit_message() {
    echo -e "${CYAN}Generating Smart Commit Message:${NC}"
    echo -e "${CYAN}-----------------------------${NC}"
    
    # Check if there are staged changes
    if [ "$(git diff --cached --name-only | wc -l)" -eq 0 ]; then
        echo -e "${YELLOW}No changes staged for commit.${NC}"
        return 1
    fi
    
    # Initialize variables
    commit_type=""
    commit_scope=""
    commit_subject=""
    
    # Get list of modified files
    modified_files=$(git diff --cached --name-only)
    
    # Determine file types being changed
    file_types=""
    num_files=$(echo "$modified_files" | wc -l)
    
    # Extract file extensions
    for file in $modified_files; do
        extension="${file##*.}"
        file_types="$file_types $extension"
    done
    
    # Count unique file extensions
    unique_extensions=$(echo "$file_types" | tr ' ' '\n' | sort | uniq | tr '\n' ' ')
    
    # Analyze the type of changes
    has_new_files=false
    has_deleted_files=false
    has_modified_files=false
    
    git diff --cached --name-status | while read line; do
        status=$(echo "$line" | cut -c1)
        case $status in
            "A") has_new_files=true ;;
            "D") has_deleted_files=true ;;
            "M") has_modified_files=true ;;
        esac
    done
    
    # Check for specific keywords in the diff to determine the nature of change
    diff_content=$(git diff --cached)
    
    if echo "$diff_content" | grep -q -i "fix\|bug\|issue\|error\|crash"; then
        commit_type="fix"
    elif echo "$diff_content" | grep -q -i "feat\|feature\|add\|implement"; then
        commit_type="feat"
    elif echo "$diff_content" | grep -q -i "test\|spec"; then
        commit_type="test"
    elif echo "$diff_content" | grep -q -i "docs\|documentation\|comment"; then
        commit_type="docs"
    elif echo "$diff_content" | grep -q -i "style\|format\|indent"; then
        commit_type="style"
    elif echo "$diff_content" | grep -q -i "refactor"; then
        commit_type="refactor"
    elif echo "$diff_content" | grep -q -i "perf\|performance\|optimize"; then
        commit_type="perf"
    elif echo "$diff_content" | grep -q -i "chore\|build\|ci"; then
        commit_type="chore"
    else
        # Default based on file operations
        if $has_new_files && ! $has_modified_files; then
            commit_type="feat"
        elif $has_modified_files; then
            commit_type="fix"
        else
            commit_type="chore"
        fi
    fi
    
    # Determine scope based on directories or file patterns
    directories_changed=$(git diff --cached --name-only | xargs -I{} dirname {} | sort | uniq)
    num_dirs=$(echo "$directories_changed" | wc -l)
    
    if [ "$num_dirs" -eq 1 ]; then
        # Single directory changed
        commit_scope=$(echo "$directories_changed" | awk -F/ '{print $NF}')
    elif echo "$modified_files" | grep -q "\.md$"; then
        # Documentation changes
        commit_scope="docs"
    elif echo "$modified_files" | grep -q "test\|spec"; then
        # Test changes
        commit_scope="tests"
    elif echo "$modified_files" | grep -q "package.json\|composer.json\|requirements.txt"; then
        # Dependency changes
        commit_scope="deps"
    else
        # Try to find the most common directory prefix
        commit_scope="core"
    fi
    
    # Generate commit subject based on the analysis
    if [ "$num_files" -eq 1 ]; then
        # Single file change - be more specific
        filename=$(echo "$modified_files" | head -1)
        basename=$(basename "$filename")
        
        if $has_new_files; then
            commit_subject="add new file $basename"
        elif $has_deleted_files; then
            commit_subject="remove $basename"
        else
            # Try to be more descriptive about the change
            if echo "$diff_content" | grep -q -i "fix\|bug\|issue\|error\|crash"; then
                commit_subject="fix issues in $basename"
            elif echo "$diff_content" | grep -q -i "add\|new\|feature"; then
                commit_subject="add new functionality to $basename"
            elif echo "$diff_content" | grep -q -i "refactor\|improve\|enhance"; then
                commit_subject="refactor $basename"
            else
                commit_subject="update $basename"
            fi
        fi
    else
        # Multiple files changed
        if $has_new_files && ! $has_modified_files && ! $has_deleted_files; then
            commit_subject="add new files"
        elif $has_deleted_files && ! $has_new_files && ! $has_modified_files; then
            commit_subject="remove files"
        elif $has_modified_files && ! $has_new_files && ! $has_deleted_files; then
            # Try to infer what kind of changes were made
            if echo "$diff_content" | grep -q -i "fix\|bug\|issue\|error\|crash"; then
                commit_subject="fix various issues"
            elif echo "$diff_content" | grep -q -i "add\|new\|feature"; then
                commit_subject="add new features"
            elif echo "$diff_content" | grep -q -i "refactor\|improve\|enhance"; then
                commit_subject="refactor code"
            elif echo "$diff_content" | grep -q -i "style\|format\|indent"; then
                commit_subject="improve code style"
            else
                commit_subject="update multiple files"
            fi
        else
            commit_subject="update codebase"
        fi
    fi
    
    # Generate full commit message
    suggestion="${commit_type}(${commit_scope}): ${commit_subject}"
    
    # Display details used to generate the message
    echo -e "${PURPLE}Analysis Details:${NC}"
    echo -e "  Files Changed: ${GREEN}$num_files${NC}"
    echo -e "  File Types: ${GREEN}$unique_extensions${NC}"
    echo -e "  Directories Changed: ${GREEN}$num_dirs${NC}"
    
    echo -e "\n${PURPLE}Suggested Commit Message:${NC}"
    echo -e "${GREEN}$suggestion${NC}"
    
    # Return the suggestion for use
    echo "$suggestion"
}

# Commit helper with smart message generation
commit_changes() {
    # If no staged changes, ask to stage
    if [ "$(git diff --cached --name-only | wc -l)" -eq 0 ]; then
        echo -e "${YELLOW}No changes staged for commit.${NC}"
        echo -e "Would you like to stage all changes? (y/n)"
        read -r answer
        if [[ "$answer" == "y" ]]; then
            git add .
        else
            echo "Please stage your changes first using 'git add <files>'"
            return 1
        fi
    fi
    
    # Show what's being committed
    echo -e "${CYAN}Files to be committed:${NC}"
    git diff --cached --name-only | while read file; do
        echo -e "  - $file"
    done
    
    # Generate smart commit message
    suggested_message=$(generate_commit_message)
    
    # Ask for commit message with template and suggestion
    echo -e "\n${PURPLE}Commit Message:${NC}"
    echo -e "${YELLOW}Suggested: ${suggested_message}${NC}"
    echo -e "Use suggested message? (y/n/e for edit)"
    read -r answer
    
    if [[ "$answer" == "y" ]]; then
        commit_message="$suggested_message"
    elif [[ "$answer" == "e" ]]; then
        echo -e "Edit the suggested message:"
        read -e -i "$suggested_message" commit_message
    else
        echo -e "Enter your own commit message:"
        read commit_message
    fi
    
    if [ -z "$commit_message" ]; then
        echo -e "${RED}Error: Commit message cannot be empty${NC}"
        return 1
    fi
    
    # Perform the commit
    git commit -m "$commit_message"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully committed changes${NC}"
        
        # Ask about pushing
        echo -e "\n${YELLOW}Would you like to push these changes? (y/n)${NC}"
        read -r answer
        if [[ "$answer" == "y" ]]; then
            push_changes
        fi
    else
        echo -e "${RED}Failed to commit changes${NC}"
    fi
}

# Deep analysis to understand content changes
deep_analyze() {
    echo -e "${CYAN}Deep Analysis of Changes:${NC}"
    echo -e "${CYAN}-----------------------${NC}"
    
    # Check if there are staged changes
    if [ "$(git diff --cached --name-only | wc -l)" -eq 0 ]; then
        echo -e "${YELLOW}No changes staged for deep analysis.${NC}"
        return 1
    fi
    
    # Get the list of changed files
    changed_files=$(git diff --cached --name-only)
    
    # Analyze each file
    echo -e "${PURPLE}File-by-File Analysis:${NC}"
    
    for file in $changed_files; do
        echo -e "\n${YELLOW}Analyzing: ${file}${NC}"
        
        # Get file extension
        extension="${file##*.}"
        
        # Get diff for this file
        file_diff=$(git diff --cached --unified=0 "$file")
        
        # Count lines added/removed
        added_lines=$(echo "$file_diff" | grep -c "^\+[^+]")
        removed_lines=$(echo "$file_diff" | grep -c "^-[^-]")
        
        echo -e "  Lines Added: ${GREEN}$added_lines${NC}"
        echo -e "  Lines Removed: ${RED}$removed_lines${NC}"
        
        # Analyze content based on file type
        case "$extension" in
            js|jsx|ts|tsx)
                echo -e "  ${PURPLE}JavaScript/TypeScript Analysis:${NC}"
                # Check for function changes
                functions_added=$(echo "$file_diff" | grep -c "^\+.*function")
                functions_removed=$(echo "$file_diff" | grep -c "^-.*function")
                if [ $functions_added -gt 0 ] || [ $functions_removed -gt 0 ]; then
                    echo -e "  ${CYAN}Functions: +$functions_added / -$functions_removed${NC}"
                fi
                
                # Check for component changes (React)
                components=$(echo "$file_diff" | grep -E "^\+.*class .* extends React|^\+.*const .* = \(.*\) =>")
                if [ ! -z "$components" ]; then
                    echo -e "  ${CYAN}Components modified or added${NC}"
                fi
                ;;
                
            py)
                echo -e "  ${PURPLE}Python Analysis:${NC}"
                # Check for function/class changes
                functions_added=$(echo "$file_diff" | grep -c "^\+.*def ")
                classes_added=$(echo "$file_diff" | grep -c "^\+.*class ")
                if [ $functions_added -gt 0 ] || [ $classes_added -gt 0 ]; then
                    echo -e "  ${CYAN}Functions: +$functions_added, Classes: +$classes_added${NC}"
                fi
                ;;
                
            go)
                echo -e "  ${PURPLE}Go Analysis:${NC}"
                # Check for function changes
                functions_added=$(echo "$file_diff" | grep -c "^\+.*func ")
                if [ $functions_added -gt 0 ]; then
                    echo -e "  ${CYAN}Functions: +$functions_added${NC}"
                fi
                ;;
                
            java|kt)
                echo -e "  ${PURPLE}Java/Kotlin Analysis:${NC}"
                # Check for class/method changes
                classes_added=$(echo "$file_diff" | grep -c "^\+.*class ")
                methods_added=$(echo "$file_diff" | grep -c "^\+.*public.*(.*).*{")
                if [ $classes_added -gt 0 ] || [ $methods_added -gt 0 ]; then
                    echo -e "  ${CYAN}Classes: +$classes_added, Methods: +$methods_added${NC}"
                fi
                ;;
                
            php)
                echo -e "  ${PURPLE}PHP Analysis:${NC}"
                # Check for function/class changes
                functions_added=$(echo "$file_diff" | grep -c "^\+.*function ")
                classes_added=$(echo "$file_diff" | grep -c "^\+.*class ")
                if [ $functions_added -gt 0 ] || [ $classes_added -gt 0 ]; then
                    echo -e "  ${CYAN}Functions: +$functions_added, Classes: +$classes_added${NC}"
                fi
                ;;
                
            html|css|scss|less)
                echo -e "  ${PURPLE}Frontend Analysis:${NC}"
                # Check for selector changes
                selectors_added=$(echo "$file_diff" | grep -c "^\+.*{")
                if [ $selectors_added -gt 0 ]; then
                    echo -e "  ${CYAN}Selectors: +$selectors_added${NC}"
                fi
                ;;
                
            md|txt)
                echo -e "  ${PURPLE}Documentation Analysis:${NC}"
                # Check for header changes
                headers_added=$(echo "$file_diff" | grep -c "^\+.*#")
                if [ $headers_added -gt 0 ]; then
                    echo -e "  ${CYAN}Sections: +$headers_added${NC}"
                fi
                ;;
                
            *)
                echo -e "  ${PURPLE}General Analysis:${NC}"
                # Check for significant keywords
                keywords=$(echo "$file_diff" | grep -E "^\+.*(TODO|FIXME|BUG|HACK|NOTE|IMPORTANT|FIX|ISSUE)")
                if [ ! -z "$keywords" ]; then
                    echo -e "  ${CYAN}Important Keywords Detected${NC}"
                    echo "$keywords" | head -3 | sed 's/^/    /'
                    if [ $(echo "$keywords" | wc -l) -gt 3 ]; then
                        echo "    ..."
                    fi
                fi
                ;;
        esac
    done
    
    echo -e "\n${YELLOW}Press Enter to continue${NC}"
    read
}

# Push helper
push_changes() {
    current_branch=$(git branch --show-current)
    
    # Check if branch exists on remote
    if git ls-remote --exit-code --heads origin $current_branch &>/dev/null; then
        git push
    else
        echo -e "${YELLOW}Branch $current_branch doesn't exist on remote.${NC}"
        echo -e "Would you like to push and set upstream? (y/n)"
        read -r answer
        if [[ "$answer" == "y" ]]; then
            git push --set-upstream origin $current_branch
        else
            echo -e "${YELLOW}Skipping push${NC}"
        fi
    fi
}

# Branch management
manage_branches() {
    show_banner
    echo -e "${CYAN}Branch Management:${NC}"
    echo -e "${CYAN}-----------------${NC}"
    
    # Show current branch
    current_branch=$(git branch --show-current)
    echo -e "${PURPLE}Current branch:${NC} $current_branch"
    
    # Show local branches
    echo -e "\n${PURPLE}Local branches:${NC}"
    git branch | while read branch; do
        if [[ $branch == "*"* ]]; then
            echo -e "${GREEN}$branch${NC}"
        else
            echo "  $branch"
        fi
    done
    
    echo -e "\n${CYAN}Branch Actions:${NC}"
    echo "1. Create new branch"
    echo "2. Switch to branch"
    echo "3. Delete branch"
    echo "4. Return to main menu"
    read -p "Choose an option: " choice
    
    case $choice in
        1)
            read -p "Enter new branch name: " branch_name
            git checkout -b $branch_name
            echo -e "${GREEN}Created and switched to branch $branch_name${NC}"
            ;;
        2)
            read -p "Enter branch name to switch to: " branch_name
            git checkout $branch_name
            ;;
        3)
            read -p "Enter branch name to delete: " branch_name
            if [ "$branch_name" == "$current_branch" ]; then
                echo -e "${RED}Cannot delete the current branch${NC}"
            else
                git branch -d $branch_name
                if [ $? -ne 0 ]; then
                    echo -e "${YELLOW}Branch not fully merged. Force delete? (y/n)${NC}"
                    read -r answer
                    if [[ "$answer" == "y" ]]; then
                        git branch -D $branch_name
                    fi
                fi
            fi
            ;;
        *)
            echo "Returning to main menu"
            ;;
    esac
}

# Show logs with better visualization
show_logs() {
    echo -e "${CYAN}Recent Commit History:${NC}"
    echo -e "${CYAN}---------------------${NC}"
    
    git log --oneline --graph --decorate -n 10
    
    echo -e "\n${YELLOW}Press Enter to return to menu${NC}"
    read
}

# Main menu
main_menu() {
    while true; do
        show_banner
        show_status
        
        echo -e "${CYAN}Available Actions:${NC}"
        echo "1. Smart analyze changes and suggest commit message"
        echo "2. Deep analyze content changes"
        echo "3. Stage all changes"
        echo "4. Stage specific files"
        echo "5. Unstage files"
        echo "6. Commit with smart message"
        echo "7. Push commits"
        echo "8. Pull latest changes"
        echo "9. Branch management"
        echo "0. Exit"
        
        read -p "Choose an option: " choice
        
        case $choice in
            1)
                generate_commit_message
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            2)
                deep_analyze
                ;;
            3)
                git add .
                echo -e "${GREEN}All changes have been staged${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            4)
                echo -e "${YELLOW}Enter file paths to stage (space separated):${NC}"
                read -r files
                git add $files
                echo -e "${GREEN}Changes have been staged${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            5)
                echo -e "${YELLOW}Enter file paths to unstage (space separated):${NC}"
                read -r files
                git reset HEAD $files
                echo -e "${GREEN}Changes have been unstaged${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            6)
                commit_changes
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            7)
                push_changes
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            8)
                git pull
                echo -e "${GREEN}Pulled latest changes${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            9)
                manage_branches
                ;;
            0)
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Press Enter to continue.${NC}"
                read
                ;;
        esac
    done
}

# Start the script
check_git
main_menu