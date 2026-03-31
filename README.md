# SPI Verification Environment using UVM

This repository contains a robust **Design Verification (DV)** environment for a **Serial Peripheral Interface (SPI)** module. The project was developed as part of the curriculum at the **University of Information Technology (UIT)** in collaboration with **Tresemi**.

---

## 🗂️ Project Structure

```
tb/
├── agt/            # Agent (master/slave components)
│   ├── master/
│   └── slave/
├── cfg/            # Configuration objects
├── chk/            # Checker / scoreboard
├── cov/            # Functional coverage
├── env/            # UVM environment
├── tlm/            # TLM connections
└── tst/            # Testcases
```

---

## ⚙️ Prerequisites

* SystemVerilog simulator:

  * Siemens QuestaSim
  * Cadence Xcelium
* UVM library
* `make` tool installed
* Linux / Git Bash / MSYS2 environment

---

## 🚀 Setup

Before running simulation:

```bash
source env.sh
cd sim
```

---

## 🛠️ Build & Run (QuestaSim)

### Compile

```bash
make compile
```

### Run test

```bash
make coverage test_name=spi_demo_test
```

### Dump coverage

```bash
vcover dump top.ucdb > log
```

### Run with GUI

```bash
make vopt_gui test_name=spi_demo_test
```

### Run optimized simulation

```bash
make vopt_run test_name=spi_demo_test
```

### Run visualization

```bash
make vis_run test_name=spi_demo_test cmd_args=10
```

---

## 🛠️ Build & Run (Cadence Xcelium)

### Compile

```bash
make compile_spi tool=Cadence
```

### Run test

```bash
make run test_name=spi_demo_test tool=Cadence
```

### Coverage

```bash
make coverage test_name=spi_demo_test tool=Cadence
```

---

## 📊 Coverage Analysis (Cadence)

Open GUI:

```bash
imc -gui
```

Commands:

```
merge test1 test2 -out all
load -run all
report -html/detailsummary-metrics -out path
```

Or command line:

```bash
imc -execcmd "merge test1 test2 -out all"
```

---

## 🧪 Testcases

Example:

* `spi_demo_test` – basic functionality test

(Add more tests in `tb/tst/` directory)

---

## 🧩 Features

* UVM-compliant architecture
* Modular agent design (master/slave)
* Functional coverage support
* Multi-tool support (QuestaSim & Cadence)
* Scalable for advanced verification scenarios

---

## 📌 Notes

* Ensure environment variables are set correctly via `env.sh`
* Simulator paths must be configured before running
* Coverage database (`.ucdb`) is generated after simulation

---

## 👨‍💻 Author

* Cong Thanh Nguyen - University of Information Technology (UIT)

---
