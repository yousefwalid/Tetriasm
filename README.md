<div align="center">
  <a href="https://github.com/yousefwalid/Tetriasm" rel="noopener">

  ![Tetriasm Logo](https://i.imgur.com/1eI772b.png)

  </a>
</div>

# Tables of Contents
- [Tables of Contents](#tables-of-contents)
- [Tetriasm](#tetriasm)
- [How to run?](#how-to-run)
- [Game rules](#game-rules)
- [Screenshots](#screenshots)
  - [Name screen](#name-screen)
  - [Main Menu](#main-menu)
  - [Chat Menu](#chat-menu)
  - [Game start](#game-start)
  - [Midgame](#midgame)
  - [Gameplay footage](#gameplay-footage)
- [Single PC version](#single-pc-version)
- [Contributors](#contributors)
- [License](#license)

# Tetriasm

Tetriasm is a two-player competitive Tetris game coded in **X86 assembly** aimed for multiplayers via serial communication ports.

# How to run?

To run the game you need a DOS emulator, you can use [DOSBOX](https://www.dosbox.com/)

1. Start by installing DOSBOX
2. Connect two PCs using a Serial COM port or use [Virtual Serial Port Driver](https://www.virtual-serial-port.org/) to simulate two PCs
     - You can find a tutorial on connecting virtual serial port to DOSBOX [here](https://www.youtube.com/watch?v=xIyldfZGNAQ)
3. Start the game on each device
4. Press F1 to send a chat invite or accept one, or F2 to send a game invite or accept one.

# Game rules

- Start by stacking blocks on top of each other, using arrow keys to move the piece.
- Whenever you completely fill a row, it will be removed from your grid and an irremovable gray row will be added to your opponent's grid.
- Remove your rows quickly to push your opponents pieces up.
- The first one to fill to the top loses.
- Every 4 rows you clear, will provide you with a random powerup that you can use with number keys 1 through 5.
  - The available powerups are:
    1. Freeze: will stop your opponent from rotating his piece for a while
    2. Speed Up: will make your opponent's piece fall faster
    3. Remove 4 Lines: will remove 4 lines from the bottom of your screen
    4. Change Piece: will change your current piece to another one
    5. Insert 2 Lines: will push 2 lines on your opponents screen.


# Screenshots

## Name screen

![](https://i.imgur.com/X3IlQL7.png)

## Main Menu

![](https://i.imgur.com/OSs1DGV.png)

## Chat Menu

![](https://i.imgur.com/ifb0OuD.png)

## Game start

![](https://i.imgur.com/QD8FoPi.png)

## Midgame

![](https://i.imgur.com/VesM785.png)

## Gameplay footage

![](https://i.imgur.com/keeQUHw.gif)

# Single PC version

You can find a multiplayer version that runs on only one PC instead through [this commit](https://github.com/yousefwalid/Tetriasm/tree/e091eb553aaf8be2228609416fe42f4942442861).

The controls are WASD for one player and arrows for the other.

# Contributors 

<table>
  <tr>
    <td align="center">
    <a href="https://github.com/yousefwalid" target="_black">
    <img src="https://avatars.githubusercontent.com/u/40529934?v=4" width="150px;" alt="youssef walid"/>
    <br />
    <sub><b>Youssef Walid</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/AhmedHisham552" target="_black">
    <img src="https://avatars.githubusercontent.com/u/40614397?v=4" width="150px;" alt="ahmed hisham"/>
    <br />
    <sub><b>Ahmed Hisham</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/nasserahmed009" target="_black">
    <img src="https://avatars.githubusercontent.com/u/40793996?v=4" width="150px;" alt="ahmed nasser"/>
    <br />
    <sub><b>Ahmed Nasser</b></sub></a>
    </td>
    <td align="center">
    <a href="https://github.com/mohsayed27" target="_black">
    <img src="https://avatars.githubusercontent.com/u/46090694?v=4" width="150px;" alt="muhammed sayed"/>
    <br />
    <sub><b>Muhammed Sayed</b></sub></a>
    </td>
    
    
  </tr>
 </table>

# License

> This software is licensed under MIT License, See License for more information.