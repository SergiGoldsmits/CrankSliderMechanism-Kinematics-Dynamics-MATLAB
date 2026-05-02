# Crank-Slider Mechanism — Automated Mechanical System Design

**Course project — Automated Mechanical Systems Design, MSc Industrial Automation Engineering**  
**Università degli Studi di Pavia, A.Y. 2024/2025**

---

## Overview

This project analyses and designs a **crank-slider mechanism** for an industrial printing group operating at up to 200 pieces/minute. The mechanism drives a printing head through two distinct operating modes — flat printing and relief printing — each requiring different kinematic and dynamic behaviour.

The full design pipeline is implemented in MATLAB and validated with Simscape Multibody, covering direct kinematics, velocity and acceleration analysis, dynamic torque computation, motor sizing, and gear ratio selection.

---

## Demo

https://github.com/SergiGoldsmits/automated-mechanical-system-design-MATLAB/raw/main/docs/video_relief_animation.mp4

---

## Mechanism Description

| Parameter | Value |
|-----------|-------|
| Crank radius (a) | 10 mm |
| Rod length (b) | 150 mm |
| Operating speed | 200 pieces/min |
| Printing force (F) | 1400 N |
| Moving mass (M) | 7.19 kg |
| Crank inertia | 1.34 × 10⁻³ kg·m² |
| Rod inertia | 4.98 × 10⁻³ kg·m² |

---

## What's Implemented

### Kinematics
- **Direct kinematics** — slider position, velocity, and acceleration as a function of crank angle, computed analytically from crank-slider geometry
- **Flat printing mode** — constant angular velocity, full 360° crank rotation, slider follows standard crank-slider profile
- **Relief printing mode** — variable crank motion profile using a **motion curve module (MCM)**, implementing S-curve, cubic, and asymmetric cosine profiles to achieve a controlled dwell-rise-dwell sequence for the printing stroke

### Motion Curve Module (MCM)
- `MCM_motionProfile_RELEASE.m` — master motion profile dispatcher
- `MCM_sshape.m` — S-curve (cycloidal) motion law
- `MCM_cubic.m` — cubic polynomial motion law
- `AccCosAsim.m` — asymmetric cosine acceleration profile
- All profiles ensure continuity of position, velocity, and acceleration at transition points

### Dynamics
- **Required crank torque** computed using the power balance method for both flat and relief printing modes
- Torque profile accounts for inertial forces (slider mass, rod, crank) and the applied printing force during the contact phase
- Variable angular velocity dynamics handled in the relief printing case

### Motor Sizing
- `sizing_ReliefPrintingGroup_RELEASE.m` — automatic motor selection from catalogue
- Computes RMS torque, peak torque, and optimal gear ratio for each motor in the catalogue
- Plots motor operating point against torque-speed characteristic curves
- Verifies selected motor + gearbox combination against thermal and peak torque limits

### Simscape Validation
- `Simscape_Flat_PrintingGroup_RELEASE.slx` — flat printing mode validation
- `Simscape_Relief_PrintingGroup_RELEASE.slx` — relief printing mode validation with MCM-driven crank motion
- Analytical results compared directly against Simscape Multibody simulation

---

## Key Results

- Crank-slider kinematics fully validated against Simscape with sub-millimetre position agreement
- Relief printing torque profile shows peak demand during printing stroke, dwell phases confirm zero torque requirement
- Motor sizing selects optimal motor-gearbox combination satisfying both RMS thermal constraint and peak torque requirement at 200 pcs/min
- S-curve motion law selected for relief stroke — best trade-off between acceleration smoothness and stroke duration

---

## Repository Structure

```
├── Release/
│   ├── main_PrintingGroup_RELEASE.m          # Main script — kinematics + dynamics
│   ├── sizing_ReliefPrintingGroup_RELEASE.m  # Motor sizing and gear ratio selection
│   ├── MCM_motionProfile_RELEASE.m           # Motion curve module dispatcher
│   ├── MCM_sshape.m                          # S-curve motion law
│   ├── MCM_cubic.m                           # Cubic motion law
│   ├── AccCosAsim.m                          # Asymmetric cosine profile
│   ├── catalog_ReliefPrintigGroup.m          # Motor catalogue data
│   ├── Simscape_Flat_PrintingGroup_RELEASE.slx    # Simscape — flat mode
│   └── Simscape_Relief_PrintingGroup_RELEASE.slx  # Simscape — relief mode
└── docs/
    ├── Presentation_AMSD_crankslider_project.pdf  # Project presentation
    └── video_relief_animation.mp4                  # Simscape animation
```

---

## How to Run

**Requirements:** MATLAB R2023a or later, Simulink, Simscape Multibody toolbox

1. Open MATLAB and navigate to the `Release/` folder
2. Run `main_PrintingGroup_RELEASE.m` — generates kinematics and dynamics plots for both printing modes and runs motor sizing
3. Open `Simscape_Flat_PrintingGroup_RELEASE.slx` or `Simscape_Relief_PrintingGroup_RELEASE.slx` in Simulink for physical validation

---

## Context

Completed as part of the **Automated Mechanical Systems Design** course at the University of Pavia (MSc Industrial Automation Engineering). The project covers the full design workflow for an industrial cam-driven mechanism: from analytical kinematic modelling through dynamic analysis to motor and gearbox selection.

**Author:** Sergi Goldsmits Ybarra  
**Contact:** sergigoldsmits2000@gmail.com  
**LinkedIn:** [linkedin.com/in/sergigoldsmits00](https://linkedin.com/in/sergigoldsmits00)  
**GitHub:** [github.com/SergiGoldsmits](https://github.com/SergiGoldsmits)
