# GENX v3.6.9

**AI-Native Operating System & Hybrid AI Agent Network**

- **Owner:** NUNA
- **Project:** GENX / BLUEDIM
- **Version:** 3.6.9
- **Architecture:** Hybrid AI Agent Network / AgentOS
- **Primary Workload:** Autonomous AI-assisted trading
- **Runtime:** Local LAN + Edge Devices + Cloud VPS
- **Execution:** Python + Node.js + MT5/MQL5
- **Control:** Jules + Cursor + AI Agent Network Controller

GENX is an AI-native operating and orchestration layer that connects AI agents, skills, devices, data, cloud services, and execution systems into one coordinated network. Trading is a primary workload, but GENX is designed as a general-purpose **AI Agent Operating System / Control Plane**.

---

## 1. What Is GENX?

GENX treats AI capabilities as modular system components rather than isolated applications.

The system can:

- Build capabilities from a central **Core / Brain**
- Install and manage modular **AI Skills / Plugins**
- Discover and communicate with other **AI agents**
- Coordinate agents through **routing and mission control**
- Connect local devices through a secure **LAN/VPN layer**
- Maintain structured **AI memory**
- Monitor devices, services, and workloads
- Connect external APIs and cloud services
- Separate AI decision-making from deterministic execution
- Operate **MT5/MQL5 trading infrastructure**
- Monitor VPS and edge-node health
- Provide emergency stop and operational controls
- Support continuous development through **Jules/Cursor**

GENX is therefore designed as a **control plane for a distributed AI-agent ecosystem**.

---

## 2. Core Philosophy

GENX follows the principle:

> **«Compress → Plug In → Build In → Build From Core»**

The Core/Brain provides the common foundation from which new agents, skills, connectors, and services can be assembled.

Instead of creating independent systems repeatedly, GENX turns reusable capabilities into modular components.

```text
                 ┌─────────────────────────┐
                 │       GENX CORE / BRAIN  │
                 │     Central Control      │
                 └────────────┬────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
       Agents              Skills             Memory
          │                   │                   │
          └───────────────────┼───────────────────┘
                              │
                 ┌────────────▼────────────┐
                 │ AI AGENT NETWORK        │
                 │ CONTROLLER /            │
                 │ CENTER HANDLER          │
                 └────────────┬────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
       Devices             Cloud              Trading
          │                   │                   │
      Mini-PC/VPS       Firebase/APIs       MT5 / MQL5
```

---

## 3. AgentOS Architecture

GENX v3.6.9 is organized around several core subsystems:

```text
GENX
│
├── Agent Kernel
├── Agent Identity
├── A2A Registry
├── Router / Dispatcher
├── Memory Core
├── Security Gatekeeper
├── Skill Plugin Manager
├── Mission Engine
├── Device Network Controller
├── Trading Intelligence Handler
├── Connector Layer
├── Vault / Secrets Layer
├── Monitoring / Watchdog
├── Dashboard / API
└── Launcher / Operations
```

### Agent Kernel

Foundational runtime for GENX agents:

- Agent lifecycle
- Identity
- Capabilities
- Permissions
- Communication
- Execution context
- Health state

### Agent Identity

Each agent has a role, capability set, and permission boundary:

- Core agents
- Specialist agents
- Trading, Research, Device, Monitoring, Security, Deployment agents, etc.

### A2A Registry

Agent-to-Agent registry for capability discovery and controlled communication:

```text
Agent A
   │
   ▼
A2A Registry
   │
   ├── Trading Agent
   ├── Research Agent
   ├── Risk Agent
   ├── Device Agent
   └── Monitoring Agent
```

---

## 4. AI Agent Network Controller / Center Handler

The **AI Agent Network Controller / Center Handler** is the central nervous system of GENX.

It coordinates:

- Agent discovery and routing
- Mission assignment
- Skill selection
- Device communication
- Security permissions
- Memory access
- Trading intelligence
- Monitoring and operational events

