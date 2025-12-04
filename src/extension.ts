import * as vscode from "vscode";
import { InkPreviewProvider } from "./previewProvider";

let previewProvider: InkPreviewProvider | undefined;

export function activate(context: vscode.ExtensionContext) {
  previewProvider = new InkPreviewProvider(context);

  context.subscriptions.push(
    vscode.commands.registerCommand("vscode-inky.openPreview", () => {
      previewProvider?.showPreview();
    })
  );

  // Auto-open preview when an .ink file is opened (optional)
  context.subscriptions.push(
    vscode.window.onDidChangeActiveTextEditor((editor) => {
      if (editor && editor.document.languageId === "ink") {
        // You can auto-open preview here if desired
        // previewProvider?.showPreview(editor.document);
      }
    })
  );

  context.subscriptions.push({
    dispose: () => previewProvider?.dispose(),
  });
}

export function deactivate() {
  previewProvider?.dispose();
}
