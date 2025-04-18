# 🧱 Block Shooter

[![Verilog](https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge)](https://en.wikipedia.org/wiki/Verilog)
[![Platform](https://img.shields.io/badge/Platform-DE1--SoC-0078D7?style=for-the-badge)](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=836)
[![Display](https://img.shields.io/badge/Output-VGA%20&%207--Segment-yellow?style=for-the-badge)]()

A real-time arcade-style shooting game developed in **Verilog** and deployed on the **DE1-SoC FPGA**. The game features responsive player controls, dynamic enemy behavior, and real-time collision detection. Visuals are rendered via **VGA output**, while the 7-segment display tracks player score and health.

---

## 🚀 Features

### 🎮 Gameplay Mechanics
- Start screen prompting user to press `Space` to begin
- Player controls:
  - `A`: Move Left
  - `D`: Move Right
  - `Space`: Fire Bullet
- Enemies spawn at random intervals and fall downward
- Press `KEY0` to reset the game to the start screen at any time

### 💡 Game Logic
- Bullet hits remove enemies
- Enemy collision with player reduces health
- Difficulty increases as score rises (enemy speed increases)
- When health reaches 0:
  - Game over screen appears
  - Player can press `Space` to play again

---

## 🎨 VGA Display (Graphical Output)
- Real-time game graphics rendered via **VGA**
- Player, bullets, enemies, and background displayed visually
- Start screen and game over screen shown with text and animation

---

## 🔢 7-Segment Display (Numeric Output)
- Score is updated and displayed on the **7-segment display**
- Player health also shown numerically
- Both values update in real time based on gameplay

---

## 🛠 Tech Stack

- **Language**: Verilog HDL  
- **Platform**: DE1-SoC FPGA Board  
- **Output**: VGA (game visuals) & 7-segment display (score/health)  
- **Input**: Onboard keys & switches (movement, shoot, reset)

---

## 🔗 Links

- 🎥 **Video Demo**: [Watch on Google Drive](https://drive.google.com/file/d/1COoPDofs2tkl8vgkka4SR1U5thTGGrkh/view)  
- 💻 **Source Code**: [GitHub Repository](https://github.com/nathwung/block-shooter)
