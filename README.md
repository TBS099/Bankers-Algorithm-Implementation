# 🏦 Banker's Algorithm in Bash

This is a simple **Banker's Algorithm** implementation written in **Bash**. It simulates resource allocation for multiple processes and determines whether the system is in a safe state.

---

## 🚀 Features

- User inputs:
  - Number of processes and resources
  - Allocated resources for each process
  - Maximum required resources per process
- Automatically calculates the **Need Matrix**
- Determines a **Safe Sequence** (if one exists)
- Identifies **Unsafe States**
- Allows dynamic addition of new processes and recalculates the system state

---

## 📋 How It Works

1. The script prompts for:
   - Number of resource types
   - Number of processes
   - Available instances of each resource
2. User inputs:
   - **Allocated** resources matrix
   - **Maximum** resource demand matrix
3. The script computes the **Need** matrix:  
   `Need = Maximum - Allocation`
4. It attempts to find a **safe sequence** using the Banker's Algorithm
5. If safe, it displays the sequence and allows:
   - Adding a new process
   - Rechecking for a safe state
6. If unsafe, it stops and notifies the user

---

## 🖥️ Usage

### 1. Clone the repository

```bash
git clone https://github.com/TBS099/bankers-algorithm-bash.git
cd bankers-algorithm-bash
```

### 2. Make the script executable

```bash
chmod +x bankers-algorithm-implementation.bash
```

### 3. Run the script

```bash
./bankers-algorithm-implementation.bash
```

Follow the prompts to enter process and resource information

---

## 📌 Example

```text
Enter number of resources: 3
Enter number of processes: 2
Enter available resources for r[0]: 3
Enter available resources for r[1]: 2
Enter available resources for r[2]: 2

Enter resources already allocated:
Enter value for P[0], R[0]: 1
...

Enter maximum resources needed:
Enter value for P[0], R[0]: 3
...

System is in a safe state.
Safe sequence: 1 0
```

---

## 📦 Dependencies

This is a pure **Bash** script — no external dependencies required.  
Works on any Unix-like system with Bash installed.

---

## 🛠️ File Structure

```bash
.
├── bankers_algorithm.sh   # Main Bash script
└── README.md              # Documentation
```

---

## 📄 License

This project is licensed under the **MIT License**.

---

## 🙌 Credits

Written by TBS099.
