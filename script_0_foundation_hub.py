#!/usr/bin/env python3
"""
Agent Zero Foundation Hub - Script 0
------------------------------------
This script serves as the central controller and documentation for the entire
Agent Zero implementation for marketing automation. It provides:
1. Project documentation
2. Setup verification
3. Script execution control
4. Troubleshooting assistance
5. Git automation

Author: StratUpCompany
Date: 2025-06-05
"""

import os
import sys
import subprocess
import json
import datetime
import readline
import colorama
from colorama import Fore, Style
import questionary
from rich.console import Console
from rich.markdown import Markdown
from rich import print as rprint
from rich.panel import Panel

# Initialize colorama
colorama.init()

console = Console()

# Configuration
CONFIG_FILE = "agent_zero_config.json"
SCRIPTS_DIR = "scripts"
DEFAULT_CONFIG = {
    "project_name": "agent-zero-marketing",
    "git_info": {
        "repository": "",
        "username": "",
        "email": ""
    },
    "api_keys": {
        "openai": "",
        "notion": "",
        "instagram": "",
        "tiktok": "",
        "youtube": ""
    },
    "installed_scripts": [],
    "environment_ready": False
}

def create_directory_if_not_exists(directory):
    """Create directory if it doesn't exist"""
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"{Fore.GREEN}✓ Created directory: {directory}{Style.RESET_ALL}")

def load_config():
    """Load configuration from file or create default if not exists"""
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    else:
        return DEFAULT_CONFIG

def save_config(config):
    """Save configuration to file"""
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=4)
    print(f"{Fore.GREEN}✓ Configuration saved{Style.RESET_ALL}")

def git_automation(config, script_name):
    """Automate git operations for the executed script"""
    if not config["git_info"]["repository"]:
        setup_git_info(config)
        
    repo_path = config["git_info"]["repository"]
    if not os.path.exists(os.path.join(repo_path, ".git")):
        # Initialize git repository if not exists
        subprocess.run(["git", "init"], cwd=repo_path)
        subprocess.run(["git", "config", "user.name", config["git_info"]["username"]], cwd=repo_path)
        subprocess.run(["git", "config", "user.email", config["git_info"]["email"]], cwd=repo_path)
        
    # Add and commit changes
    message = f"Executed {script_name} on {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    subprocess.run(["git", "add", "."], cwd=repo_path)
    subprocess.run(["git", "commit", "-m", message], cwd=repo_path)
    print(f"{Fore.GREEN}✓ Git commit created: {message}{Style.RESET_ALL}")

def setup_git_info(config):
    """Set up git information"""
    print(f"\n{Fore.CYAN}Git Configuration Setup{Style.RESET_ALL}")
    config["git_info"]["repository"] = questionary.text("Enter local git repository path:").ask()
    config["git_info"]["username"] = questionary.text("Enter your git username:").ask()
    config["git_info"]["email"] = questionary.text("Enter your git email:").ask()
    save_config(config)

def display_welcome():
    """Display welcome message and project information"""
    welcome_text = """
    # Agent Zero Marketing Automation Suite

    Welcome to the Agent Zero Marketing Automation implementation tool. This central hub
    manages the setup, configuration, and execution of your marketing automation agents.
    
    ## What is Agent Zero?
    
    Agent Zero is an AI framework for building autonomous agents. This implementation focuses on:
    
    - SDR (Sales Development Representative) agents for call handling
    - Social media content creation and publishing
    - Analytics and performance tracking
    - Notion integration for knowledge management
    - SEO optimization and trending topic analysis
    
    ## Available Scripts
    
    The implementation is divided into 12 interconnected scripts, each building on the previous one:
    
    0. Foundation Hub (This script)
    1. Environment Builder
    2. Core Framework Setup
    3. Data Layer
    4. Integration Gateway
    5. SDR Agent
    6. Content Creator Agent
    7. Analytics Engine
    8. Orchestration Layer
    9. Frontend Dashboard
    10. Security & Authentication
    11. Deployment & Scaling
    
    ## Getting Started
    
    Run this script to manage and execute the other scripts in sequence. Each script will:
    1. Check prerequisites
    2. Install required dependencies
    3. Configure necessary components
    4. Automatically commit changes to git
    
    ## Support
    
    If you encounter issues, use the troubleshooting option in the main menu.
    """
    
    console.print(Markdown(welcome_text))