```text
User / Operator
       │
       ▼
AI Agent Center Handler
       │
       ▼
Router / Dispatcher
       │
 ┌─────┼────────┬─────────┐
 ▼     ▼        ▼         ▼
AI   Risk    Device    Research
Agent Agent   Agent      Agent
 │     │        │         │
 └─────┴────────┴─────────┘
              │
              ▼
           GENX Core
```

---

## 5. Intelligent Routing

GENX supports multiple agent-routing patterns:

- **Specialist Routing:** Task → best-fit agent
- **Hierarchical Routing:** Coordinator → subtasks → specialists
- **Consensus Routing:** Multiple agents analyze; coordinator aggregates

AI analysis is kept separate from deterministic safety and execution rules.

---

## 6. Three-Layer Memory

```text
┌─────────────────────────┐
│ Working / Runtime Memory│
├─────────────────────────┤
│ Operational Memory      │
├─────────────────────────┤
│ Long-Term Knowledge     │
└─────────────────────────┘
```

Memory supports:

- Agent state and missions
- Trade journals and system events
- Research and historical decisions
- Device state and operational knowledge

Sensitive credentials and secrets remain outside normal application memory (see Vault).

---

## 7. Security Gatekeeper

Security is a dedicated control layer that separates:

- **AI reasoning**
- from **permission + risk + execution**

Example permission levels:

- Level 0 → Public / Read
- Level 1 → Local Operations
- Level 2 → Protected Services
- Level 3 → Administrative Operations
- Level 4 → Critical / Trading Operations

Trading actions are additionally subject to dynamic risk gates. AI cannot bypass deterministic safety controls.

---

## 8. Skill Plugin System

Capabilities are implemented as installable **skills**:

```text
skills/
├── market/
├── strategy/
├── risk/
├── execution/
├── memory/
├── research/
├── monitoring/
├── security/
└── trading/
    └── mt5_bridge/
```

Standard skill layout:

```text
skill/
├── manifest.yaml
├── README.md
├── src/
├── config/
├── tests/
├── models/
├── data/
├── logs/
└── version.txt
```

Lifecycle:

1. Discovery
2. Download
3. Signature Verification
4. Installation
5. Testing
6. Activation
7. Execution
8. Update
9. Rollback if required

---

## 9. Device Network Controller

GENX operates across multiple physical devices.

Conceptual topology:

```text
                         INTERNET
                            │
                            ▼
                   ┌─────────────────┐
                   │ Contabo VPS 4   │
                   │ GENX Cloud Core │
                   └────────┬────────┘
                            │
                         VPN/LAN
                            │
                    ┌───────▼───────┐
                    │ Home Router   │
                    └───────┬───────┘
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        Mini-PC          Laptop        MT5 System
       Edge Agent      Admin/Watchdog   EA/Terminal
```

### Mini‑PC (Edge Node)

- Local GENX edge node / sandbox
- Responsibilities:
  - Local AI services
  - LAN bridge
  - Device controller
  - Telemetry & watchdog
  - Local automation
  - Trading bridge support
- Preferred mode: headless, Ethernet/LAN, remote administration.

### Laptop

- Development workstation
- Administrative console
- Monitoring interface & watchdog
- Remote VS Code workstation

### Contabo VPS 4

- 24/7 cloud component
- Target stack:
  - Ubuntu 24.04
  - Docker
  - FastAPI
  - PostgreSQL
  - Redis
  - Tailscale/VPN
  - Monitoring
  - GENX services
  - Secure environment configuration
- Target install path: `/opt/GENX`

---

## 10. BLUEDIM Edge Platform

BLUEDIM is the broader edge/device platform around GENX:

```text
BLUEDIM
│
├── Brain
├── Vision
├── Vault
├── Command
├── Cloud
└── TradeCore
```

Storage/device roles:

- **BLUEDIM 64GB** – primary AI command/portable system layer
- **ADATA 32GB** – portable edge/data worker layer
- **Mini‑PC** – local GENX edge node
- **Laptop** – administration/development
- **VPS** – 24/7 cloud node

