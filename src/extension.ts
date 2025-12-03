import * as vscode from "vscode";

export function activate(context: vscode.ExtensionContext) {
  context.subscriptions.push(
    vscode.commands.registerCommand("vscode-inky.openPreview", () => {
      vscode.window.showInformationMessage("Hello World from vscode-inky!");
    })
  );
}

export function deactivate() {}