def check_environment():
    """Check if the environment has all necessary components installed"""
    requirements = ["python", "pip", "git", "node", "npm"]
    missing = []
    
    for req in requirements:
        try:
            subprocess.run([req, "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        except (subprocess.CalledProcessError, FileNotFoundError):
            missing.append(req)
            
    return missing

def install_script_dependencies():
    """Install dependencies for this script"""
    try:
        subprocess.run([sys.executable, "-m", "pip", "install", "colorama", "questionary", "rich"], check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def prepare_script(script_number, config):
    """Prepare and create the next script file"""
    script_content = get_script_content(script_number)
    script_filename = f"script_{script_number}_{script_content['name'].lower().replace(' ', '_')}.py"
    
    create_directory_if_not_exists(SCRIPTS_DIR)
    script_path = os.path.join(SCRIPTS_DIR, script_filename)
    
    with open(script_path, 'w') as f:
        f.write(script_content["content"])
    
    # Make the script executable
    os.chmod(script_path, 0o755)
    
    # Update config to track installed scripts
    if script_filename not in config["installed_scripts"]:
        config["installed_scripts"].append(script_filename)
        save_config(config)
    
    print(f"{Fore.GREEN}✓ Created script: {script_filename}{Style.RESET_ALL}")
    return script_path

def get_script_content(script_number):
    """Get the content for a specific script"""
    # This would contain templates for all scripts
    # For this example, I'll just include a placeholder for script 1
    
    if script_number == 1:
        return {
            "name": "Environment Builder",
            "content": """#!/usr/bin/env python3
\"\"\"
Environment Builder - Script 1
------------------------------
Sets up the development environment for Agent Zero implementation.
Installs required dependencies, configures virtual environment,
and verifies system requirements.

Author: StratUpCompany
Date: 2025-06-05
\"\"\"

import os
import sys
import subprocess
import json
import platform
from pathlib import Path
import questionary

# Load configuration
CONFIG_FILE = "agent_zero_config.json"

def load_config():
    \"\"\"Load configuration from file\"\"\"
    with open(CONFIG_FILE, 'r') as f:
        return json.load(f)

def save_config(config):
    \"\"\"Save configuration to file\"\"\"
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=4)
    print("✅ Configuration saved")

def check_python_version():
    \"\"\"Verify Python version is 3.8+\"\"\"
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("❌ Python 3.8+ is required")
        return False
    print(f"✅ Python version {version.major}.{version.minor}.{version.micro} detected")
    return True

def setup_virtual_environment():
    \"\"\"Create and activate virtual environment\"\"\"
    venv_path = Path("venv")
    if not venv_path.exists():
        print("Creating virtual environment...")
        subprocess.run([sys.executable, "-m", "venv", "venv"], check=True)
    
    # Provide activation instructions
    if platform.system() == "Windows":
        print("✅ To activate virtual environment, run: venv\\\\Scripts\\\\activate")
    else:
        print("✅ To activate virtual environment, run: source venv/bin/activate")
    
    return True

def install_core_dependencies():
    \"\"\"Install core dependencies\"\"\"
    dependencies = [
        "numpy",
        "pandas",
        "requests",
        "fastapi",
        "uvicorn",
        "pydantic",
        "sqlalchemy",
        "pytest",
        "python-dotenv",
        "transformers",
        "torch",
        "langchain",
        "openai",
        "notion-client"
    ]
    
    print("Installing core dependencies...")
    try:
        subprocess.run([
            sys.executable, "-m", "pip", "install", 
            "--upgrade", "pip"
        ], check=True)
        
        subprocess.run([
            sys.executable, "-m", "pip", "install", 
            *dependencies
        ], check=True)
        
        print("✅ Core dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error installing dependencies: {e}")
        return False

def setup_project_structure():
    \"\"\"Create project directory structure\"\"\"
    directories = [
        "src/agents",
        "src/core",
        "src/integrations",
        "src/utils",
        "src/frontend",
        "src/backend",
        "config",
        "data",
        "tests",
        "docs"
    ]
    
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
        print(f"✅ Created directory: {directory}")
    
    return True

def git_automation(script_name):
    \"\"\"Automate git operations\"\"\"
    config = load_config()
    repo_path = config["git_info"]["repository"]
    
    # Add and commit changes
    try:
        subprocess.run(["git", "add", "."], cwd=repo_path, check=True)
        subprocess.run([
            "git", "commit", "-m", f"Script 1: Environment setup completed"
        ], cwd=repo_path, check=True)
        print("✅ Changes committed to git")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Git operation failed: {e}")
        return False

def main():
    \"\"\"Main execution function\"\"\"
    print("🚀 Starting Environment Builder - Script 1")
    
    # Load configuration
    config = load_config()
    
    # Check Python version
    if not check_python_version():
        sys.exit(1)
    
    # Setup virtual environment
    if not setup_virtual_environment():
        sys.exit(1)
    
    # Install dependencies
    if not install_core_dependencies():
        sys.exit(1)
    
    # Setup project structure
    if not setup_project_structure():
        sys.exit(1)
    
    # Update configuration
    config["environment_ready"] = True
    save_config(config)
    
    # Git automation
    git_automation("Environment Builder")
    
    print("✅ Environment setup completed successfully")
    print("➡️ You can now proceed with Script 2: Core Framework Setup")

if __name__ == "__main__":
    main()
"""
        }
    # You would define templates for scripts 2-11 here
    return {"name": "Unknown", "content": "# Script content not defined"}

def troubleshooting():
    """Provide troubleshooting assistance"""
    common_issues = [
        "Environment setup failed",
        "API integration errors",
        "Database connection issues",
        "Agent communication problems",
        "Social media authentication failed",
        "Git automation errors",
        "Script dependency issues",
        "Other issue"
    ]
    
    issue = questionary.select(
        "What issue are you experiencing?",
        choices=common_issues
    ).ask()
    
    solutions = {
        "Environment setup failed": """
        # Environment Setup Troubleshooting
        
        1. Ensure you have Python 3.8+ installed
        2. Make sure pip is updated: `python -m pip install --upgrade pip`
        3. Check that you have sufficient permissions to install packages
        4. Try running Script 1 with administrator/sudo privileges
        5. Verify your internet connection to download packages
        """,
        
        "API integration errors": """
        # API Integration Troubleshooting
        
        1. Verify your API keys are correctly set in the configuration
        2. Check if the API service is operational
        3. Ensure your API request format matches the documentation
        4. Check for rate limiting or quota issues
        5. Verify network connectivity to the API endpoints
        """,
        
        "Database connection issues": """
        # Database Connection Troubleshooting
        
        1. Check database credentials in your configuration
        2. Ensure the database server is running
        3. Verify network connectivity to the database
        4. Check if the database schema has been created correctly
        5. Ensure you have the correct permissions for database operations
        """,
        
        "Agent communication problems": """
        # Agent Communication Troubleshooting
        
        1. Verify the orchestration layer is running
        2. Check if all agents are properly initialized
        3. Ensure message formats between agents are consistent
        4. Look for timeout errors in communication logs
        5. Verify that the message broker (if used) is operational
        """,
        
        "Social media authentication failed": """
        # Social Media Authentication Troubleshooting
        
        1. Verify API keys and tokens are correctly configured
        2. Check if tokens have expired and need refresh
        3. Ensure your app has the required permissions
        4. Verify callback URLs are correctly configured
        5. Check for API changes that might affect authentication
        """,
        
        "Git automation errors": """
        # Git Automation Troubleshooting
        
        1. Ensure git is installed and available in PATH
        2. Check if the repository path is correct in configuration
        3. Verify git credentials are correctly set
        4. Resolve any merge conflicts that might exist
        5. Check if you have write permissions to the repository
        """,
        
        "Script dependency issues": """
        # Script Dependency Troubleshooting
        
        1. Run `pip install -r requirements.txt` to reinstall dependencies
        2. Check Python version compatibility with libraries
        3. Look for conflicts between package versions
        4. Try creating a new virtual environment
        5. Update pip and setuptools: `pip install --upgrade pip setuptools`
        """,
        
        "Other issue": """
        # General Troubleshooting
        
        1. Check logs in the 'logs' directory
        2. Verify all configuration settings
        3. Ensure system meets minimum requirements
        4. Try running scripts with --debug flag for verbose output
        5. Check for updates to the Agent Zero framework
        """
    }
    
    if issue in solutions:
        console.print(Markdown(solutions[issue]))
    else:
        print("No specific troubleshooting information available for this issue.")

def main():
    """Main function to run the script"""
    # Ensure we have our own dependencies
    if not install_script_dependencies():
        print(f"{Fore.RED}Failed to install script dependencies. Please install manually:{Style.RESET_ALL}")
        print("pip install colorama questionary rich")
        sys.exit(1)

    # Load or create configuration
    config = load_config()
    
    # Display welcome information
    display_welcome()
    
    # Check if environment is ready
    missing_tools = check_environment()
    if missing_tools:
        print(f"{Fore.YELLOW}Warning: The following tools are missing and need to be installed:{Style.RESET_ALL}")
        for tool in missing_tools:
            print(f"- {tool}")
        print("\nPlease install these tools before proceeding.")
    
    while True:
        action = questionary.select(
            "What would you like to do?",
            choices=[
                "Execute next script",
                "View documentation",
                "Set up git information",
                "Configure API keys",
                "Troubleshooting",
                "Exit"
            ]
        ).ask()
        
        if action == "Execute next script":
            next_script_num = len(config["installed_scripts"]) + 1
            if next_script_num <= 11:  # We have scripts 0-11, total 12
                print(f"{Fore.CYAN}Preparing Script {next_script_num}...{Style.RESET_ALL}")
                script_path = prepare_script(next_script_num, config)
                
                # Execute the script
                if questionary.confirm(f"Do you want to execute Script {next_script_num} now?").ask():
                    subprocess.run([sys.executable, script_path], check=True)
                    git_automation(config, f"Script {next_script_num}")
            else:
                print(f"{Fore.GREEN}All scripts have been installed!{Style.RESET_ALL}")
                
        elif action == "View documentation":
            display_welcome()
            
        elif action == "Set up git information":
            setup_git_info(config)
            
        elif action == "Configure API keys":
            print(f"\n{Fore.CYAN}API Key Configuration{Style.RESET_ALL}")
            for key in config["api_keys"]:
                config["api_keys"][key] = questionary.password(f"Enter {key} API key:").ask()
            save_config(config)
            
        elif action == "Troubleshooting":
            troubleshooting()
            
        elif action == "Exit":
            print(f"{Fore.GREEN}Thank you for using Agent Zero Setup. Goodbye!{Style.RESET_ALL}")
            break

if __name__ == "__main__":
    main()