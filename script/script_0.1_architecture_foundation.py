#!/usr/bin/env python3
"""
Architecture Foundation - Script 0.1
------------------------------------
Prepares the specific architecture needed for Agent Zero implementation.
Creates detailed scaffolding, installs specialized dependencies,
and configures the messaging infrastructure required for agent communication.

Author: StratUpCompany
Date: 2025-06-05
"""

import os
import sys
import subprocess
import json
import platform
from pathlib import Path
import shutil
import questionary
from rich.console import Console
from rich.panel import Panel
from rich.markdown import Markdown

console = Console()

# Configuration
CONFIG_FILE = "agent_zero_config.json"
SCRIPTS_DIR = "scripts"
TEMPLATES_DIR = "templates"

def load_config():
    """Load configuration from file"""
    with open(CONFIG_FILE, 'r') as f:
        return json.load(f)

def save_config(config):
    """Save configuration to file"""
    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=4)
    console.print("[green]✓ Configuration saved[/green]")

def create_directory_if_not_exists(directory):
    """Create directory if it doesn't exist"""
    if not os.path.exists(directory):
        os.makedirs(directory)
        console.print(f"[green]✓ Created directory: {directory}[/green]")

def install_specialized_dependencies():
    """Install specialized dependencies for agent architecture"""
    # Libraries for agent framework
    agent_libs = [
        "pydantic",           # Data validation
        "fastapi",            # API framework
        "uvicorn",            # ASGI server
        "langchain",          # Language model tools
        "openai",             # OpenAI API
    ]
    
    # Libraries for message bus and communication
    messaging_libs = [
        "redis",              # For pub/sub messaging
        "pika",               # For RabbitMQ
        "pyzmq",              # For ZeroMQ
        "websockets",         # For WebSocket communication
        "aio-pika",           # Async RabbitMQ
    ]
    
    # Libraries for monitoring and logging
    monitoring_libs = [
        "prometheus-client",  # Metrics
        "opentelemetry-api",  # Telemetry
        "opentelemetry-sdk",  # Telemetry
        "structlog",          # Structured logging
        "python-json-logger", # JSON logging
    ]
    
    # Libraries for storage and state management
    storage_libs = [
        "sqlalchemy",         # ORM
        "alembic",            # DB migrations
        "pymongo",            # MongoDB
        "motor",              # Async MongoDB
        "diskcache",          # Disk-based cache
    ]
    
    # Libraries for social media and external APIs
    api_libs = [
        "tweepy",             # Twitter API
        "facebook-sdk",       # Facebook API
        "google-api-python-client", # Google APIs
        "python-instagram",   # Instagram API  
        "notion-client",      # Notion API
        "pytiktok",           # TikTok API
    ]
    
    # Combine all libraries
    all_libs = agent_libs + messaging_libs + monitoring_libs + storage_libs + api_libs
    
    # Present library selections to user
    console.print(Panel("[bold blue]Specialized Dependencies Installation[/bold blue]"))
    console.print("The following specialized libraries are recommended for Agent Zero:")
    
    # Group libraries by category
    categories = {
        "Agent Framework": agent_libs,
        "Messaging & Communication": messaging_libs,
        "Monitoring & Logging": monitoring_libs,
        "Storage & State Management": storage_libs,
        "Social Media & External APIs": api_libs
    }
    
    # Display and select libraries by category
    selected_libs = []
    
    for category, libs in categories.items():
        console.print(f"\n[yellow]{category}[/yellow]")
        selected = questionary.checkbox(
            f"Select {category} libraries to install:",
            choices=libs
        ).ask()
        selected_libs.extend(selected)
    
    if not selected_libs:
        console.print("[yellow]No libraries selected. Skipping installation.[/yellow]")
        return True
    
    # Install selected libraries
    console.print("\n[bold]Installing selected libraries...[/bold]")
    try:
        # Use pip to install the libraries
        subprocess.run([
            sys.executable, "-m", "pip", "install", 
            *selected_libs
        ], check=True)
        
        # Save the installed libraries to requirements.txt
        with open("requirements.txt", "a") as f:
            for lib in selected_libs:
                f.write(f"{lib}\n")
        
        console.print("[green]✓ Specialized dependencies installed successfully[/green]")
        return True
    except subprocess.CalledProcessError as e:
        console.print(f"[red]✗ Error installing dependencies: {e}[/red]")
        return False

