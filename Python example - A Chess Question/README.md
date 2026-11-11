# Chess Capture Checker
 
A small Python program that answers one chess question: **given 1 white piece and up to 16 black pieces on a board, which black pieces can the white piece capture?**

Positions can be entered by hand or generated randomly. The result is printed as a list and drawn as an SVG board, with capturable pieces and attacked squares highlighted.

<img width="872" height="686" alt="image" src="https://github.com/user-attachments/assets/a0e59827-d92e-4b2d-87d8-ce0205c307f4" />

## How to access the program:
### Google Colab:
- Open the [Shared Colab notebook](https://colab.research.google.com/drive/1AO_GTPkPm_Uo3iuLgvcA94q94dk6b8Qg?usp=sharing)
- Click **Connect** to start a runtime
- Click the **Run** button on the code cell (or press `Shift+Enter`)
- Type your answers in the input box that appears below the cell and press `Enter`

### VS Code:

Requires the **Jupyter** extension and the `chess` library in the Python environment you use.

`chess` library can be installed by typing `pip install chess` in the terminal

- Download and open `Chess_Question.ipynb`
- Click **Select Kernel** (top right) and choose the Python environment with `chess` installed
- Click the **Run** button on the code cell (or press `Shift+Enter`)
- Type your answers in the input box at the top of the VS Code window and press `Enter`

## Features
- Two input modes: **manual** entry or **random** generation (1 white rook or pawn and 16 black pieces on random squares)
  - In random generation, for black it generates 8 pawns, 1 king, 1 queen, 2 rooks, 2 knight and 2 bishops
- Input validation with clear error messages (unknown pieces, invalid or occupied squares, pawns on rank 1/8 are not allowed, more than one black king)
- Correct capture detection: blocked paths and pawn diagonal captures are handled by `python-chess` library
- Board image with highlights:
  - **strong red:** black pieces the white piece can capture
  - **translucent red:** every square the white piece attacks if nothing were blocking it
- Text summary of capturable pieces, e.g. `- Knight on f4`

## Usage
 
The program starts by asking for the input mode:
 
```
Enter pieces manually or generate randomly?
Enter - manual / random :
```
 
### Random mode

Type `random`. The program places a random white pawn or rook and a full set of 16 black pieces, then shows the result.

### Manual mode
 
Type `manual`, then:
 
**1. Enter the white piece** (pawn or rook):
 
```
Enter a white piece, can only be pawn or rook (example: pawn c2): rook d4
```
 
**2. Enter 1 to 16 black pieces**, one per line, and type `done` when finished:
 
```
Enter black piece #1 out of 16: king g8
Enter black piece #2 out of 16: pawn d7
Enter black piece #3 out of 16: done
```
 
**Input format:** `<piece> <square>`, not case-sensitive.
 
| Piece | Allowed for |
|---|---|
| `pawn`, `rook` | white and black |
| `knight`, `bishop`, `queen`, `king` | black only |
 
Squares use standard notation: file `a`-`h` followed by rank `1`-`8` (e.g. `e4`).
