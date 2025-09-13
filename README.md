# Reducing EV Battery E-Waste with Machine Learning  
## An MLP-Based Prognostic Model for RUL and SOH Assessment



---

## Abstract

The exponential growth of electric vehicles (EVs) is both a pathway to decarbonized transport and a source of e-waste from end-of-life batteries. This project presents a hybrid machine learning framework for lithium-ion battery prognostics, enabling accurate assessment of battery State of Health (SOH) and Remaining Useful Life (RUL) to facilitate second-life applications and e-waste mitigation.

Leveraging the Oxford Battery Degradation Dataset, we conduct exploratory data analysis to uncover degradation mechanisms and select salient health-indicating features. An MLP neural network is developed and rigorously validated, achieving SOH estimation with an RMSE of 1.18%. To address the limitations of neural networks in long-term extrapolation, a hybrid model combines precise SOH assessment with reliable, mathematically-derived RUL forecasting.

The framework culminates in an automated Decision Support Report, delivering actionable metrics—including battery grading, economic value estimation, and environmental impact—via a user-friendly interface.

---

## Table of Contents

- Abstract
- Introduction: E-Waste Imperative & Circular Economy
- Dataset & Feature Engineering
- MLP Model for Battery State of Health Prediction
- User-Friendly Report Generation & Analysis
- Application to E-Waste Reduction and the Circular Economy
- Conclusion & Future Work
- References
- Appendix: MATLAB Implementation

---

## Project Highlights

### 1. Introduction

- **Background:** Lithium-ion batteries are central to sustainable transport but pose a future e-waste challenge.
- **Circular Economy:** Prognostics and Health Management (PHM) enables battery reuse, repurposing, and responsible recycling.
- **Objectives:**  
  - Scientific explanation of degradation mechanisms  
  - High-accuracy SOH estimation with machine learning  
  - Hybrid modeling for long-term RUL prediction  
  - User-friendly decision support system

### 2. Dataset and Feature Engineering

- **Oxford Battery Degradation Dataset:** 8 Kokam 740mAh cells, consistent characterization every 100 cycles.
- **Feature Engineering:**  
  - Cycle number  
  - Average temperature during discharge  
  - Approximated internal resistance (DCIR)

### 3. MLP Model for SOH Prediction

- **Inputs:** Cycle number, temperature, internal resistance.
- **Network Architecture:** Two hidden layers (20, 10 neurons).
- **Training:** Levenberg-Marquardt backpropagation, robust normalization.
- **Performance:** RMSE of 1.18%, R-value of 0.98 on test data.

### 4. Automated Report Generation

- **User Inputs:** Cell ID and cycle number.
- **Outputs:**  
  - SOH estimation  
  - Battery grading (A: First Life, B: Second Life, C: Recycling)  
  - RUL calculation  
  - Estimated market value  
  - Environmental benefit (CO₂ saved)
- **Workflow:** Automated MATLAB script for full report generation.

### 5. Impact on E-Waste Reduction

- **Extending First Life:** Intelligent Battery Management System (BMS) integration.
- **Enabling Second Life:** Automated grading, economic, and environmental assessment for repurposing.

### 6. Limitations

- Dataset homogeneity (single cell type, controlled conditions)
- Limited feature space (no ICA/EIS features)
- Deterministic predictions (no uncertainty quantification)

### 7. Future Directions

- Advanced neural architectures (LSTM, transfer learning)
- Uncertainty quantification (Bayesian methods)
- Physics-informed ML
- Real-world deployment and validation

---

## MATLAB Implementation

MATLAB scripts provided:
- **Data Exploration:** `explorebatterydata.m`  
- **MLP Training:** `trainbatterymlp.m`  
- **Decision Support Report Generator:** `generatereportforcell.m`

Each script is modular, thoroughly commented, and ensures reproducibility.

---

## Example Decision Support Report

*Generated for Cell 2 at Cycle 7500:*