def setup_messaging_infrastructure():
    """Set up the messaging infrastructure for agent communication"""
    console.print(Panel("[bold blue]Messaging Infrastructure Setup[/bold blue]"))
    
    # Ask the user which messaging system they want to use
    messaging_system = questionary.select(
        "Select a messaging system for agent communication:",
        choices=[
            "Redis Pub/Sub",
            "RabbitMQ",
            "ZeroMQ",
            "In-memory (for development)",
            "Skip (configure later)"
        ]
    ).ask()
    
    if messaging_system == "Skip (configure later)":
        console.print("[yellow]Messaging setup skipped. You'll need to configure this later.[/yellow]")
        return True
    
    # Create configuration directory
    create_directory_if_not_exists("config")
    
    # Create messaging configuration based on selection
    messaging_config = {
        "system": messaging_system,
        "config": {}
    }
    
    if messaging_system == "Redis Pub/Sub":
        messaging_config["config"] = {
            "host": questionary.text("Redis host:", default="localhost").ask(),
            "port": questionary.text("Redis port:", default="6379").ask(),
            "db": "0",
            "password": questionary.password("Redis password (leave empty if none):").ask() or None
        }
        
        # Check if Docker is available and offer to setup Redis
        try:
            subprocess.run(["docker", "--version"], stdout=subprocess.PIPE, check=True)
            if questionary.confirm("Would you like to set up Redis using Docker?").ask():
                # Create a docker-compose.yml file for Redis
                create_directory_if_not_exists("docker")
                docker_compose_content = """version: '3'
services:
  redis:
    image: redis:latest
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

volumes:
  redis_data:
"""
                with open("docker/docker-compose.redis.yml", "w") as f:
                    f.write(docker_compose_content)
                
                # Start Redis container
                console.print("[yellow]Starting Redis container...[/yellow]")
                subprocess.run(
                    ["docker-compose", "-f", "docker/docker-compose.redis.yml", "up", "-d"],
                    check=True
                )
                console.print("[green]✓ Redis container started[/green]")
        except (subprocess.CalledProcessError, FileNotFoundError):
            console.print("[yellow]Docker not available. You'll need to install Redis manually.[/yellow]")
    
    elif messaging_system == "RabbitMQ":
        messaging_config["config"] = {
            "host": questionary.text("RabbitMQ host:", default="localhost").ask(),
            "port": questionary.text("RabbitMQ port:", default="5672").ask(),
            "vhost": questionary.text("RabbitMQ vhost:", default="/").ask(),
            "username": questionary.text("RabbitMQ username:", default="guest").ask(),
            "password": questionary.password("RabbitMQ password:").ask() or "guest"
        }
        
        # Offer to setup RabbitMQ with Docker
        try:
            subprocess.run(["docker", "--version"], stdout=subprocess.PIPE, check=True)
            if questionary.confirm("Would you like to set up RabbitMQ using Docker?").ask():
                create_directory_if_not_exists("docker")
                docker_compose_content = """version: '3'
services:
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"
      - "15672:15672"
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest
    restart: unless-stopped

volumes:
  rabbitmq_data:
"""
                with open("docker/docker-compose.rabbitmq.yml", "w") as f:
                    f.write(docker_compose_content)
                
                # Start RabbitMQ container
                console.print("[yellow]Starting RabbitMQ container...[/yellow]")
                subprocess.run(
                    ["docker-compose", "-f", "docker/docker-compose.rabbitmq.yml", "up", "-d"],
                    check=True
                )
                console.print("[green]✓ RabbitMQ container started[/green]")
        except (subprocess.CalledProcessError, FileNotFoundError):
            console.print("[yellow]Docker not available. You'll need to install RabbitMQ manually.[/yellow]")
    
    elif messaging_system == "ZeroMQ":
        messaging_config["config"] = {
            "pub_address": questionary.text("Publisher address:", default="tcp://*:5555").ask(),
            "sub_address": questionary.text("Subscriber address:", default="tcp://localhost:5555").ask()
        }
    
    elif messaging_system == "In-memory (for development)":
        messaging_config["config"] = {
            "queue_size": 100,
            "persistent": False
        }
    
    # Save messaging configuration
    with open("config/messaging.json", "w") as f:
        json.dump(messaging_config, f, indent=4)
    
    console.print("[green]✓ Messaging configuration created[/green]")
    
    # Update main config with messaging info
    config = load_config()
    config["messaging_system"] = messaging_system
    save_config(config)
    
    return True

