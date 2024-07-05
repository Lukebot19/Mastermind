# Mastermind

Mastermind is a classic code-breaking game played between two players. The objective is for one player (the codebreaker) to guess the secret code set by the other player (the codemaker) within a certain number of turns. The secret code is a sequence of colored pegs, and in each turn, the codebreaker makes a guess at the sequence. Feedback is given in the form of colored or black and white pegs, indicating how many of the guessed pegs are of the correct color and in the correct position, or of the correct color but in the wrong position, respectively.

## How the Game Works

- **Setting Up**: The codemaker selects a sequence of colored pegs as the secret code. The number of pegs and colors can vary, but a common setup is four pegs with six different colors.
- **Playing**: The codebreaker attempts to guess the secret code. After each guess, the codemaker provides feedback with two types of indicators:
  - **Black pegs**: Indicate the number of pegs that are both of the correct color and in the correct position.
  - **White pegs**: Indicate the number of pegs that are of the correct color but in the wrong position.
- **Winning**: The game ends when the codebreaker guesses the correct sequence or runs out of turns.

## Algorithm for Computer as Codebreaker

For this implementation, the computer acts as the codebreaker using Donald Knuth's algorithm. The algorithm works as follows:

1. **Generate Possibilities**: Initially, generate all possible combinations of pegs according to the game's rules.
2. **First Guess**: Make an initial guess. A common strategy is to start with a guess that includes two pegs of one color and two pegs of another color.
3. **Feedback and Narrowing Down**: After each guess, use the feedback to eliminate all combinations from the list of possibilities that would not produce the same feedback if they were the secret code.
4. **Next Guess**: From the remaining possibilities, select the next guess. Knuth's algorithm suggests a method for selecting the next guess that minimizes the maximum number of possibilities that would need to be eliminated in the next step.
5. **Repeat**: Continue making guesses, receiving feedback, and narrowing down the possibilities until the secret code is guessed or no possibilities remain.

This algorithm is highly efficient, guaranteeing a solution within a certain number of guesses for any given code.

## Getting Started

To play the game or to delve into the code, clone this repository and follow the setup instructions provided in the subsequent sections. Whether you're interested in challenging the computer as a codemaker or studying the algorithmic approach used by the computer codebreaker, Mastermind offers a blend of strategy, logic, and fun.

Enjoy the game!

## Setup Instructions

Follow these steps to get the Mastermind game running on your system, whether you're using an emulator or a physical device through Android reverse debugging.

### Prerequisites

- Ensure you have Flutter installed on your system. If not, follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- An IDE with Flutter support (e.g., Visual Studio Code, Android Studio).

### Cloning the Repository

1. Open your terminal or command prompt.
2. Navigate to the directory where you want to clone the repository.
3. Run the following command:
```git clone https://github.com/Lukebot19/Mastermind.git```
4. Navigate into the cloned repository:
```cd mastermind-flutter```

### Running on an Emulator

1. Open your preferred IDE and open the project you just cloned.
2. Start your emulator.
3. In your IDE, select the emulator as the target device.
4. Run the app by clicking the "Run" button or by pressing `F5`.

### Running on a Physical Device through Android Reverse Debugging

1. Enable Developer Options and USB Debugging on your Android device.
2. Connect your device to your computer via USB.
3. Open a terminal or command prompt and navigate to your project directory.
4. Run the following command to check if your device is recognized:
```flutter devices```
5. If your device is listed, you can now run the app on your device with the following command:
```flutter run```
6. For reverse debugging (allowing the device to communicate with the localhost of your computer), run:
```adb reverse tcp:8080 tcp:8080```
Replace `8080` with the port number your local server is using, if different.

Now, you should be able to run the Mastermind game on your emulator or physical device. Enjoy exploring the game and its code!

### Troubleshooting

- If you encounter any issues with Flutter not recognizing your device, ensure that your device's driver is properly installed on your computer and that USB Debugging is enabled.
- For issues related to the Flutter setup, refer to the [Flutter documentation](https://flutter.dev/docs) for troubleshooting tips.