```
*** BATTERY PROGNOSTIC & DECISION SUPPORT REPORT ***
Generated on: 30-Aug-2025 12:26:31

--- INPUT PARAMETERS ---
Cycle Number: 7500
Average Temperature: 40.7°C
Internal Resistance: 0.1012 Ohms

--- CURRENT HEALTH ASSESSMENT (via MLP Model) ---
Estimated State of Health (SOH): 76.58 %

--- GRADING & RECOMMENDATION ---
GRADE: B (Second Life Candidate)
STATUS: Retired from EV use.
RECOMMENDATION: Repurpose for "Second Life" to prevent e-waste.

--- FUTURE PROGNOSIS (until 60% SOH) ---
Estimated Remaining Useful Life (RUL): ~100 Cycles

--- E-WASTE REDUCTION IMPACT ASSESSMENT ---
Estimated Second-Life Market Value: $0.10
Estimated Environmental Benefit: 0.3 kg of CO₂ emissions saved
```

---

## Visualizations

### 1. **Workflow of the Prognostic System**

> _(# Reducing EV Battery E-Waste with Machine Learning  
## An MLP-Based Prognostic Model for RUL and SOH Assessment



---

## Abstract

The exponential growth of electric vehicles (EVs) is both a pathway to decarbonized transport and a source of e-waste from end-of-life batteries. This project presents a hybrid machine learning framework for lithium-ion battery prognostics, enabling accurate assessment of battery State of Health (SOH) and Remaining Useful Life (RUL) to facilitate second-life applications and e-waste mitigation.

Leveraging the Oxford Battery Degradation Dataset, we conduct exploratory data analysis to uncover degradation mechanisms and select salient health-indicating features. An MLP neural network is developed and rigorously validated, achieving SOH estimation with an RMSE of 1.18%. To address the limitations of neural networks in long-term extrapolation, a hybrid model combines precise SOH assessment with reliable, mathematically-derived RUL forecasting.

The framework culminates in an automated Decision Support Report, delivering actionable metrics—including battery grading, economic value estimation, and environmental impact—via a user-friendly interface.

---

## Table of Contents

- Abstract
- Introduction: E-Waste Imperative & Circular Economy
- Dataset & Feature Engineering
- MLP Model for Battery State of Health Prediction
- User-Friendly Report Generation & Analysis
- Application to E-Waste Reduction and the Circular Economy
- Conclusion & Future Work
- References
- Appendix: MATLAB Implementation

---

## Project Highlights

### 1. Introduction

- **Background:** Lithium-ion batteries are central to sustainable transport but pose a future e-waste challenge.
- **Circular Economy:** Prognostics and Health Management (PHM) enables battery reuse, repurposing, and responsible recycling.
- **Objectives:**  
  - Scientific explanation of degradation mechanisms  
  - High-accuracy SOH estimation with machine learning  
  - Hybrid modeling for long-term RUL prediction  
  - User-friendly decision support system

### 2. Dataset and Feature Engineering

- **Oxford Battery Degradation Dataset:** 8 Kokam 740mAh cells, consistent characterization every 100 cycles.
- **Feature Engineering:**  
  - Cycle number  
  - Average temperature during discharge  
  - Approximated internal resistance (DCIR)

### 3. MLP Model for SOH Prediction

- **Inputs:** Cycle number, temperature, internal resistance.
- **Network Architecture:** Two hidden layers (20, 10 neurons).
- **Training:** Levenberg-Marquardt backpropagation, robust normalization.
- **Performance:** RMSE of 1.18%, R-value of 0.98 on test data.

### 4. Automated Report Generation

- **User Inputs:** Cell ID and cycle number.
- **Outputs:**  
  - SOH estimation  
  - Battery grading (A: First Life, B: Second Life, C: Recycling)  
  - RUL calculation  
  - Estimated market value  
  - Environmental benefit (CO₂ saved)
- **Workflow:** Automated MATLAB script for full report generation.

### 5. Impact on E-Waste Reduction

- **Extending First Life:** Intelligent Battery Management System (BMS) integration.
- **Enabling Second Life:** Automated grading, economic, and environmental assessment for repurposing.

### 6. Limitations

- Dataset homogeneity (single cell type, controlled conditions)
- Limited feature space (no ICA/EIS features)
- Deterministic predictions (no uncertainty quantification)

### 7. Future Directions

- Advanced neural architectures (LSTM, transfer learning)
- Uncertainty quantification (Bayesian methods)
- Physics-informed ML
- Real-world deployment and validation

---

## MATLAB Implementation

MATLAB scripts provided:
- **Data Exploration:** `explorebatterydata.m`  
- **MLP Training:** `trainbatterymlp.m`  
- **Decision Support Report Generator:** `generatereportforcell.m`

Each script is modular, thoroughly commented, and ensures reproducibility.

---

## Example Decision Support Report

*Generated for Cell 2 at Cycle 7500:*

```
*** BATTERY PROGNOSTIC & DECISION SUPPORT REPORT ***
Generated on: 30-Aug-2025 12:26:31

--- INPUT PARAMETERS ---
Cycle Number: 7500
Average Temperature: 40.7°C
Internal Resistance: 0.1012 Ohms

--- CURRENT HEALTH ASSESSMENT (via MLP Model) ---
Estimated State of Health (SOH): 76.58 %

--- GRADING & RECOMMENDATION ---
GRADE: B (Second Life Candidate)
STATUS: Retired from EV use.
RECOMMENDATION: Repurpose for "Second Life" to prevent e-waste.

--- FUTURE PROGNOSIS (until 60% SOH) ---
Estimated Remaining Useful Life (RUL): ~100 Cycles

--- E-WASTE REDUCTION IMPACT ASSESSMENT ---
Estimated Second-Life Market Value: $0.10
Estimated Environmental Benefit: 0.3 kg of CO₂ emissions saved
```

---

## Visualizations

### 1. **Workflow of the Prognostic System**

<img width="685" height="607" alt="Screenshot 2025-09-13 195557" src="https://github.com/user-attachments/assets/7aed37cb-a0a0-4bf9-8514-37ec04fb9ea1" />
 
 
> *Caption: Workflow of the prognostic system in the EV battery circular economy. Batteries at the end of first life are assessed, graded, repurposed, or recycled, directly reducing e-waste.*

### 2. **SOH Degradation Profiles**

<img width="856" height="458" alt="Screenshot 2025-09-11 230446" src="https://github.com/user-attachments/assets/117feea4-c4a8-4397-876a-b93d9be4cc5f" />

> *Caption: SOH degradation profiles for the 8 cells in the Oxford dataset. Used for model training and validation.*

### 3. **MLP Model Architecture**
<img width="386" height="547" alt="Screenshot 2025-09-11 230601" src="https://github.com/user-attachments/assets/47c991b2-8509-4522-a5ec-6d5b8728f0c2" />
 
> *Caption: Architecture of MLP used for SOH prediction.*

### 4. **Prediction Results**
<img width="1011" height="514" alt="Screenshot 2025-09-13 195839" src="https://github.com/user-attachments/assets/d5baa8f7-083a-4096-bff0-c1441097b94a" />
 
> *Caption: MATLAB plot comparing predicted vs. actual SOH values over cycles.*

---

## References

- L. D. H. King, “The future of electric vehicle batteries,” Nature Reviews Materials, 2021.
- J. B. Harper et al., “Flexible repurposing of electric vehicle batteries,” Energy & Environmental Science, 2019.
- G. R. G. L. Li et al., “A review on prognostics and health management of lithium-ion batteries,” J. Power Sources, 2021.
- S. S. S. Kumar, “ANN methods for SOH estimation of lithium-ion batteries,” J. Energy Storage, 2020.
- C. R. Birkl, “Diagnosis and Prognosis of Degradation in Lithium-Ion Batteries,” Oxford PhD thesis, 2017.

---

