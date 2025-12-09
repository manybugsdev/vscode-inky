# Ink Language Tutorial - Interactive RPG Adventure

## Overview

This tutorial (`tutorial.ink`) is a comprehensive, interactive guide to learning the Ink narrative scripting language through an RPG-themed adventure. It demonstrates all major Ink language features in a practical, engaging way.

## What You'll Learn

The tutorial covers 16 sections, each focusing on different Ink language features:

### 1. Basic Text and Choices
- Simple narrative text
- Basic choices with `*` (once-only) and `+` (sticky/reusable)
- Choice text and responses

### 2. Knots and Stitches
- **Knots** (`===`): Major story sections
- **Stitches** (`=`): Subsections within knots
- Navigation between story sections

### 3. Variables
- `VAR` for global variables (numbers, strings)
- `LIST` for enumerated states
- Variable declaration and initialization

### 4. Conditionals and Logic
- Conditional text: `{condition: text}`
- Conditional choices
- Variable comparisons and logic

### 5. Gathers and Weave
- **Gathers** (`-`): Converge multiple choice paths
- Weaving narrative threads back together
- Flow control after branches

### 6. Alternatives and Sequences
- **Alternatives**: `{option1|option2|option3}`
- **Sequences**: Cycling, stopping, and shuffling text
- Variations in repeated content

### 7. Temporary Variables and Logic
- `TEMP` variables with local scope
- Arithmetic operations
- Complex logic expressions

### 8. Advanced Conditionals
- Nested conditions
- `else` clauses
- Multi-level conditional logic

### 9. Functions
- Defining reusable functions
- Function parameters and return values
- Pure functions vs functions with side effects

### 10. Tunnels
- **Tunnels** (`->->`): Reusable story fragments
- Returning to caller with `->->`
- Divert and return flow pattern

### 11. Main Quest and Threads
- Complex story branching
- Multiple quest tracking
- State management with lists

### 12. Combat System with Lists
- `LIST` operations (add, remove, check)
- Enemy state tracking
- Inventory management

### 13. Combat Mechanics
- Turn-based combat implementation
- Health and damage calculation
- Victory and defeat conditions

### 14. Story Climax
- Bringing story threads together
- Consequence of earlier choices
- Dramatic story peaks

### 15. Multiple Endings and Tags
- Different story endings
- `#` tags for metadata
- Tracking story outcomes

### 16. Endings with Variations
- Variable-based ending variations
- Character class-specific outcomes
- Story statistics and achievements

## How to Use This Tutorial

1. **Open in VS Code**: Open `examples/tutorial.ink` in Visual Studio Code with the vscode-inky extension installed.

2. **Start Live Preview**: Click the preview icon (📖) in the editor toolbar or use the command palette to open "Ink: Open Preview"

3. **Play Through Interactively**: Make choices and see how different Ink features work in real-time.

4. **Read the Code**: The `.ink` file contains extensive comments explaining each feature as you encounter it.

5. **Experiment**: Try modifying the code to see how changes affect the story.

## Key Features Demonstrated

### Variables and State Management
```ink
VAR player_class = "Warrior"
VAR health = 100
VAR gold = 50

LIST inventory = sword, shield, potion
VAR items = ()
```

### Choices and Branching
```ink
* [Attack with sword]
    -> combat
* [Cast magic spell]
    -> magic_combat
+ [Run away]
    -> escape
```

### Conditionals
```ink
{player_class == "Warrior":
    You swing your mighty sword!
}
{health < 30:
    * [Drink healing potion]
        -> heal
}
```

### Functions and Tunnels
```ink
=== function calculate_damage(base_damage) ===
~ return base_damage + strength

=== healing_spring ===
You drink from the magical spring.
~ health = max_health
->->
```

## Story Structure

The tutorial follows a complete RPG adventure arc:

1. **Character Creation**: Choose your class (Warrior, Mage, or Rogue)
2. **Training**: Learn basic skills and receive starting equipment
3. **First Quest**: Accept a mission from the Guild
4. **Exploration**: Navigate through different locations
5. **Combat**: Engage in turn-based battles with enemies
6. **Choices**: Make decisions that affect the story
7. **Climax**: Face a challenging boss encounter
8. **Resolution**: Experience one of multiple possible endings

## Tips for Learning

- **Take Your Time**: Read the comments in the code to understand what each section does
- **Try Different Paths**: Play through multiple times with different choices
- **Modify and Experiment**: Change variables and see what happens
- **Check the Preview**: Watch how your changes affect the live preview
- **Reference the Documentation**: Visit [Ink Documentation](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md) for more details

## Variables Reference

### Player Stats
- `player_class`: Your chosen class (Warrior/Mage/Rogue)
- `strength`, `intelligence`, `agility`: Character attributes
- `health`, `max_health`: Hit points
- `gold`: Currency
- `experience`, `level`: Progression stats

### Tracking States
- `items`: Inventory list
- `dragon_quest`, `village_quest`: Quest progress
- `fame`: Reputation level
- `goblin_chieftain`: Enemy states

## Next Steps

After completing this tutorial, you'll be ready to:

- Create your own interactive stories in Ink
- Implement complex branching narratives
- Use variables and state management effectively
- Build game-like mechanics in narrative form
- Export your stories for use in games and applications

## Additional Resources

- [Ink Official Website](https://www.inklestudios.com/ink/)
- [Ink GitHub Repository](https://github.com/inkle/ink)
- [Writing with Ink Guide](https://github.com/inkle/ink/blob/master/Documentation/WritingWithInk.md)
- [Inkjs (JavaScript Runtime)](https://github.com/y-lohse/inkjs)
- [Inky Editor](https://github.com/inkle/inky)

Happy storytelling! 🎮📖