These components are designed to operate as one coordinated system.

---

## 11. Trading Intelligence Architecture

Trading is a primary workload, implemented as a controlled pipeline:

```text
Market Data
     │
     ▼
AI / Strategy Analysis
     │
     ▼
Signal (BUY / SELL / HOLD)
     │
     ▼
Risk Engine
     │
     ▼
Security Gatekeeper
     │
     ▼
Execution Layer
     │
     ▼
MT5 / MQL5 EA
     │
     ▼
Broker
```

AI provides analysis and signals; deterministic risk and execution layers enforce constraints.

---

## 12. MT5 / MQL5 Bridge

Bridge between AI services and MetaTrader 5:

```text
Python AI Engine
       │
       ▼
FastAPI / LAN Bridge
       │
       ▼
MT5 Expert Advisor
       │
       ▼
MetaTrader 5
       │
       ▼
Broker
```

The EA handles terminal-side execution and reports heartbeat/status back to GENX.

---

## 13. Trading Risk Architecture

Risk is a separate subsystem with configurable constraints, e.g.:

- Risk per Trade → 0.5–1%
- Daily Loss Cap → 2%
- Maximum Drawdown → 10%

Architecture:

```text
AI Decision
     │
     ▼
Risk Guard
     │
     ├── Position Size
     ├── Exposure
     ├── Daily Loss
     ├── Drawdown
     └── Trade Permission
            │
            ▼
       Execution Gate
```

Risk parameters are configured outside AI models and enforced deterministically.

---

## 14. Trading Monitoring

GENX monitors:

- EA heartbeat
- Trade journal
- VPS & mini‑PC telemetry
- Device health
- MT5 connectivity
- Service health
- Remote emergency stop & resume controls
- Operational events

Watchdog detects conditions like:

- EA / MT5 / LAN bridge / AI / risk service offline
- Unexpected process state

Critical failures lead to a safe operational state, not uncontrolled execution.

---

## 15. GENX Secret Vault

Secrets are handled separately from source code:

```text
Vault
│
├── Templates
├── Encryption
├── Rotation
├── Security Scanner
└── Secret Control Layer
```

Potential integrations:

- GitHub/GitLab CI
- Firebase
- MT5 & broker APIs
- Jules, Cursor
- VPS deployment

**Security Rule:** Never hard-code passwords, API keys, tokens, SSH keys, broker or cloud credentials, certificates, or encryption keys. Use templates/placeholders in the repo; inject real secrets via Vault/CI at deploy time.

---

## 16. Jules + Cursor Development Model

GENX uses an AI-assisted development workflow.

### Jules

Remote implementation/orchestration worker:

- Repository analysis
- Code changes
- Testing
- Branching & PRs
- Deployment tasks
- Documentation & maintenance

### Cursor

Development/control interface:

- Architecture & code review
- Local development
- Repository navigation
- Agent coordination
- Debugging
- System administration workflows

Conceptually:

```text
                 NUNA
                  │
                  ▼
          GENX Control Layer
             /          \
            /            \
        Jules           Cursor
       Worker            Brain
          │                │
          └──────┬─────────┘
                 ▼
             GENX Core
                 │
        ┌────────┼────────┐
        ▼        ▼        ▼
      Code     Agents   Devices
```

---

## 17. Cloud & External Integrations

GENX connects external services through controlled connectors:

- GitHub, GitLab, Codeberg
- MQL5, Firebase, Gemini, Replit
- VS Code, Cursor, Jules
- MT5, broker APIs, market data APIs

Connectors follow the same security and permission model as internal agents.

---

## 18. Repository Architecture (Conceptual)