def create_agent_architecture_scaffold():
    """Create a detailed scaffold for the agent architecture"""
    console.print(Panel("[bold blue]Agent Architecture Scaffolding[/bold blue]"))
    
    # Create directories for agent architecture
    agent_dirs = [
        "src/core/agents",           # Base agent classes
        "src/core/messaging",        # Messaging system
        "src/core/memory",           # Agent memory/state
        "src/core/reasoning",        # Reasoning modules
        "src/core/tools",            # Agent tools
        "src/agents/sdr",            # Sales Development Rep agent
        "src/agents/content_creator", # Content creator agent
        "src/agents/analytics",      # Analytics agent
        "src/integrations/notion",   # Notion integration
        "src/integrations/social",   # Social media integrations
        "src/integrations/seo",      # SEO tools integration
        "src/frontend/components",   # UI components
        "src/frontend/pages",        # UI pages
        "src/backend/api",           # API endpoints
        "src/backend/services",      # Backend services
        "tests/unit",                # Unit tests
        "tests/integration",         # Integration tests
        "templates/agents",          # Agent templates
        "templates/integrations",    # Integration templates
        "config/schemas",            # Configuration schemas
    ]
    
    for directory in agent_dirs:
        create_directory_if_not_exists(directory)
    
    # Create init files in Python directories
    for root, dirs, files in os.walk("src"):
        if os.path.basename(root) not in [".git", "__pycache__", "node_modules"]:
            init_file = os.path.join(root, "__init__.py")
            if not os.path.exists(init_file):
                with open(init_file, "w") as f:
                    f.write(f'"""\n{os.path.basename(root)} module\n"""\n')
                console.print(f"[green]✓ Created {init_file}[/green]")
    
    # Create basic agent architecture files
    core_files = {
        "src/core/agents/base_agent.py": """#!/usr/bin/env python3
\"\"\"
Base Agent - Abstract class for all agents

This module defines the BaseAgent class that all agents in the system
should inherit from. It provides common functionality and interfaces.
\"\"\"

from abc import ABC, abstractmethod
import uuid
from datetime import datetime
from typing import Dict, Any, List, Optional

class BaseAgent(ABC):
    \"\"\"Base abstract class for all agents\"\"\"
    
    def __init__(self, agent_id: Optional[str] = None, name: str = "Agent", config: Dict = None):
        \"\"\"Initialize the base agent.\"\"\"
        self.agent_id = agent_id or str(uuid.uuid4())
        self.name = name
        self.config = config or {}
        self.created_at = datetime.utcnow()
        self.last_active = self.created_at
        self.state = "initialized"
    
    @abstractmethod
    async def process(self, message: Dict) -> Dict:
        \"\"\"Process an incoming message and return a response.
        
        Args:
            message: The message to process
            
        Returns:
            The response message
        \"\"\"
        pass
    
    @abstractmethod
    async def initialize(self) -> bool:
        \"\"\"Initialize the agent and its resources.
        
        Returns:
            True if initialization was successful, False otherwise
        \"\"\"
        pass
    
    async def shutdown(self) -> bool:
        \"\"\"Shutdown the agent and release resources.
        
        Returns:
            True if shutdown was successful, False otherwise
        \"\"\"
        self.state = "shutdown"
        return True
    
    def get_status(self) -> Dict[str, Any]:
        \"\"\"Get the current status of the agent.
        
        Returns:
            Dictionary containing agent status information
        \"\"\"
        return {
            "agent_id": self.agent_id,
            "name": self.name,
            "state": self.state,
            "created_at": self.created_at.isoformat(),
            "last_active": self.last_active.isoformat()
        }
    
    def __repr__(self) -> str:
        return f"<{self.__class__.__name__}(id={self.agent_id}, name='{self.name}', state='{self.state}')>"
""",

        "src/core/messaging/message_bus.py": """#!/usr/bin/env python3
\"\"\"
Message Bus - Core messaging system for agent communication

This module implements the message bus that enables communication between
agents. It provides pub/sub functionality and message routing.
\"\"\"

import json
import asyncio
from typing import Dict, Any, List, Callable, Awaitable, Optional
from abc import ABC, abstractmethod
import uuid
from datetime import datetime

class MessageBus(ABC):
    \"\"\"Abstract Message Bus interface\"\"\"
    
    @abstractmethod
    async def publish(self, topic: str, message: Dict) -> bool:
        \"\"\"Publish a message to a topic.\"\"\"
        pass
    
    @abstractmethod
    async def subscribe(self, topic: str, callback: Callable[[Dict], Awaitable[None]]) -> str:
        \"\"\"Subscribe to a topic with a callback.\"\"\"
        pass
    
    @abstractmethod
    async def unsubscribe(self, subscription_id: str) -> bool:
        \"\"\"Unsubscribe from a subscription.\"\"\"
        pass

class Message:
    \"\"\"Standard message format for agent communication\"\"\"
    
    def __init__(self, 
                 sender_id: str,
                 content: Dict[str, Any],
                 message_type: str = "request",
                 recipient_id: Optional[str] = None,
                 message_id: Optional[str] = None,
                 correlation_id: Optional[str] = None,
                 timestamp: Optional[datetime] = None):
        \"\"\"Initialize a new message.\"\"\"
        self.message_id = message_id or str(uuid.uuid4())
        self.sender_id = sender_id
        self.recipient_id = recipient_id
        self.message_type = message_type
        self.content = content
        self.timestamp = timestamp or datetime.utcnow()
        self.correlation_id = correlation_id
    
    def to_dict(self) -> Dict[str, Any]:
        \"\"\"Convert message to dictionary.\"\"\"
        return {
            "message_id": self.message_id,
            "sender_id": self.sender_id,
            "recipient_id": self.recipient_id,
            "message_type": self.message_type,
            "content": self.content,
            "timestamp": self.timestamp.isoformat(),
            "correlation_id": self.correlation_id
        }
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> 'Message':
        \"\"\"Create a message from a dictionary.\"\"\"
        timestamp = datetime.fromisoformat(data["timestamp"]) if isinstance(data["timestamp"], str) else data["timestamp"]
        return cls(
            message_id=data.get("message_id"),
            sender_id=data.get("sender_id"),
            recipient_id=data.get("recipient_id"),
            message_type=data.get("message_type", "request"),
            content=data.get("content", {}),
            timestamp=timestamp,
            correlation_id=data.get("correlation_id")
        )
""",

        "src/core/logging/logger.py": """#!/usr/bin/env python3
\"\"\"
Agent Logging System

Provides structured logging for the agent system, with support for
different output formats and logging levels.
\"\"\"

import logging
import json
import sys
import os
from datetime import datetime
from typing import Dict, Any, Optional

class AgentLogger:
    \"\"\"Logger for agent activities\"\"\"
    
    LEVELS = {
        "DEBUG": logging.DEBUG,
        "INFO": logging.INFO,
        "WARNING": logging.WARNING,
        "ERROR": logging.ERROR,
        "CRITICAL": logging.CRITICAL
    }
    
    def __init__(self, 
                 name: str,
                 level: str = "INFO",
                 log_file: Optional[str] = None,
                 format_json: bool = False):
        \"\"\"Initialize logger.\"\"\"
        self.logger = logging.getLogger(name)
        self.logger.setLevel(self.LEVELS.get(level.upper(), logging.INFO))
        
        # Create log directory if it doesn't exist
        if log_file:
            log_dir = os.path.dirname(log_file)
            if log_dir and not os.path.exists(log_dir):
                os.makedirs(log_dir)
        
        # Configure handlers
        handlers = []
        
        # Console handler
        console_handler = logging.StreamHandler(sys.stdout)
        handlers.append(console_handler)
        
        # File handler if specified
        if log_file:
            file_handler = logging.FileHandler(log_file)
            handlers.append(file_handler)
        
        # Set formatter based on format type
        if format_json:
            formatter = logging.Formatter(
                '{"timestamp": "%(asctime)s", "level": "%(levelname)s", "name": "%(name)s", "message": %(message)s}'
            )
        else:
            formatter = logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
            )
        
        # Apply formatter to all handlers
        for handler in handlers:
            handler.setFormatter(formatter)
            self.logger.addHandler(handler)
    
    def _format_message(self, message: Any, **kwargs) -> str:
        \"\"\"Format message with additional context as JSON.\"\"\"
        if isinstance(message, dict):
            log_data = message.copy()
        else:
            log_data = {"message": str(message)}
        
        # Add additional context
        log_data.update(kwargs)
        
        return json.dumps(log_data)
    
    def debug(self, message: Any, **kwargs):
        \"\"\"Log debug message.\"\"\"
        self.logger.debug(self._format_message(message, **kwargs))
    
    def info(self, message: Any, **kwargs):
        \"\"\"Log info message.\"\"\"
        self.logger.info(self._format_message(message, **kwargs))
    
    def warning(self, message: Any, **kwargs):
        \"\"\"Log warning message.\"\"\"
        self.logger.warning(self._format_message(message, **kwargs))
    
    def error(self, message: Any, **kwargs):
        \"\"\"Log error message.\"\"\"
        self.logger.error(self._format_message(message, **kwargs))
    
    def critical(self, message: Any, **kwargs):
        \"\"\"Log critical message.\"\"\"
        self.logger.critical(self._format_message(message, **kwargs))
""",

        "config/agent_config_schema.json": """{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "title": "Agent Configuration Schema",
    "description": "Schema for configuring agents in the system",
    "type": "object",
    "required": ["agent_id", "name", "type"],
    "properties": {
        "agent_id": {
            "type": "string",
            "description": "Unique identifier for the agent"
        },
        "name": {
            "type": "string",
            "description": "Human-readable name for the agent"
        },
        "type": {
            "type": "string",
            "enum": ["sdr", "content_creator", "analytics"],
            "description": "Type of agent"
        },
        "enabled": {
            "type": "boolean",
            "default": true,
            "description": "Whether the agent is enabled"
        },
        "connections": {
            "type": "array",
            "items": {
                "type": "object",
                "required": ["target_agent", "direction"],
                "properties": {
                    "target_agent": {
                        "type": "string",
                        "description": "ID of the target agent"
                    },
                    "direction": {
                        "type": "string",
                        "enum": ["in", "out", "bidirectional"],
                        "default": "bidirectional",
                        "description": "Direction of communication"
                    }
                }
            }
        },
        "parameters": {
            "type": "object",
            "description": "Agent-specific parameters"
        },
        "authentication": {
            "type": "object",
            "description": "Authentication information for external services"
        },
        "scheduling": {
            "type": "object",
            "properties": {
                "interval": {
                    "type": "string",
                    "description": "Cron-style scheduling interval"
                },
                "active_hours": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "start": {
                                "type": "string",
                                "description": "Start time (HH:MM)"
                            },
                            "end": {
                                "type": "string",
                                "description": "End time (HH:MM)"
                            },
                            "days": {
                                "type": "array",
                                "items": {
                                    "type": "string",
                                    "enum": ["mon", "tue", "wed", "thu", "fri", "sat", "sun"]
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}"""
    }
    
    for file_path, content in core_files.items():
        # Create directory if it doesn't exist
        directory = os.path.dirname(file_path)
        if not os.path.exists(directory):
            os.makedirs(directory)
        
        # Create file
        with open(file_path, 'w') as f:
            f.write(content)
        
        console.print(f"[green]✓ Created {file_path}[/green]")
    
    # Create a README for the agent architecture
    agent_architecture_readme = """# Agent Zero Architecture

## Overview

This directory contains the core architecture for the Agent Zero framework. The system is built around the following key concepts:

- **Agents**: Autonomous entities that perform specific tasks
- **Message Bus**: Communication layer between agents
- **Tools**: Capabilities that agents can use to interact with the world
- **Memory**: State management for agents
- **Integrations**: Connections to external services

## Key Components

### Core

- `agents/`: Base classes and interfaces for all agent types
- `messaging/`: Message bus implementation for agent communication
- `memory/`: State management and persistence
- `tools/`: Shared tools that agents can use
- `logging/`: Logging and monitoring infrastructure

### Agents

- `sdr/`: Sales Development Representative agent
- `content_creator/`: Social media content creation and publishing agent
- `analytics/`: Metrics and analytics agent

### Integrations

- `notion/`: Notion API integration
- `social/`: Social media platform integrations
- `seo/`: SEO tools and analytics

## Usage

Each agent inherits from the `BaseAgent` class and implements the required methods:

```python
from src.core.agents.base_agent import BaseAgent

class MyCustomAgent(BaseAgent):
    async def initialize(self) -> bool:
        # Setup agent resources
        return True
        
    async def process(self, message: Dict) -> Dict:
        # Process incoming message
        return {"status": "success", "result": "..."}
