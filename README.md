## Project Overview: MLP-Based Prognostic Model for RUL and SOH Assessment

This project demonstrates the development and validation of a Multilayer Perceptron (MLP)-based prognostic model for estimating the Remaining Useful Life (RUL) and State of Health (SOH) of battery cells, with a focus on applications in Battery Management Systems (BMS). The entire workflow and analysis are implemented in MATLAB, leveraging its powerful machine learning and data visualization capabilities.

### Problem Statement

Modern battery-operated systems, such as electric vehicles and stationary energy storage, require accurate prediction of battery health and lifetime for safe and efficient operation. RUL indicates how much longer a battery can perform reliably, while SOH provides a normalized measure of its current capacity relative to its original (new) state.

Traditional physics-based and empirical models for battery prognosis face challenges due to the complexity of degradation mechanisms, variations in operating conditions, and the need for extensive domain expertise. Data-driven approaches, especially neural networks like MLP, offer a flexible and effective alternative, learning patterns directly from historical cycling data.

### Solution Approach

#### Data Preprocessing

- **Battery Data Source**: The project utilizes publicly available battery cycling datasets, typically consisting of charge/discharge cycles, capacity measurements, voltage, current, and temperature readings.
- **Feature Engineering**: Relevant features such as cycle number, charge/discharge capacity, voltage features (e.g., mean, max, end-of-charge voltage), and temperature statistics are extracted.
- **Normalization & Splitting**: The dataset is normalized for efficient neural network training and split into training, validation, and test sets.

#### MLP Model Architecture

- **Network Structure**: The MLP consists of input, hidden, and output layers. The input layer receives processed features, hidden layers use nonlinear activation functions (e.g., ReLU, sigmoid), and the output layer predicts RUL and SOH values.
- **MATLAB Implementation**: MATLAB's Neural Network Toolbox is used to design, train, and evaluate the MLP architecture. Hyperparameters such as number of neurons, layers, learning rate, and regularization are tuned experimentally.

#### Model Training & Evaluation

- **Training**: The MLP is trained using a supervised regression approach, minimizing error between predicted and actual RUL/SOH values.
- **Validation**: Cross-validation is performed to select the best model and prevent overfitting.
- **Testing**: The trained model is tested on unseen data to assess generalization performance. Metrics such as Mean Absolute Error (MAE), Root Mean Square Error (RMSE), and correlation coefficient are reported.

#### Results Analysis

- **Performance**: The MLP-based model demonstrates high accuracy in predicting both RUL and SOH across different battery cells and operating conditions.
- **Visualization**: MATLAB plots show the comparison between predicted and true values over cycles, error distributions, and feature importance.

### MATLAB Workflow Highlights

- **Scripts & Functions**: The project is organized into MATLAB scripts/functions for data preprocessing, model training, evaluation, and visualization.
- **Reproducibility**: Key parameters and random seeds are set to ensure repeatable results.
- **Documentation**: Inline comments and documentation help users understand the workflow and experiment with different settings.

### Applications & Impact

- **Battery Management Systems (BMS)**: The approach can be integrated into real-time BMS for electric vehicles, drones, or grid storage, providing actionable health and lifetime insights.
- **Scalability**: The model can be adapted to various chemistries and operational profiles by retraining with relevant data.
- **Research & Education**: This repository serves as a reference for researchers and students interested in data-driven battery prognosis using MATLAB.

---

## Images from MATLAB 

1. **High-Level Workflow Diagram**  
  
   _<img width="741" height="634" alt="image" src="https://github.com/user-attachments/assets/431f7acd-920c-44fa-b5fe-5f4c5f19b4c5" />
_: Workflow of the prognostic system in the EV battery circular economy. When a
 battery reaches the end of its first life (SOH less than 80%), it is assessed by the MLP-based
 prognostic system. The system generates a Decision Support Report that grades the battery’s
 health. Based on this grade, batteries suitable for a second life (Grade B) are diverted to
 value-generating applications like home energy storage, directly reducing e-waste. Batteries
 at their true end-of-life (Grade C) are sent for responsible material recycling and resource
 recovery. This process transforms potential waste into a valuable asset.

2. **EV Battery Data Visualization**  
   
   _<img width="856" height="458" alt="image" src="https://github.com/user-attachments/assets/060e53b5-b633-4bb3-b852-16608e8ff893" />
:_SOH degradation profiles for the 8 cells in the Oxford dataset. This plot serves as
 the ground truth for model training and validation, illustrating the capacity fade over the cycle
 life.

3. **MLP Model Architecture Diagram**  
    
   _<img width="386" height="547" alt="image" src="https://github.com/user-attachments/assets/b29e8157-c688-4163-9028-7758181e2673" />
:_ A schematic of the neural network layers used (input, hidden, output).

4. **Results Comparison Plot**  
   
   _<img width="869" height="487" alt="image" src="https://github.com/user-attachments/assets/301e1324-5e7b-4690-a54b-a4598ae250e8" />
:_ MATLAB plot comparing true vs. predicted RUL/SOH over time/cycles.


```

---

