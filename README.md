# vscode-inky

A Visual Studio Code extension that provides live preview for [Inkle's Ink](https://www.inklestudios.com/ink/) interactive narrative scripting language.

## Features

- **Live Preview**: View your Ink stories in real-time as you write them
- **Interactive Playthrough**: Make choices and navigate through your story directly in the preview
- **Auto-Reload**: Preview automatically updates when you save your .ink file
- **Error Display**: See compilation errors directly in the preview window
- **Restart Capability**: Easily restart your story from the beginning

## Usage

1. Open any `.ink` file in VS Code
2. Click the preview icon (📖) in the editor toolbar, or use the command palette (`Cmd+Shift+P` / `Ctrl+Shift+P`) and search for "Ink: Open Preview"
3. The preview will open in a side panel
4. Make changes to your .ink file and save - the preview will automatically update
5. Click on choices to navigate through your story
6. Click "Restart Story" at the end to play through again

## Example

Try the example story included in the `examples/sample.ink` file to see the extension in action!

## Requirements

This extension uses [inkjs](https://github.com/y-lohse/inkjs) to compile and run Ink stories. All dependencies are included with the extension.

## About Ink

Ink is a powerful narrative scripting language created by [Inkle](https://www.inklestudios.com/) for writing interactive fiction. It's used in games like *80 Days* and *Heaven's Vault*.

Learn more about Ink:
- [Ink Website](https://www.inklestudios.com/ink/)
- [Ink Repository](https://github.com/inkle/ink)
- [Inkjs (JavaScript Port)](https://github.com/y-lohse/inkjs)
- [Inky Editor](https://github.com/inkle/inky)

## Release Notes

### 0.0.1

Initial release:
- Live preview for .ink files
- Interactive story playthrough
- Auto-reload on file save
- Error handling and display

---

## Contributing

Found a bug or have a feature request? Please open an issue on the [GitHub repository](https://github.com/manybugsdev/vscode-inky).

**Enjoy writing interactive stories with Ink!**
