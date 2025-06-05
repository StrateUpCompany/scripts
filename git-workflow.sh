#!/usr/bin/env bash
#
# git-workflow.sh - Advanced Git workflow script with enhanced UX
# 
# Features:
# - Interactive menu for common Git operations
# - Pre-commit analysis of changes
# - File status visualization
# - Commit message templates
# - Branch management
# - Colorful UX with feedback
#
# Author: GitHub Copilot
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
    echo "  _____  _  _     __        __         _    __ _               "
    echo " / ____|(_)| |    \ \      / /__  _ __| | _/ _| | _____      __"
    echo "| |  __  _ | |_    \ \ /\ / / _ \| '__| |/ / _| |/ _ \ \ /\ / /"
    echo "| | |_ || || __|    \ V  V / (_) | |  |   <  _| | (_) \ V  V / "
    echo "| |__| || || |_      \_/\_/ \___/|_|  |_|\_\_| |_|\___/ \_/\_/  "
    echo " \_____|_/ \__|                                                "
    echo -e "${NC}"
    echo -e "${YELLOW}An advanced Git workflow script with thorough change analysis${NC}"
    echo -e "${CYAN}------------------------------------------------------------${NC}"
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

# Analysis function
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

# Commit helper
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
    
    # Ask for commit message with template
    echo -e "\n${PURPLE}Commit Message:${NC}"
    echo -e "${YELLOW}Format suggestion: <type>(<scope>): <subject>${NC}"
    echo -e "Examples: feat(auth): add login functionality"
    echo -e "          fix(api): correct response format"
    echo -e "          docs(readme): update installation section\n"
    
    read -p "Enter commit message: " commit_message
    
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
        echo "1. Analyze changes in detail"
        echo "2. Stage all changes"
        echo "3. Stage specific files"
        echo "4. Unstage files"
        echo "5. Commit staged changes"
        echo "6. Push commits"
        echo "7. Pull latest changes"
        echo "8. Branch management"
        echo "9. View commit history"
        echo "0. Exit"
        
        read -p "Choose an option: " choice
        
        case $choice in
            1)
                analyze_changes
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            2)
                git add .
                echo -e "${GREEN}All changes have been staged${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            3)
                echo -e "${YELLOW}Enter file paths to stage (space separated):${NC}"
                read -r files
                git add $files
                echo -e "${GREEN}Changes have been staged${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            4)
                echo -e "${YELLOW}Enter file paths to unstage (space separated):${NC}"
                read -r files
                git reset HEAD $files
                echo -e "${GREEN}Changes have been unstaged${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            5)
                commit_changes
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            6)
                push_changes
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            7)
                git pull
                echo -e "${GREEN}Pulled latest changes${NC}"
                echo -e "${YELLOW}Press Enter to continue${NC}"
                read
                ;;
            8)
                manage_branches
                ;;
            9)
                show_logs
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