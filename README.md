# 🧱 Block Shooter (FPGA Game)

[![Verilog](https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge)](https://en.wikipedia.org/wiki/Verilog)
[![Platform](https://img.shields.io/badge/Platform-DE1--SoC-0078D7?style=for-the-badge)](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=836)
[![Display](https://img.shields.io/badge/Output-VGA%20+%207--Segment-yellow?style=for-the-badge)]()

A real-time arcade-style shooting game implemented in **Verilog** and deployed on an **FPGA (DE1-SoC)**, featuring VGA graphical output, 7-segment display integration for score and health, and dynamic difficulty.

---

## 🚀 Features

### 🎮 Gameplay Mechanics
- Start screen with “Press Space to Begin”
- Player movement using:
  - `A`: Move Left
  - `D`: Move Right
  - `Space`: Shoot bullet
- Enemies fall from the top at random intervals
- Press `KEY0` to reset the game anytime

### 🧠 Game Logic
- Bullets destroy enemies on collision
- Score increments on 7-segment display
- Enemies increase speed as score increases
- If an enemy hits the player:
  - Health decrements on 7-segment display
  - When health reaches 0, game over screen appears
  - Press `Space` to play again

### 📺 Hardware Integration
- VGA output for real-time graphical gameplay
- 7-segment display shows:
  - Current score
  - Remaining health

---

## 🛠 Tech Stack

- **Language**: Verilog HDL  
- **Platform**: DE1-SoC FPGA Board  
- **Output**: VGA display & 7-segment display  
- **Input**: Onboard keys (`KEY0`, `KEY[3:1]`) and switches for reset/start

---