```text
GENX/
│
├── core/
│   ├── kernel/
│   ├── agents/
│   ├── router/
│   ├── memory/
│   ├── security/
│   └── controller/
│
├── agents/
│   ├── trading/
│   ├── research/
│   ├── device/
│   ├── monitoring/
│   └── operations/
│
├── skills/
│   ├── market/
│   ├── strategy/
│   ├── risk/
│   ├── execution/
│   ├── memory/
│   ├── research/
│   ├── monitoring/
│   └── security/
│
├── connectors/
│   ├── mt5/
│   ├── firebase/
│   ├── github/
│   ├── gitlab/
│   └── market-data/
│
├── data/
├── models/
├── vault/
├── monitoring/
├── dashboard/
├── launcher/
├── scripts/
├── tests/
├── docs/
│
├── artifacts/
├── lib/
├── package.json
├── pnpm-workspace.yaml
└── README.md
```

---

## 19. Node.js + Python + MQL5

GENX is a multi-runtime system.

### Node.js

- LAN bridge
- APIs & web services
- Device communication
- Network orchestration
- Frontend/backend integration

### Python

- AI decision engine
- Data processing
- Strategy research
- Model inference
- Risk analytics
- Automation

### MQL5

- MT5 Expert Advisors
- Terminal-side market interaction
- Trade execution
- Account information & position management
- EA heartbeat

---

## 20. Replit / Package Management

Current application lineage includes a Node.js workspace managed with pnpm.

Workspace configuration includes:

- **Minimum release age** for npm packages to reduce supply-chain risk
- Exclusions only for trusted sources (e.g. `@replit/*`)

Replit deployment lineage uses:

- Node.js 24
- Autoscale
- Post-build cleanup (`pnpm store prune`)

Environment configuration remains separate from source code.

---

## 21. Event-Driven Architecture

Important system activities are modeled as events, e.g.:

- `AGENT_STARTED`, `AGENT_STOPPED`, `AGENT_FAILED`
- `DEVICE_ONLINE`, `DEVICE_OFFLINE`
- `MT5_CONNECTED`, `MT5_DISCONNECTED`
- `EA_HEARTBEAT`, `EA_TIMEOUT`
- `SIGNAL_CREATED`, `RISK_APPROVED`, `RISK_REJECTED`
- `TRADE_REQUESTED`, `TRADE_EXECUTED`, `TRADE_FAILED`
- `MISSION_CREATED`, `MISSION_COMPLETED`, `MISSION_FAILED`
- `SECURITY_ALERT`, `EMERGENCY_STOP`, `SYSTEM_RECOVERY`

This event layer enables consistent monitoring, auditing, automation, and debugging.

---

## 22. Mission Engine

Missions represent higher-level objectives:

```text
Mission
   │
   ▼
Planner
   │
   ▼
Router
   │
   ├── Agent A
   ├── Agent B
   └── Agent C
   │
   ▼
Results
   │
   ▼
Validation
   │
   ▼
Mission Complete
```

Complex tasks are decomposed into smaller agent operations with clear ownership.

---

## 23. Dashboard & Control Plane

A future GENX dashboard can expose:

- Agent & device status
- VPS & MT5 status
- EA heartbeat
- Trading & risk state
- Missions, events, logs
- System health
- Emergency controls

The dashboard is an operational interface, not a bypass for security controls.

---

## 24. Current Development Direction

GENX is progressing toward a unified architecture:

```text
                    GENX CORE
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
    AI AGENTS        SKILLS        CONNECTORS
        │              │              │
        └──────────────┼──────────────┘
                       ▼
             AGENT CENTER HANDLER
                       │
              ┌────────┼────────┐
              ▼        ▼        ▼
            LAN      CLOUD     MT5
          DEVICES     VPS      EA
              │        │        │
              └────────┼────────┘
                       ▼
                  GENX NETWORK
```

Long-term, new functionality should be **pluggable, composable, observable, secure, and recoverable**.

---

## 25. Development Principles

