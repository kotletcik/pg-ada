# pg-ada

A concurrent logistics and transport simulation written in **Ada**, built with **Alire** and **GNAT**. The project models real-time interactions between autonomous transport fleets, capacity-constrained hub infrastructure, and centralized telemetry systems.

## Overview

**pg-ada** simulates the daily operations of an automated, multi-agent logistics and distribution hub where multiple independent actors compete for shared physical resources in real time. Rather than executing sequentially, every vehicle, charging station, docking bay, and monitoring subsystem operates concurrently, reflecting the coordination challenges of modern warehouse and fleet management.

### How the Simulation Works

The simulation models an end-to-end supply and dispatch lifecycle:

1. **Inbound Heavy Transport:** Heavy-duty vehicles (**Monstertrucks**) arrive at the hub carrying bulk cargo and request access to a limited number of **Unloading Points**. Once docked, cargo is transferred into the central **Warehouse**, provided sufficient storage capacity is available.
2. **Outbound Courier Dispatch:** Agile delivery units (**Kukiriniarz**) retrieve goods from the **Warehouse** to fulfill outbound distribution tasks, cycling continuously between loading, transit, and return phases.
3. **Energy & Charging Management:** Operating vehicles deplete their energy reserves over time and must periodically navigate to shared **Chargers**. Because charging slots are scarce, agents must synchronize access and wait when stations are occupied.
4. **Real-Time Telemetry & Analysis:** As tasks execute, the **Monitoring Centre** observes and records state transitions, resource utilization, and operational events across the hub. Collected metrics are processed by the **Data Analyzer** to evaluate system throughput, resource contention, and overall fleet efficiency.

### Purpose & Technical Focus

Designed around Ada's native concurrency primitives, this project serves as a practical demonstration of **safe concurrent systems engineering**. It focuses on eliminating race conditions, preventing deadlocks and resource starvation, and maintaining clean separation between system interfaces (`.ads`) and implementations (`.adb`).

## Project Structure

```
pg-ada/
├── alire.toml                  # Alire crate configuration and dependencies
├── pg_ada.gpr                  # GNAT Project Manager build configuration
└── src/
    ├── main.adb                # Simulation entry point and task initialization
    ├── warehouse.ads/.adb      # Warehouse storage and inventory synchronization
    ├── unloading_point.ads/.adb# Cargo unloading bays and docking management
    ├── charger.ads/.adb        # Charging station resource allocation
    ├── kukiriniarz.ads/.adb    # Transport/courier worker task logic
    ├── monstertrucks.ads/.adb  # Heavy transport vehicle task logic
    ├── monitoring_centre.ads/.adb # Central system state and telemetry logger
    └── data_analyzer.ads/.adb  # Simulation metrics and performance data analysis
```

## Core Modules

### Infrastructure & Shared Resources

* **`Warehouse` (`warehouse.ads` / `.adb`)** – Manages inventory capacity, stock intake, and dispatch operations safely across concurrent tasks.
* **`Unloading_Point` (`unloading_point.ads` / `.adb`)** – Coordinates docking access and cargo transfer between arriving vehicles and storage.
* **`Charger` (`charger.ads` / `.adb`)** – Controls access to charging slots and energy replenishment for active fleet units.

### Active Fleet & Agents

* **`Kukiriniarz` (`kukiriniarz.ads` / `.adb`)** – Implements courier/operator task behavior, handling cargo transport cycles and battery/resource management.
* **`Monstertrucks` (`monstertrucks.ads` / `.adb`)** – Implements heavy-duty transport vehicle tasks interacting with unloading points and warehouses.

### Telemetry & Analytics

* **`Monitoring_Centre` (`monitoring_centre.ads` / `.adb`)** – Aggregates status updates, events, and operational states across all simulation entities.
* **`Data_Analyzer` (`data_analyzer.ads` / `.adb`)** – Processes collected simulation records to evaluate throughput, utilization, and efficiency metrics.

## Prerequisites

To build and run this project, ensure you have the following installed:

* [**Alire**](https://alire.ada.dev/) (Ada Package Manager) — recommended
* **GNAT** & **GPRbuild** (automatically managed if building via Alire)

## Building and Running

### Using Alire (Recommended)

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd pg-ada
   ```

2. **Build the project:**
   ```bash
   alr build
   ```

3. **Run the simulation:**
   ```bash
   alr run
   ```

### Using GPRbuild Directly

If you have a standalone GNAT toolchain configured in your `PATH`:

```bash
gprbuild -P pg_ada.gpr
./bin/main
```

## Concurrency & Design Highlights

* **Task-Based Concurrency:** Active agents (`Kukiriniarz`, `Monstertrucks`) and subsystems run concurrently using Ada tasks.
* **Safe Resource Sharing:** Shared facilities (`Warehouse`, `Unloading_Point`, `Charger`) synchronize access to prevent race conditions and deadlocks.
* **Modular Specification/Body Separation:** Clean separation between public interfaces (`.ads`) and implementation details (`.adb`).