1. Core-first architecture
2. Modular skills
3. Agent specialization
4. A2A communication
5. Deterministic security boundaries
6. AI reasoning separated from critical execution
7. Secrets separated from source
8. Device health monitoring
9. Event-driven operations
10. Automated testing
11. Rollback-capable deployment
12. LAN/VPN-first private networking
13. Cloud + edge hybrid operation
14. Demo-first validation for trading
15. Human-controlled critical actions

---

## 26. Security Boundary

GENX assumes a **zero-trust mindset** between components.

A device, agent, plugin, or connector does not get unrestricted access just because it is inside the LAN.

Conceptual boundary:

```text
Request
  │
  ▼
Identity
  │
  ▼
Authentication
  │
  ▼
Authorization
  │
  ▼
Security Gatekeeper
  │
  ▼
Risk Validation
  │
  ▼
Execution
```

---

## 27. Data & Secret Separation

Repository migrations/imports distinguish between:

**Safe to migrate:**

- Source code
- Documentation
- Empty database schemas
- Configuration templates
- Tests
- Public models
- Deployment definitions

**Never migrate automatically:**

- Trading history
- User database content
- Camera data
- Private logs
- Passwords, API keys, tokens
- Broker & cloud credentials
- SSH keys, certificates, encryption secrets
- Access tokens

Private operational data belongs in controlled storage, not the source repo.

---

## 28. Deployment Model

GENX is designed for repeatable deployment:

```text
Developer
    │
    ▼
Git Repository
    │
    ▼
Jules / CI
    │
    ├── Test
    ├── Validate
    ├── Build
    └── Package
         │
         ▼
     Deployment
      /       \
     ▼         ▼
 Mini-PC     VPS
     │         │
     └────┬────┘
          ▼
      GENX Network
```

Deployment scripts should support:

- `install`, `configure`, `start`, `stop`
- `health_check`, `update`, `rollback`
- `emergency_stop`

---

## 29. Example Operational Flow (Trading)

A typical AI-assisted trading operation:

```text
Market Data
     │
     ▼
Market Analysis
     │
     ▼
Strategy Agent
     │
     ▼
BUY / SELL / HOLD
     │
     ▼
Risk Agent
     │
     ▼
Security Gatekeeper
     │
     ▼
Execution Agent
     │
     ▼
MT5 Bridge
     │
     ▼
MQL5 EA
     │
     ▼
MT5
     │
     ▼
Broker
     │
     ▼
Trade Journal
     │
     ▼
Memory / Analytics
```

Failures at every stage should be observable and recoverable.

---

## 30. GENX 3.6.9 Identity

GENX v3.6.9 marks the transition from scripts and trading components to a unified **AI Agent Operating System / Network Control Plane**.

Central concepts:

> CORE → AGENTS → SKILLS → MEMORY → SECURITY → MISSIONS → DEVICES → CONNECTORS → EXECUTION → OBSERVABILITY

The system grows by adding capabilities to the Core rather than rebuilding the entire platform.

---

## 31. Project Status

- **Architecture:** Hybrid AI Agent Network / AgentOS
- **Core Controller:** AI Agent Network Controller / Center Handler
- **Agent Framework:** Agent Identity + A2A + Router/Dispatcher
- **Memory:** Multi-layer architecture
- **Security:** Security Gatekeeper + Vault
- **Skills:** Plugin Manager
- **Devices:** Mini‑PC + laptop + VPS architecture
- **Cloud:** Contabo VPS 4 target
- **Networking:** LAN + VPN/private connectivity
- **Trading:** MT5/MQL5 bridge
- **Development:** Jules + Cursor
- **Primary trading mode:** Demo-first validation before production
- **Version lineage:** v3.6.9

---

## 32. Roadmap

### Phase 1 — Core

- Agent Kernel
- Agent Identity
- A2A Registry
- Router
- Memory
- Security Gatekeeper

### Phase 2 — Network

- Device Controller
- LAN bridge
- VPN connectivity
- Heartbeat
- Watchdog
- Remote operations

### Phase 3 — Skills

- Skill Manager
- Trading, research, monitoring, security skills
- Connector framework
